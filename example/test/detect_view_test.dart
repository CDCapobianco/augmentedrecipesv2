import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import 'package:ultralytics_yolo_example/controller/object_detector.dart' as prefix;
import 'package:ultralytics_yolo_example/view/detect_view.dart';


void main() {

  testWidgets('DetectView shows loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: DetectView(),
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DetectView shows no error message', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: DetectView(),
        ),
      ),
    );
    expect(find.text('No detection model'), findsNothing);
  });

  testWidgets('DetectView shows no detection result', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: DetectView(),
        ),
      ),
    );
    expect(find.byType(CustomPaint), findsWidgets);
  });

  
}


class MockObjectDetector extends ObjectDetector {
  MockObjectDetector({required super.model});

}