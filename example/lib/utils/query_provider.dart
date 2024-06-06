import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';

class GlobalVariables {
  static UltralyticsYoloCameraController cameraController = UltralyticsYoloCameraController();
}



class LabelNotifier extends StateNotifier<String> {
  LabelNotifier() : super('');

  void updateLabels(String newLabels) {
    state = newLabels;
  }
}

final labelProvider = StateNotifierProvider<LabelNotifier, String>((ref) {
  return LabelNotifier();
});
