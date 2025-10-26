import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoTutorialScreen extends StatefulWidget {
  @override
  _VideoTutorialScreenState createState() => _VideoTutorialScreenState();
}

class _VideoTutorialScreenState extends State<VideoTutorialScreen> {
  final List<Map<String, String>> videos = [
    {
      'title': 'Different Types of Covalent Bond',
      'id': 'qmvbq5VgEuI',
    },
    {
      'title': 'Difference Between polar & Nonpolar covalent Bond',
      'id': 'VFhmmskR1DA',
    },
    {
      'title': 'Ionic Bonds',
      'id': 'j5M9_qoGKXY',
    },
    {
      'title': 'Covalent vs Ionic with example of NaCl',
      'id': 'OTgpN62ou24',
    },
    {
      'title': 'Types of chemical Bonding',
      'id': 'ttEBGT0CMsQ',
    },
    {
      'title': 'Dipole-Dipole interactions',
      'id': 'kqvlVuycPi0',
    },
    {
      'title': 'Coordinate covalent bond',
      'id': 'm5cDbtdokqY',
    },
    {
      'title': 'Metalic bond',
      'id': '9TAkUkrphdg',
    },
    {
      'title': 'Chemical bonding',
      'id': '5gEWOh630b8',
    },
    {
      'title': 'Reaction between magnesium and oxygen',
      'id': '1pKnKNhv0SY',
    },
  ];

  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: videos[0]['id']!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  void _loadVideo(String videoId) {
    _controller.load(videoId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Tutorials", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/mainimg.png",
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: 10),
                Text(
                  "Click on a topic to watch a tutorial video.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 10),
                YoutubePlayer(
                  controller: _controller,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.red,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Container(
                    color: Colors.white.withOpacity(0.75), // Optional: Add slight white overlay
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: videos.length,
                      separatorBuilder: (context, index) => Divider(color: Colors.grey),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Icon(Icons.play_circle_fill, color: Colors.blue),
                          title: Text(
                            videos[index]['title']!,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black),
                          ),
                          onTap: () => _loadVideo(videos[index]['id']!),
                        );
                      },
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
