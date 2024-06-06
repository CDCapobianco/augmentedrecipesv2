import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo_example/utils/utils.dart';

void main() {
  group('PredictionMode Enum Test', () {
    test('Test enum values', () {
      // Verify that the enum values match their expected string representations
      expect(PredictionMode.camera.toString(), 'PredictionMode.camera');
      expect(PredictionMode.gallery.toString(), 'PredictionMode.gallery');

      // Verify that enum values are not equal
      expect(PredictionMode.camera, isNot(equals(PredictionMode.gallery)));
    });
  });
}
