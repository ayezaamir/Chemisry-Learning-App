import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'attempt_data.dart';
import 'NotificationService.dart';

class PerformanceReportScreen extends StatefulWidget {
  final String userName;

  const PerformanceReportScreen({required this.userName});
  @override
  _PerformanceReportScreenState createState() => _PerformanceReportScreenState();
}

class _PerformanceReportScreenState extends State<PerformanceReportScreen> {
  List<Attempt> quizResults = [];
  String userName = '';

  @override
  void initState() {
    super.initState();
    loadUserInfo();
    loadQuizResults();
  }

  Future<void> loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = widget.userName;
    });
  }

  Future<void> loadQuizResults() async {
    List<Attempt> attempts = await AttemptStorage.getAttempts(widget.userName);
    setState(() {
      quizResults = attempts.reversed.toList();
    });

    if (quizResults.length >= 2) {
      final latest = quizResults[0];
      final previous = quizResults[1];
      if (latest.score > previous.score) {
        NotificationService.showNotification(
          "🎉 Great Job!",
          "Your performance has improved. Keep it up! 💪",
        );
      }
    }
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text("Performance Report",
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Text("Name: $userName"),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Date', 'Score', 'Total'],
                data: quizResults.map((result) => [
                  result.date ?? '',
                  result.score.toString(),
                  result.total.toString(),
                ]).toList(),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/performance_report.pdf");
    await file.writeAsBytes(await pdf.save());
    await Printing.sharePdf(bytes: await pdf.save(), filename: "performance_report.pdf");
  }

  Color getBarColor(int score, int total) {
    double percent = score / total;
    if (percent < 0.5) {
      return Colors.red;
    } else if (percent < 0.75) {
      return Colors.orange;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Performance Report',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            if (userName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "Welcome, $userName",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            SizedBox(height: 16),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Date', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Score', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: quizResults
                    .map((result) => DataRow(cells: [
                  DataCell(Text(result.date ?? '')),
                  DataCell(Text(result.score.toString())),
                  DataCell(Text(result.total.toString())),
                ]))
                    .toList(),
              ),
            ),
            SizedBox(height: 30),

            if (quizResults.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                child: Text(
                  "Quiz Scores Graph",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),

            if (quizResults.isNotEmpty)
              Container(
                height: 300,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: quizResults.map((e) => e.total.toDouble()).reduce((a, b) => a > b ? a : b) + 5,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.black87,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          return BarTooltipItem(
                            'Quiz ${group.x + 1}\nScore: ${rod.toY}',
                            TextStyle(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          getTitlesWidget: (value, meta) => Text('${value.toInt()}'),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            int index = value.toInt();
                            if (index >= 0 && index < quizResults.length) {
                              return Text("Q${index + 1}", style: TextStyle(fontSize: 12));
                            }
                            return Text('');
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                    barGroups: quizResults.asMap().entries.map((entry) {
                      int index = entry.key;
                      Attempt result = entry.value;
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: result.score.toDouble(),
                            color: getBarColor(result.score, result.total),
                            width: 20,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),

            if (quizResults.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text("No quiz attempts found."),
              ),

            SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: generatePDF,
              icon: Icon(Icons.download, color: Colors.white),
              label: Text("Download PDF", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
