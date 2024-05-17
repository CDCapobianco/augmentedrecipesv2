import 'package:flutter/material.dart';
import 'package:ultralytics_yolo_example/view/camera_view.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background video widget
          const BackgroundVideoWidget(),
          // Positioned text
        Positioned(
          top: 40, // Adjust top position as needed
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star,
                color: Colors.white,
                size: 20, // Adjust the size of the star icon
              ),
              const SizedBox(width: 5), // Add space between the star and the text
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '2+ millions',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 18, // Adjust the font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Change text color to white
                      ),
                    ),
                  ),
                  Text(
                    'Premium Recipes',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        fontSize: 14, // Adjust the font size
                        fontWeight: FontWeight.w300,
                        color: Colors.white, // Change text color to white
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
          // Centered content
Center(
  child: Container(
    height: 100, // Adjust the height as needed
    child: TypeWriterText(
      text: Text(
        'What\'s for dinner \n tonight?', // Add a newline before 'tonight'
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Change text color to white
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black,
                offset: Offset(2, 2),
              ),
            ],
          ),
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
                    MaterialPageRoute(builder: (context) => const CameraView()),
                  );
                },
                icon: const Icon(Icons.arrow_forward),
                label: const Text(
                  'Get Started',
                  style: TextStyle(fontSize: 15),
                  
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Set text color to white
                  backgroundColor: Color.fromARGB(255, 0, 0, 0), // Set button color to red
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