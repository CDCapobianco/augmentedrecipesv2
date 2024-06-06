import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo_example/controller/object_detector.dart';
import 'package:ultralytics_yolo_example/utils/query_provider.dart';


class DetectView extends ConsumerWidget {
  DetectView({Key? key}) : super(key: key); 

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
                double confidenceThreshold = 0.8;
                List<DetectedObject?> recipeList = snapshot.data!
                    .where((object) => object!.confidence > confidenceThreshold)
                    .toList();
                String listOfLabels = recipeList
                    .map((object) => object!.label)
                    .join('+');
                print("LABELS:$listOfLabels");

                Future.microtask(() {
                  ref.read(labelProvider.notifier).updateLabels(listOfLabels);
                });

                return CustomPaint(
                  painter: ObjectDetectorPainter(
                    recipeList as List<DetectedObject>,
                    const [Colors.white],
                    20,
                  ),
                );
              }

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
}
