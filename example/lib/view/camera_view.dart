import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo_example/controller/api_controller.dart';
import 'package:ultralytics_yolo_example/controller/permissions_controller.dart';
import 'package:ultralytics_yolo_example/utils/query_provider.dart';
import 'package:ultralytics_yolo_example/view/detect_view.dart';
import 'package:ultralytics_yolo_example/view/recipeslist_view.dart';
import 'package:visibility_detector/visibility_detector.dart';

class CameraView extends ConsumerStatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  ConsumerState<CameraView> createState() => _CameraViewState();

    static Future<void> buildListRecipes(BuildContext context, dynamic jsonResponse, bool test) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0), // Slide from bottom to top
              end: Offset.zero,
            ).animate(animation),
            child: ListRecipes(jsonResponse: jsonResponse, test: test,),
          );
        },
      ),
    );
  }
}

class _CameraViewState extends ConsumerState<CameraView> {
  bool _cameraOn = true; // Define the _cameraOn variable

void _toggleCamera() {
  if (mounted) {
    setState(() {
      _cameraOn = !_cameraOn;
    });
  }
}
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            VisibilityDetector(
              key: Key('camera-view-key'),
              onVisibilityChanged: (VisibilityInfo info) {
                if (info.visibleFraction > 0.0 && !_cameraOn) {
                  _toggleCamera();
                } else if (info.visibleFraction == 0.0 && _cameraOn) {
                  _toggleCamera();
                }
              },
              child: _cameraOn ? DetectView() : Center(
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            CameraButton(
              onTap: _toggleCamera,
              cameraOn: _cameraOn,
            ),
          ],
        ),
      ),
    );
  }
}

class CameraButton extends ConsumerWidget {
  final VoidCallback onTap;
  final bool cameraOn; 

  const CameraButton({
    Key? key,
    required this.onTap,
    required this.cameraOn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = ref.watch(labelProvider);
    final hasPermissionsValue = ref.watch(permissionsControllerProvider);

    return Positioned(
      bottom: 20.0,
      child: hasPermissionsValue.when(
        data: (hasPermissions) {
          return GestureDetector(
            onTap: () {
              if (labels.isNotEmpty) {
                ApiManager.makeApiRequest(context, labels);
                onTap();
              }
            },
            key: const Key('cameraview_gesturedetector'),
            child: Opacity(
              key: const Key('cameraview_opacity'),
              opacity: cameraOn ? 1.0 : 0.0, 
              child: Container(
                width: 60.0,
                height: 60.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: labels.isNotEmpty ? Colors.white : Colors.grey,
                ),
                child: const Center(
                  child: Icon(
                    Icons.camera_alt,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) => const Center(key: const Key("cameraview_error"),child: Text('No permissions')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
