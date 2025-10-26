import 'package:flutter/material.dart';

class UnityScreen extends StatefulWidget {
  @override
  _UnityScreenState createState() => _UnityScreenState();
}

class _UnityScreenState extends State<UnityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AR Scanner")),
      body: Center(
        child: Text(
          'Hello, Flutter!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
