import 'package:flutter/material.dart';
import 'dart:async';

import 'StudentRegistration.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int _imageIndex = 0; // Image toggle ke liye index
  List<String> atomImages = [
    'assets/images/atomimg.png',
    'assets/images/moleimg.png',
  ];

  @override
  void initState() {
    super.initState();
    // Navigate to the next screen after 8 seconds
    Timer(Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentRegistration()),
      );
    });

    // Atom image ko har 2 seconds change karne ka animation effect
    Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _imageIndex = (_imageIndex + 1) % atomImages.length;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen background image
          Image.asset(
            'assets/images/mainimg.png',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 120), // Book ko neeche move karne ke liye
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/bookimg.png',
                    width: 300,
                    height: 300,
                  ),
                  Positioned(
                    bottom: 190,
                    left: 0,
                    right: -30, // Atom image ko thora right shift kiya
                    child: AnimatedSwitcher(
                      duration: Duration(seconds: 1), // Smooth transition effect
                      child: Image.asset(
                        atomImages[_imageIndex], // Yeh dynamically change hoti rahegi
                        key: ValueKey<int>(_imageIndex), // Key zaroori hai animation ke liye
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Text section
              Column(
                children: [
                  Text(
                    "Let's Explore Chemistry",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5), // Yeh space adjust karega
                  Text(
                    "See Molecules Come to Life in AR!",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: Text('Welcome to the Chemistry App!'),
      ),
    );
  }
}
