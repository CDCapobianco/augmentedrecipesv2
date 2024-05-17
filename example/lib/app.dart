import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo_example/providers/api_controller.dart';
import 'package:ultralytics_yolo_example/providers/permissions_controller.dart';
import 'package:ultralytics_yolo_example/providers/query_provider.dart';
import 'package:ultralytics_yolo_example/widgets/detect_view.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _cameraController = UltralyticsYoloCameraController();

  @override
  void dispose() {
    // Dispose of the camera controller to stop any background processes
    _cameraController.dispose();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      body: ValueListenableBuilder<String>(
        valueListenable: GlobalVariables.listaNotifier,
        builder: (context, value, _) {
          final hasPermissionsValue = ref.watch(permissionsControllerProvider);
          
          // Defer the state update using Future.microtask
          Future.microtask(() {
            setState(() {
              // State update logic here
            });
          });
          
          return hasPermissionsValue.when(
            data: (hasPermissions) => Stack(
              alignment: Alignment.center,
              children: [
                DetectView(_cameraController),
                Positioned(
                  bottom: 20.0, // Adjust as needed
                  child: GestureDetector(
                    onTap: value.isNotEmpty // Access the local variable
                        ? () {
                            ApiManager.makeApiRequest(context, value);
                            dispose();
                          }
                        : null,
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: value.isNotEmpty ? Colors.white : Colors.grey, // Access the local variable
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt, // Icon for capturing a picture
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            error: (error, stackTrace) => const Center(child: Text('No permissions')),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    ),
  );
}


}
