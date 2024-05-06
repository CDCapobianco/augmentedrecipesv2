import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultralytics_yolo/predict/detect/object_detector.dart'
    as detector;
import 'package:ultralytics_yolo/yolo_model.dart';

part 'object_detector.g.dart';

@riverpod
class ObjectDetector extends _$ObjectDetector {
  @override
  FutureOr<detector.ObjectDetector> build() {
    return _initObjectDetectorWithLocalModel();
  }

  Future<detector.ObjectDetector> _initObjectDetectorWithLocalModel() async {
    if (Platform.isAndroid) {
      final modelPath = await _copy('assets/yolov8n_int8.tflite');
      final metadataPath = await _copy('assets/metadata.yaml');
      final model = LocalYoloModel(
        id: '',
        task: Task.detect,
        format: Format.tflite,
        modelPath: modelPath,
        metadataPath: metadataPath,
      );

      final objectDetector = detector.ObjectDetector(model: model);

      await objectDetector.loadModel();

      return objectDetector;
    } else if (Platform.isIOS) {
      final modelPath = await _copy('assets/yolov8n.mlmodel');
      final model = LocalYoloModel(
        id: '',
        task: Task.detect,
        format: Format.coreml,
        modelPath: modelPath,
      );

      final objectDetector = detector.ObjectDetector(model: model);

      await objectDetector.loadModel();

      return objectDetector;
    } else {
      throw Exception('Platform not supported');
    }
  }

  Future<String> _copy(String assetPath) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;

  }
}
