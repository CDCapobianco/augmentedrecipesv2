import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo_example/utils/query_provider.dart';

void main() {
  group('GlobalVariables Test', () {
    test('Test GlobalVariables', () {
      // Test ValueNotifier initialization

      // Test camera controller initialization
      expect(GlobalVariables.cameraController,
          isA<UltralyticsYoloCameraController>());
    });
  });

  group('LabelNotifier Test', () {
    test('Test LabelNotifier updateLabels method', () {
      final container = ProviderContainer();

      // Obtain LabelNotifier instance
      final labelNotifier = container.read(labelProvider.notifier);

      // Update labels
      labelNotifier.updateLabels('New Labels');

      // Verify if labels are updated
      final updatedLabels = container.read(labelProvider);
      expect(updatedLabels, 'New Labels');
    });
  });
}
