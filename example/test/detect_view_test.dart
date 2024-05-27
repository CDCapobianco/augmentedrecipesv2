import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo_example/view/recipeslist_view.dart';

void main() {
  testWidgets('ListRecipes widget test', (WidgetTester tester) async {
    // Create a widget for testing
    await tester.pumpWidget(MaterialApp(
      home: ListRecipes(
        jsonResponse: {}, // Provide a mock or empty JSON response for testing
      ),
    ));

    // Verify that the loading indicator is displayed initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate finishing loading (setState to change _isLoading to false)
    await tester.pump();

    // Verify that the recipe content is displayed after loading
    expect(find.byType(PageView), findsOneWidget);
  });
}
