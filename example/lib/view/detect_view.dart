import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo_example/controller/object_detector.dart';
import 'package:ultralytics_yolo_example/utils/query_provider.dart';


class DetectView extends ConsumerWidget {
  DetectView({Key? key}) : super(key: key); // Modify the constructor

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(objectDetectorProvider).when(
      data: (objectDetector) => Stack(
        children: [
          UltralyticsYoloCameraPreview(
            predictor: objectDetector,
            controller: GlobalVariables.cameraController,
            onCameraCreated: () {},
          ),
          StreamBuilder<List<DetectedObject?>?>(
            stream: objectDetector.detectionResultStream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Your logic for processing detection results
                double confidenceThreshold = 0.8;
                List<DetectedObject?> recipeList = snapshot.data!
                    .where((object) => object!.confidence > confidenceThreshold)
                    .toList();
                String listOfLabels = recipeList
                    .map((object) => object!.label)
                    .join('+');
                print("LABELS:$listOfLabels");
                // Update the label notifier in a future microtask
                Future.microtask(() {
                  ref.read(labelProvider.notifier).updateLabels(listOfLabels);
                });

                // Return UI based on detection results
                return CustomPaint(
                  painter: ObjectDetectorPainter(
                    recipeList as List<DetectedObject>,
                    const [Colors.white],
                    20,
                  ),
                );
              }
              // Return loading indicator or empty container if no data
              return Container();
            },
          ),
        ],
      ),
      error: (error, stackTrace) =>
          const Center(child: Text('No detection model')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void pauseDetection(){
    print("PAUSE LIVE DETECTION");
    //_cameraController.pauseLivePrediction();
  }
}
