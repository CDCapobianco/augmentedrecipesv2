import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo_example/providers/api_controller.dart';
import 'package:ultralytics_yolo_example/providers/permissions_controller.dart';
import 'package:ultralytics_yolo_example/providers/query_provider.dart';
import 'package:ultralytics_yolo_example/widgets/detect_view.dart';
import 'package:ultralytics_yolo_example/widgets/landing_page.dart';


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final _cameraController = UltralyticsYoloCameraController();

  @override
  Widget build(BuildContext context) {
    final hasPermissionsValue = ref.watch(permissionsControllerProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Go Back'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              MaterialPageRoute(builder: (context) => const LandingPage());
            },
          ),
        ),
        body: hasPermissionsValue.when(
          data: (hasPermissions) => Stack(
            alignment: Alignment.center,
            children: [
              DetectView(_cameraController),
              Positioned(
                bottom: 20.0, // Adjust as needed
                child: GestureDetector(
                  onTap: () {
                    ApiManager.makeApiRequest(context, GlobalVariables.lista);
                  },
                  child: Container(
                    width: 60.0,
                    height: 60.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
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
        ),

      ),
    );
  }
}