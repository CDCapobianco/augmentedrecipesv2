import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo_example/view/recipe_view.dart';

void main() {

  testWidgets('RecipeDetailsPage Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final recipeData = {
      'recipe': {
        'image':
            "https://imgv3.fotor.com/images/slider-image/A-clear-close-up-photo-of-a-woman.jpg",
        'label': 'Test Recipe',
        'totalNutrients': {
          'ENERC_KCAL': {'label': 'Energy', 'quantity': 200, 'unit': 'kcal'},
          'PROCNT': {'label': 'Protein', 'quantity': 25, 'unit': 'g'},
          'FAT': {'label': 'Fat', 'quantity': 10, 'unit': 'g'},
          'CHOCDF': {'label': 'Carbs', 'quantity': 60, 'unit': 'g'},
          'SUGAR': {'label': 'Sugars', 'quantity': 5, 'unit': 'g'},
          'VITA_RAE': {'label': 'Vitamin A', 'quantity': 1, 'unit': 'µg'},
          'VITC': {'label': 'Vitamin C', 'quantity': 1, 'unit': 'mg'},
          'THIA': {'label': 'Thiamin', 'quantity': 1, 'unit': 'mg'},
          'RIBF': {'label': 'Riboflavin', 'quantity': 1, 'unit': 'mg'},
          'NIA': {'label': 'Niacin', 'quantity': 1, 'unit': 'mg'},
          'VITB6A': {'label': 'Vitamin B6', 'quantity': 1, 'unit': 'mg'},
        },
        'totalWeight': 100.0,
        'totalCO2Emissions': 200.0,
        'url':
            'https://api.edamam.com/api/recipes/v2?type=public&q=Test Recipe&app_id=c5fdcbaf&app_key=79089b3e02ca51e14bb5801915134401',
      }
    };
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: RecipeDetailsPage(
          recipeData: recipeData, isTesting: true,))));

    // Verify that the page title is displayed
    expect(find.text('Test Recipe'), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);
    expect(find.byWidgetPredicate((widget) => widget is Container && widget.child is ListView), findsOneWidget);
    expect(find.text('Nutrients per 100 g'), findsOneWidget);
    expect(find.text('Healthiness Score'), findsOneWidget);
    //expect(find.text('CO2 Emissions'), findsOneWidget);
    final healthBarFinder = find.byType(HealthBar);
    expect(healthBarFinder, findsOneWidget);

    final healthBarWidget = tester.widget<HealthBar>(healthBarFinder);
    expect(healthBarWidget.score, 100); 
    expect(find.byIcon(Icons.check_circle), findsNWidgets(5)); // Per i nutrienti buoni
    expect(find.byIcon(Icons.error), findsNothing); // Per i nutrienti cattivi



    await tester.tap(find.byType(ExpansionTile).first);
    await tester.pump();
    // Verifica che il widget dell'ExpansionTile sia stato aperto
    expect(find.byType(ListTile), findsNWidgets(1)); 
    expect(find.text('Energy: 200 kcal'), findsOneWidget);
    expect(find.text('Protein: 25 g'), findsOneWidget);
    expect(find.text('Fat: 10 g'), findsOneWidget);
    expect(find.text('Carbs: 60 g'), findsOneWidget);
    expect(find.text('Whose sugars: 5 g'), findsOneWidget);
    expect(find.text('Vitamin A: 1 µg'), findsOneWidget);
    expect(find.text('Vitamin C: 1 mg'), findsOneWidget);

  final gesture = await tester.startGesture(Offset(0, 800)); //Position of the scrollview
    await gesture.moveBy(Offset(0, -800)); //How much to scroll by
    await tester.pump();
    expect(find.text('Thiamin: 1 mg'), findsOneWidget);
    expect(find.byKey(Key('Riboflavin')), findsOneWidget);
    expect(find.byKey(Key('Niacin')), findsOneWidget);
    expect(find.byKey(Key('Vitamin B6')), findsOneWidget);
    
  });
}
