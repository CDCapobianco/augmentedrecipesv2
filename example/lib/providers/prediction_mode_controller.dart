import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultralytics_yolo_example/utils.dart';

part 'prediction_mode_controller.g.dart';

@riverpod
class PredictionModeController extends _$PredictionModeController {
  @override
  PredictionMode build() => PredictionMode.gallery;

  void setPredictionMode(PredictionMode mode) {
    if (state == mode) return;
    state = mode;
  }
}
