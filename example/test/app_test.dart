import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo_example/app.dart';

void main() {
  testWidgets('MyApp widget test', (WidgetTester tester) async {
    // Build the MyApp widget and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(  // Aggiunto ProviderScope
        child: MyApp(),
      ),
    );

    // Verify that MyApp displays CircularProgressIndicator while loading.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate the completion of loading process.
    await tester.pump();

    // Verify that CircularProgressIndicator disappears after loading.
    //expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify that FloatingActionButton is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);
   

    // Tap on FloatingActionButton to toggle lens direction.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that ElevatedButton is present.
    //expect(find.byType(ElevatedButton), findsOneWidget);

    // Tap on ElevatedButton to make API request.
    //await tester.tap(find.byType(ElevatedButton));
    //await tester.pump();

    // You can add more assertions based on your specific widget behavior.
  });
}
