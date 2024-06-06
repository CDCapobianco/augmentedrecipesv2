import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ultralytics_yolo_example/view/recipe_view.dart';
import 'package:ultralytics_yolo_example/view/recipeslist_view.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockJsonResponse {
  static const Map<String, dynamic> jsonResponse = {
    "hits": [
      {
        "recipe": {
          "image": "https://example.com/image1.jpg",
          "label": "Recipe 1",
          "totalNutrients": {
            "ENERC_KCAL": {"label": "Energy", "quantity": 300.0, "unit": "kcal"},
            "PROCNT": {"label": "Protein", "quantity": 20.0, "unit": "g"},
            "FAT": {"label": "Fat", "quantity": 15.0, "unit": "g"},
            "CHOCDF": {"label": "Carbohydrates", "quantity": 50.0, "unit": "g"},
            "SUGAR": {"label": "Sugars", "quantity": 5.0, "unit": "g"},
            "VITA_RAE": {"label": "Vitamin A", "quantity": 300.0, "unit": "µg"},
            "VITC": {"label": "Vitamin C", "quantity": 90.0, "unit": "mg"},
            "THIA": {"label": "Thiamin", "quantity": 1.2, "unit": "mg"},
            "RIBF": {"label": "Riboflavin", "quantity": 1.3, "unit": "mg"},
            "NIA": {"label": "Niacin", "quantity": 16.0, "unit": "mg"},
            "VITB6A": {"label": "Vitamin B6", "quantity": 1.3, "unit": "mg"},
          },
          "totalWeight": 100.0,
          "totalCO2Emissions": 12.0,
          "url":"",
        }
      },
      {
        "recipe": {
          "image": "https://example.com/image2.jpg",
          "label": "Recipe 2",
          "totalNutrients": {
            "ENERC_KCAL": {"label": "Energy", "quantity": 250.0, "unit": "kcal"},
            "PROCNT": {"label": "Protein", "quantity": 25.0, "unit": "g"},
            "FAT": {"label": "Fat", "quantity": 10.0, "unit": "g"},
            "CHOCDF": {"label": "Carbohydrates", "quantity": 45.0, "unit": "g"},
            "SUGAR": {"label": "Sugars", "quantity": 6.0, "unit": "g"},
            "VITA_RAE": {"label": "Vitamin A", "quantity": 0.0, "unit": "µg"},
            "VITC": {"label": "Vitamin C", "quantity": 80.0, "unit": "mg"},
            "THIA": {"label": "Thiamin", "quantity": 1.1, "unit": "mg"},
            "RIBF": {"label": "Riboflavin", "quantity": 1.2, "unit": "mg"},
            "NIA": {"label": "Niacin", "quantity": 15.0, "unit": "mg"},
            "VITB6A": {"label": "Vitamin B6", "quantity": 1.2, "unit": "mg"},
          },
          "totalWeight": 100.0,
          "totalCO2Emissions": 10.0,
          "url":"",

        }
      },
    ]
  };
}



void main() {
  testWidgets('ListRecipes doesnt shows loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ListRecipes(jsonResponse: MockJsonResponse.jsonResponse, test: true),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('ListRecipes displays recipes correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ListRecipes(jsonResponse: MockJsonResponse.jsonResponse, test: true),
      ),
    );

    await tester.pump();

    expect(find.byType(PageView), findsOne);
    expect(find.byType(AutoSizeText), findsOne);
    expect(find.text('Recipe 1'), findsOne);
    expect(find.text('Recipe 2'), findsNothing);
  });
testWidgets('_buildRecipeWidget creates a recipe widget correctly', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: ListRecipes(jsonResponse: MockJsonResponse.jsonResponse, test: true),
    ),
  );

  await tester.pump();

    // Verify that GestureDetector is present
    expect(find.byType(GestureDetector), findsWidgets);

    // Verify that Image is not present (we are in test mode)
    expect(find.byType(Image), findsNothing);

    // Verify that the gradient overlay container is present
    final containerDecorations = find.byWidgetPredicate((Widget widget) =>
        widget is Container &&
        widget.decoration is BoxDecoration &&
        (widget.decoration as BoxDecoration).gradient != null);
    expect(containerDecorations, findsOneWidget);

    // Verify that the recipe detail is present
    expect(find.byKey(const Key("recipeslist_health_score")), findsOneWidget);
});
testWidgets('ModalSheets Works', (WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: ListRecipes(jsonResponse: MockJsonResponse.jsonResponse, test: true),
    ),
  );

  await tester.pump();

    // Verify that GestureDetector is present
    await tester.tap(find.byType(GestureDetector).first);
    await tester.pumpAndSettle();

    // Verify that the bottom sheet is displayed
    expect(find.byType(SlideTransition), findsOneWidget);

    // Verify that the correct content is displayed inside the bottom sheet
    expect(find.byType(RecipeDetailsPage), findsOneWidget);

});
}
