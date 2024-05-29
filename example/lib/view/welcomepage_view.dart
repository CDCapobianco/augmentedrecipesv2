import 'package:flutter/material.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ultralytics_yolo_example/view/camera_view.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
                      key: const Key('premiumRecipesText'),
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
                      key: const Key('premiumRecipesSubtitle'),
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
            child: SizedBox(
              height: 100, // Adjust the height as needed
              child: TypeWriterText(
                text: Text(
                  'What\'s for dinner \n tonight?', // Add a newline before 'tonight'
                  key: const Key('whatsForDinnerText'),
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
                duration: const Duration(milliseconds: 75),
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
                key: const Key('getStartedButton'),
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
                  backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Set button color to black
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
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;
      final isPortrait = size.height > size.width;
      final videoAsset = isPortrait
          ? 'assets/food_clips/IntroMenu_Portrait.mp4'
          : 'assets/food_clips/IntroMenu_Landscape.mp4';

      _videoController = VideoPlayerController.asset(videoAsset)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _videoController!.play();
              _videoController!.setLooping(true);
              _videoController!.setVolume(0.0);
            });
          }
        });
    });
  }

  @override
  void dispose() {
    _videoController?.dispose(); // Dispose the video controller properly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    final videoSize = isPortrait ? const Size(9.0, 16.0) : const Size(16.0, 9.0);

    return _videoController?.value.isInitialized ?? false
        ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: videoSize.width,
              height: videoSize.height,
              child: VideoPlayer(_videoController!),
            ),
          )
        : const Center(child: CircularProgressIndicator());
  }
}
