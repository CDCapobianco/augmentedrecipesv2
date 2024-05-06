import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo_example/providers/api_controller.dart';
import 'package:ultralytics_yolo_example/providers/permissions_controller.dart';
import 'package:ultralytics_yolo_example/providers/query_provider.dart';
import 'package:ultralytics_yolo_example/widgets/detect_view.dart';


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
      home: Scaffold(
        body: hasPermissionsValue.when(
          data: (hasPermissions) => switch (hasPermissions) {
            true => Stack(
                alignment: Alignment.center,
                children: [
                  DetectView(_cameraController), //detectmodel blabla
                  ElevatedButton(
                                onPressed: () {
                                   ApiManager.makeApiRequest(context, GlobalVariables.lista);
                                },
                                child: const Text('OTTIENI DATI'),
                              ),
                ],
                
              ),
            false => const Center(child: Text('No permissions')),
          },
          error: (error, stackTrace) => const Text('No permissions'),
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _cameraController.toggleLensDirection();
          },
        
          child: const Icon(Icons.cameraswitch_rounded),
        ),
      ),
    );
  }
}
