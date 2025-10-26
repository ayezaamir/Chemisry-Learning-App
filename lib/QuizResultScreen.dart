import 'package:flutter/material.dart';
import 'QuizWelcomeScreen.dart';
import 'attempt_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizResultScreen extends StatefulWidget {
  final int score;
  final int total;
  final String userName;


  QuizResultScreen({required this.score, required this.total,required this.userName,});

  @override
  _QuizResultScreenState createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  @override
  void initState() {
    super.initState();
    _saveAttemptAndShowAlert();
  }

  Future<void> _saveAttemptAndShowAlert() async {
    final attempt = Attempt(
      score: widget.score,
      total: widget.total,
      date: DateTime.now().toString().split(' ')[0],
    );
    await AttemptStorage.saveAttempt(widget.userName, attempt);

    // Show alert after saving
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Performance Saved!"),
          content: Text("Your performance report has been recorded."),
          actions: [
            TextButton(
              child: Text("OK"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/mainimg.png",
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your Score: ${widget.score} / ${widget.total}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF006EE9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizWelcomeScreen(userName: widget.userName),
                        ),
                      );
                    },
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Center(
                            child: Text(
                              'Retry',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.refresh,
                              color: Color(0xFF006EE9),
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
