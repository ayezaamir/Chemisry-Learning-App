import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ScanTutorialScreen extends StatefulWidget {
  @override
  _ScanTutorialScreenState createState() => _ScanTutorialScreenState();
}

class _ScanTutorialScreenState extends State<ScanTutorialScreen> {
  final List<String> videoIds = [
    "Qw7HJPol8ZQ", // Video 1
    "HmWwRoVyoF4", // Video 2
  ];

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videoIds[0], // Default first video
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  void _playVideo(String videoId) {
    _controller.load(videoId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan Tutorial",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
        centerTitle: true,
     ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            "assets/images/mainimg.png", // Replace with your image path
            fit: BoxFit.cover,
          ),

          Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Click on Video 1 or Video 2 to get an idea of how to scan from the book.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),

              // Video Player
              YoutubePlayer(
                controller: _controller,
                showVideoProgressIndicator: true,
                progressIndicatorColor: Colors.red,
              ),
              SizedBox(height: 20),

              Text(
                "Scan Tutorial Videos",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 10),

              // Buttons with Blue Color
              ElevatedButton(
                onPressed: () => _playVideo(videoIds[0]),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue button color
                ),
                child: Text("Play Video 1",style: TextStyle(color: Colors.white),),
              ),
              SizedBox(height: 10),

              ElevatedButton(
                onPressed: () => _playVideo(videoIds[1]),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue button color
                ),
                child: Text("Play Video 2",style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
