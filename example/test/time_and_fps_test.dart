import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ultralytics_yolo_example/utils/time_and_fps.dart';

class MockStream<T> extends Mock implements Stream<T> {}

void main() {
  group('TimeAndFps widget test', () {
    testWidgets('Test widget renders correct data from streams',
        (WidgetTester tester) async {
      final inferenceStream = StreamController<double>();
      final fpsStream = StreamController<double>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TimeAndFps(
              inferenceTimeStream: inferenceStream.stream,
              fpsRateStream: fpsStream.stream,
            ),
          ),
        ),
      );

      // Emit some data to the streams
      inferenceStream.add(100.0);
      fpsStream.add(30.0);

      // Wait for the UI to update
      await tester.pump();

      // Expect to find two Text widgets with the correct data
      expect(find.text('100 ms'), findsOneWidget);
      expect(find.text('30.0 FPS'), findsOneWidget);

      // Emit more data to the streams
      inferenceStream.add(75.5);
      fpsStream.add(25.5);

      // Wait for the UI to update
      await tester.pump();

      // Expect to find two Text widgets with the updated data
      expect(find.text('75 ms'), findsNothing);
      expect(find.text('25.5 FPS'), findsNothing);

      // Close the streams
      inferenceStream.close();
      fpsStream.close();
    });
  });
}
