import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoGuidePage extends StatefulWidget {
  const VideoGuidePage({Key? key}) : super(key: key);

  @override
  _VideoGuidePageState createState() => _VideoGuidePageState();
}

class _VideoGuidePageState extends State<VideoGuidePage> {
  // List of YouTube video URLs and their names
  final List<Map<String, String>> _videos = [
    {'title': 'Butt Kick', 'url': 'https://youtu.be/e4cnI7eVKRw?si=SlmP9r2BdKnUmpYe'},
    {'title': 'High Knees', 'url': 'https://youtu.be/cnIf7nvrdlg?si=RdA0XmlPgBAX9Tbi'},
    {'title': 'Leg Swing', 'url': 'https://youtu.be/qkPcARrI-F0?si=oulzU7PuUkqsh5Pg'},
    {'title': 'Warking lunges', 'url': 'https://youtu.be/LRoSqkvpj10?si=R0F6pR_wyA6SVEGv'},
    {'title': 'Arm Circles', 'url': 'https://youtu.be/UVMEnIaY8aU?si=TRV05d1CAoU7BPnA'},

    // Add more YouTube video URLs here
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Warmup Video Guide",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              "Welcome to the WARMUP Video Guide",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),

            // Scrollable Container for YouTube Video List
            Container(
              height: 800,
              color: Colors.grey[200],
              child: ListView.builder(
                itemCount: _videos.length,
                itemBuilder: (context, index) {
                  return YouTubeVideoTile(
                    videoUrl: _videos[index]['url']!,
                    title: _videos[index]['title']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Set initial index to Exercise Page
        onTap: (index) {
          // Handle navigation here based on index
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/home');
              break;
            case 1:
              Navigator.pushNamed(context, '/exercise');
              break;
            case 2:
              Navigator.pushNamed(context, '/warmUp');
              break;
            case 3:
              Navigator.pushNamed(context, '/userProfile');
              break;
            default:
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.black),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center, color: Colors.black),
            label: 'Exercise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run, color: Colors.black),
            label: 'Warm Up',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Colors.black),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class YouTubeVideoTile extends StatefulWidget {
  final String videoUrl;
  final String title;

  const YouTubeVideoTile({Key? key, required this.videoUrl, required this.title}) : super(key: key);

  @override
  _YouTubeVideoTileState createState() => _YouTubeVideoTileState();
}

class _YouTubeVideoTileState extends State<YouTubeVideoTile> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    String videoId = YoutubePlayer.convertUrlToId(widget.videoUrl)!;
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(widget.title),
        ),
        Container(
          height: 200,
          child: YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
