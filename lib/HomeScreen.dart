import 'package:flutter/material.dart';
import 'AIChemistryAssistant.dart';
import 'PerformanceReportScreen.dart';
import 'ScanTutorialScreen.dart';
import 'ScanningInstructionsScreen.dart';
import 'StudentData.dart';
import 'SettingsScreen.dart';
import 'QuizWelcomeScreen.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:url_launcher/url_launcher.dart';

import 'VideoTutorialScreen.dart'; // Required to open download link

class HomeScreen extends StatefulWidget {
  final String userName;

  HomeScreen({required this.userName});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      SettingsScreen(userName: widget.userName),
      HomeContent(userName: widget.userName),
      StudentData(userName: widget.userName),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final String userName;

  HomeContent({required this.userName});

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();

  final List<CategoryItem> categories = [
    CategoryItem("Scan & Generate AR", "assets/images/arimg.png", isScan: true),
    CategoryItem("Scanning Instructions", "assets/images/scanimg.png", isScanningInstructions: true),
    CategoryItem("AI Chemistry Assistant", "assets/images/aiimage.png", isAI_Assistant: true),
    CategoryItem("Quizzes & Assessments", "assets/images/quizzesimg.png", isQuiz: true),
    CategoryItem("Performance Report", "assets/images/performanceimg.png", isreport: true),
    CategoryItem("Topics Videos", "assets/images/topicvidimg.png", istopicvideos: true),
    CategoryItem("Scan Tutorial", "assets/images/scantuimg.png", isScanTutorial: true),
  ];

  List<CategoryItem> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    filteredCategories = categories;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredCategories = categories;
      } else {
        filteredCategories = categories
            .where((item) => item.title.toLowerCase().contains(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Welcome, ${widget.userName}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("Find your lessons today!", style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search now...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Categories", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Image.asset("assets/images/catoimg.png", height: 22, width: 22),
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: filteredCategories.isNotEmpty
                  ? GridView.builder(
                itemCount: filteredCategories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  return CategoryCard(category: filteredCategories[index],userName: widget.userName,);
                },
              )
                  : Center(
                child: Text("No results found", style: TextStyle(fontSize: 18, color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final String title;
  final String imagePath;
  final bool isScan;
  final bool isScanTutorial;
  final bool isScanningInstructions;
  final bool isQuiz;
  final bool isreport;
  final bool isAI_Assistant;
  final bool istopicvideos;

  CategoryItem(this.title, this.imagePath,
      {this.isScan = false,
        this.isScanTutorial = false,
        this.isScanningInstructions = false,
        this.isQuiz = false,
        this.isreport = false,
        this.isAI_Assistant = false,
        this.istopicvideos= false,
      });
}

class CategoryCard extends StatelessWidget {
  final CategoryItem category;
  final String userName;

  CategoryCard({required this.category,required this.userName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (category.isScan) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ARLaunchScreen()));
        } else if (category.isScanTutorial) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ScanTutorialScreen()));
        } else if (category.isScanningInstructions) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ScanningInstructionsScreen()));
        } else if (category.isQuiz) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => QuizWelcomeScreen(userName:userName)));
        } else if (category.isreport) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PerformanceReportScreen(userName: userName)));
        } else if (category.isAI_Assistant) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AIChemistryAssistant()));
        }
        else if (category.istopicvideos) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => VideoTutorialScreen()));
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Theme.of(context).cardColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(category.imagePath, height: 60),
            SizedBox(height: 8),
            Text(
                category.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge!.color, // dynamic text color
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ))
          ],
        ),
      ),
    );
  }
}

class ARLaunchScreen extends StatelessWidget {
  const ARLaunchScreen({super.key});

