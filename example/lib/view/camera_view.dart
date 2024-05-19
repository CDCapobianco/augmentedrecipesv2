import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo_example/controller/api_controller.dart';
import 'package:ultralytics_yolo_example/controller/permissions_controller.dart';
import 'package:ultralytics_yolo_example/utils/query_provider.dart';
import 'package:ultralytics_yolo_example/view/detect_view.dart';
import 'package:ultralytics_yolo_example/view/recipeslist_view.dart';


/* TODO:
  one tap,  tasto indietro e chiudi la camera quando esci dalla schermata*/
class CameraView extends ConsumerStatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  ConsumerState<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends ConsumerState<CameraView> {
  final _cameraController = UltralyticsYoloCameraController();

  @override
  void dispose() {
    // Dispose of the camera controller to stop any background processes
    _cameraController.closeCamera();
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            DetectView(_cameraController), // Static part
            CameraButton(), // Dynamic part
          ],
        ),
      ),
    );
  }

}

class CameraButton extends ConsumerWidget {
  const CameraButton({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final labels = ref.watch(labelProvider);
    final hasPermissionsValue = ref.watch(permissionsControllerProvider);

    print("LABELS:$labels");
    return Positioned(
      bottom: 20.0, // Adjust as needed
      child: hasPermissionsValue.when(
        data: (hasPermissions) {
          return GestureDetector(
            onTap: (labels.isNotEmpty)
                ? () {
                    ApiManager.makeApiRequest(context, labels);
                  }
                : null,
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: labels.isNotEmpty ? Colors.white : Colors.grey,
              ),
              child: const Center(
                child: Icon(
                  Icons.camera_alt, // Icon for capturing a picture
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
          );
        },
        error: (error, stackTrace) => const Center(child: Text('No permissions')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }



  static Future<void> buildListRecipes(BuildContext context, dynamic jsonResponse) async {
    
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
          child: ListRecipes(jsonResponse: jsonResponse),
        );
      },
    ),
  );
}
}
