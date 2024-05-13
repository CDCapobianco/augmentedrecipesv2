import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo_example/providers/object_detector.dart';
import 'package:ultralytics_yolo_example/providers/query_provider.dart';
import 'package:ultralytics_yolo_example/widgets/time_and_fps.dart';


class DetectView extends ConsumerWidget {
  const DetectView(
    this._cameraController, {
    super.key,
  });
  
  final UltralyticsYoloCameraController _cameraController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(objectDetectorProvider).when(
          data: (objectDetector) =>
            Stack(
            children: [
              UltralyticsYoloCameraPreview(
                predictor: objectDetector,
                controller: _cameraController,
                onCameraCreated: () {},
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: TimeAndFps(
                  inferenceTimeStream: objectDetector.inferenceTime,
                  fpsRateStream: objectDetector.fpsRate,
                ),
              ),
              // StreamBuilder to access content of detectionResultStream
              StreamBuilder<List<DetectedObject?>?>(
                stream: objectDetector.detectionResultStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                      double confidenceThreshold = 0.6;
                      
                      List<DetectedObject?> recipeList =  snapshot.data!.where((object) => object!.confidence > confidenceThreshold).toList();

                      String listOfLabels = "";
                      for (int i = 0; i < recipeList.length; i++) {
                        if(i == 0) {
                          listOfLabels = recipeList[i]!.label;
                        } else {
                          listOfLabels = "$listOfLabels+${recipeList[i]?.label}";
                        } 
                      }
                      List<String> parts = listOfLabels.split('+');
                      Set<String> uniqueParts = {};
                      List<String> filteredParts = [];
                      for (String part in parts) {
                        if (!uniqueParts.contains(part)) {
                          uniqueParts.add(part);
                          filteredParts.add(part);
                        }
                      }

  
                      String outputString = filteredParts.join('+');

                      GlobalVariables.lista = outputString;
                      return CustomPaint(
                        painter: ObjectDetectorPainter(
                         recipeList as List<DetectedObject>,
                          const [Colors.white],
                          4,
                        ),
                      );
                  }
                  // If snapshot has no data or is still loading, you can return an empty container or a loading indicator
                  return Container(); // Or return a loading indicator
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