  // -------------------- SCAN 1 --------------------
  void showDownloadPopupScan1(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Download Required"),
        content: Text(
          "Please download AR Scan 1 APK before proceeding. Click Download or press Done if already installed.",
        ),
        actions: [
          TextButton(
            child: Text("Download"),
            onPressed: () async {
              const url = 'https://pixeldrain.com/u/PWQRAejs';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not open download link.")),
                );
              }
            },
          ),
          ElevatedButton(
            child: Text("Done"),
            onPressed: () {
              Navigator.of(context).pop();
              launchARApp1();
            },
          ),
        ],
      ),
    );
  }

  void launchARApp1() async {
    final intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      package: 'com.ayeza.chemistryapp',
      componentName: 'com.unity3d.player.UnityPlayerActivity',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    try {
      await intent.launch();
    } catch (e) {
      print("Error launching AR Unity app 1: $e");
    }
  }

  // -------------------- SCAN 2 --------------------
  void showDownloadPopupScan2(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Download Required"),
        content: Text(
          "Please download AR Scan 2 APK before proceeding. Click Download or press Done if already installed.",
        ),
        actions: [
          TextButton(
            child: Text("Download"),
            onPressed: () async {
              const url = 'https://pixeldrain.com/u/kexTVTDG?download';
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Could not open download link.")),
                );
              }
            },
          ),
          ElevatedButton(
            child: Text("Done"),
            onPressed: () {
              Navigator.of(context).pop();
              launchARApp2();
            },
          ),
        ],
      ),
    );
  }

  void launchARApp2() async {
    final intent = AndroidIntent(
      action: 'android.intent.action.MAIN',
      package: 'com.ayeza.booktest2',
      componentName: 'com.unity3d.player.UnityPlayerActivity',
      flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    try {
      await intent.launch();
    } catch (e) {
      print("Error launching AR Unity app 2: $e");
    }
  }

  // -------------------- UI --------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F8FE),
      appBar: AppBar(
        title: Text("Augmented Reality Scanner",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Welcome to the AR Chemistry Scanner!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "You can scan chemistry diagrams or molecules using two different AR scanners.\n\n"
                  "- AR Scan 1 .\n"
                  "- AR Scan 2 .\n\n"
                  "Press any button below to begin scanning.",

              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            SizedBox(height: 20),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: [
              TextSpan(
                text: "🔊 Note: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text:
                "For better understanding of the model explanation through voice, please use handsfree or earphones while scanning.",
              ),
            ],
          ),
          textAlign: TextAlign.justify,),
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [

                  Text(
                    "We cover the chapter *Chemical Bonding* from book pg 72 to 87, and here's how the content is organized:\n",
                    style: TextStyle(fontSize: 16,color: Colors.black),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: Image.asset(
                      'assets/images/chembook.jpeg', //  image path
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => showDownloadPopupScan1(context),
                    icon: Icon(Icons.camera, color: Colors.white),
                    label: Text("Start AR Scan 1", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  // ✅ Instructional text

                  Text(
                    "AR Scan 1 Topics:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '''1. Concept of donor and acceptor
2. Example of hydrogen bonding
3. Types of covalent bond
4. Formation of polar covalent bond (HCl example)
5. Polar covalent bond
6. Non-polar covalent bond
7. Reaction between ammonia and hydrogen chloride
8. Triple covalent bond in ethyne molecule
9. Double covalent bond in ethene molecule
10. Ionic compounds
11. Formation of nitrogen molecule
12. Formation of oxygen molecule
13. Nature of bonding and properties
14. Do you know (malleable and ductile)
15. Reaction between magnesium and oxygen
16. Why do atoms form chemical bond
17. Ionic bonds
18. Types of chemical bonds
19. The reaction between sodium and chlorine
20. Formation of chemical bond
21. Double covalent bond
22. Formation of single covalent bond (HCl & methane)
23. Formation of chlorine molecule
24. Covalent bond
25. Do you know (pg 77 in given PDFs)
26. Polar and non-polar covalent bond
27. Single covalent bond
28. What are valence electrons
29. Types of covalent bonds
30. Reaction between sodium and chlorine''',
                    style: TextStyle(fontSize: 15, height: 1.5,color: Colors.black),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: () => showDownloadPopupScan2(context),
                    icon: Icon(Icons.camera_alt_outlined, color: Colors.white),
                    label: Text("Start AR Scan 2", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "AR Scan 2 Topics:",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
    '''1. Example of dipole-dipole interaction
2. (Do you know) pg 81 in given pdf
3. Metallic bond
4. Dipole-Dipole interaction
5. Concept of donor and acceptor
6. Coordinate covalent bond or dative covalent bond''',
style: TextStyle(fontSize: 15, height: 1.5,color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "In case the book is not available, you can open and save it manually and You can also open this link on your PC and scan it through the app for AR experience.",
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),

                  TextButton.icon(
                    onPressed: () async {
                      final url = Uri.parse('https://ebooks.stbb.edu.pk/storage/uploads/books/475930529.pdf');
                      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
                        throw 'Could not launch $url';
                      }
                    },
                    icon: Icon(Icons.picture_as_pdf, color: Colors.red),
                    label: Text(
                      "Open Chemistry Book PDF",
                      style: TextStyle(color: Colors.blue, fontSize: 16, decoration: TextDecoration.underline),
                    ),
                  ),

                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}