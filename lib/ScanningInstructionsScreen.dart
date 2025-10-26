import 'package:flutter/material.dart';

class ScanningInstructionsScreen extends StatelessWidget {
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


          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Scanning Instructions",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),


                  Text(
                    "Follow these instructions:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InstructionRow("Place your book on a stable,clean and flat surface."),
                        InstructionRow("Hold your device camera parallel to the book page."),
                        InstructionRow("Avoid direct reflections and shadows on the page.  ."),
                        InstructionRow("Scan your book in a well-lightning environment  ."),
                        InstructionRow("Wait for the camera to focus on the text."),
                        InstructionRow("Ensure  book pages are flat and smooth."),
                        InstructionRow("Avoid Page Wrinkles or curved Edges."),
                        InstructionRow("Maintain an appropriate distance from the page."),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ✅ Instruction Row Widget (Bullet Image + Text)
class InstructionRow extends StatelessWidget {
  final String text;

  InstructionRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/images/tickimg.png",
            width: 20,
            height: 20,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
