import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo_example/app.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(
    UncontrolledProviderScope(
      container: ProviderContainer(),
      child: const MainPage(),
    ),
  );
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Viewer',
      debugShowCheckedModeBanner: false, // Remove debug banner
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const WelcomePage(),
    );
  }
}



class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          const BackgroundVideoWidget(),
          // Centered content
          Center(
            child: Container(
              height: 200, // Adjust the height as needed
              child: const TypeWriterText(
                text: Text(
                  'What\'s for dinner tonight?',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Change text color to white
                  ),
                  textAlign: TextAlign.center, // Center text horizontally
                ),
                duration: Duration(milliseconds: 75),
              ),
            ),
          ),
          // Positioned button
          Positioned(
            bottom: 40, // Adjust bottom position as needed
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  'Start Cooking',
                  style: TextStyle(fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Set text color to white
                  backgroundColor: Colors.red, // Set button color to red
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30), // Set button padding
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Set button border radius
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class BackgroundVideoWidget extends StatefulWidget {
  const BackgroundVideoWidget({super.key});

  @override
  State<BackgroundVideoWidget> createState() => _BackgroundVideoWidgetState();
}

class _BackgroundVideoWidgetState extends State<BackgroundVideoWidget> {
  late final VideoPlayerController videoController;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.asset('assets/food_clips/IntroMenu_Portrait.mp4')
      ..initialize().then((_) {
        videoController.play();
        videoController.setLooping(true);
        videoController.setVolume(0.0);
      });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: 9.0,
        height: 16.0,
        child: VideoPlayer(videoController),
      ),
    );
  }
}