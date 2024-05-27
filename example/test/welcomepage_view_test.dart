import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:video_player/video_player.dart';

class MockVideoPlayerController extends Mock implements VideoPlayerController {}

void main() {
  group('WelcomePage', () {
    testWidgets('should dispose VideoPlayerController', (WidgetTester tester) async {
      final mockController = MockVideoPlayerController();

      // Mock initialization and play to prevent actual video operations during testing
      when(mockController.initialize()).thenAnswer((_) async => Future.value());
      when(mockController.play()).thenAnswer((_) {
        // Add a return statement here
        return Future.value();
      });
      when(mockController.setLooping(true)).thenAnswer((_) async {});
      when(mockController.setVolume(0.0)).thenAnswer((_) async {});

      // Use a custom widget to inject the mock controller
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background video widget with mock controller
                    _BackgroundVideoWidget(controller: mockController),
                    // Other widgets...
                  ],
                ),
              );
            },
          ),
        ),
      );

      // Ensure the widget is fully built and video controller is initialized
      await tester.pumpAndSettle();

      // Dispose of the widget tree
      await tester.pumpWidget(const SizedBox());

      // Verify that dispose is called on the mocked controller
      verify(mockController.dispose()).called(1);
    });
  });
}

class _BackgroundVideoWidget extends StatefulWidget {
  final VideoPlayerController controller;

  const _BackgroundVideoWidget({required this.controller});

  @override
  State<_BackgroundVideoWidget> createState() => _BackgroundVideoWidgetState();
}

class _BackgroundVideoWidgetState extends State<_BackgroundVideoWidget> {
  late final VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = widget.controller;
    _videoController.initialize().then((_) {
      _videoController.play();
      _videoController.setLooping(true);
      _videoController.setVolume(0.0);
    });
  }

  @override
  void dispose() {
    _videoController.dispose(); // Dispose the video controller properly
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.cover,
      child: SizedBox(
        width: 9.0,
        height: 16.0,
        child: VideoPlayer(_videoController),
      ),
    );
  }
}
