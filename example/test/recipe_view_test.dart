import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ultralytics_yolo_example/widgets/recipe_view.dart';
import 'package:url_launcher/url_launcher.dart';

class MockUrlLauncher extends Mock implements HttpClient {
  launch(String url) async {
    Uri uri = Uri.parse(url);
    await launchUrl(uri);
  }
}

void main() {
    // Crea un mock HttpClient che non fa nulla
  final mockHttpClient = HttpClient();

  final mockRecipeData = {
    'recipe': {
      'label': 'Spaghetti Carbonara',
      'image': 'https://example.com/image.jpg',
      'url': 'https://example.com/recipe',
      'totalNutrients': {
        'ENERC_KCAL': {'label': 'Energy', 'quantity': 500.0, 'unit': 'kcal'},
        'PROCNT': {'label': 'Protein', 'quantity': 25.0, 'unit': 'g'},
        'FAT': {'label': 'Fat', 'quantity': 20.0, 'unit': 'g'},
        'CHOCDF': {'label': 'Carbs', 'quantity': 55.0, 'unit': 'g'},
        'SUGAR': {'label': 'Sugar', 'quantity': 10.0, 'unit': 'g'},
        'VITA_RAE': {'label': 'Vitamin A', 'quantity': 200.0, 'unit': 'µg'},
        'VITC': {'label': 'Vitamin C', 'quantity': 0, 'unit': 'mg'},
        'THIA': {'label': 'Thiamine', 'quantity': 0, 'unit': 'mg'},
        'RIBF': {'label': 'Riboflavin', 'quantity': 0, 'unit': 'mg'},
        'NIA': {'label': 'Niacin', 'quantity': 0, 'unit': 'mg'},
        'VITB6A': {'label': 'Vitamin B6', 'quantity': 0, 'unit': 'mg'},
      },
      'totalWeight': 400.0,
      'totalCO2Emissions': 3000.0,
    },
  };

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('RecipeDetailsPage displays recipe details correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailsPage(recipeData: mockRecipeData),
      ),
    );

    // Check if the AppBar title is displayed
    expect(find.text('Spaghetti Carbonara'), findsOneWidget);

    // Check if the recipe image is displayed
    //expect(find.byType(Image), findsOneWidget);

    // Check if the nutrients section is displayed
   /* expect(find.text('Nutrients per 100 g'), findsOneWidget);
    expect(find.text('Energy'), findsOneWidget);
    expect(find.text('Protein'), findsOneWidget);
    expect(find.text('Fat'), findsOneWidget);
    expect(find.text('Carbs'), findsOneWidget);
    expect(find.text('Whose sugars'), findsOneWidget);

    // Check if the CO2 emissions box is displayed
    expect(find.text('CO2 Emissions'), findsOneWidget);
    expect(find.text('750 g CO2 per 100g'), findsOneWidget);

    // Check if the buttons are displayed
    expect(find.text('View Recipe Info'), findsOneWidget);
    expect(find.text('Search on Giallo Zafferano'), findsOneWidget);*/
  });

  testWidgets('RecipeDetailsPage launches URL when buttons are pressed', (WidgetTester tester) async {
    final mockUrlLauncher = MockUrlLauncher();

    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailsPage(recipeData: mockRecipeData),
      ),
    );

    // Tap on the 'View Recipe Info' button
    await tester.tap(find.text('View Recipe Info'));
    await tester.pumpAndSettle();

    verify(mockUrlLauncher.launch('https://example.com/recipe')).called(1);

    // Tap on the 'Search on Giallo Zafferano' button
    await tester.tap(find.text('Search on Giallo Zafferano'));
    await tester.pumpAndSettle();

    verify(mockUrlLauncher.launch('https://www.giallozafferano.it/ricerca-ricette/Spaghetti%20Carbonara')).called(1);
  });
}

/*
  testWidgets('RecipeDetailsPage launches URL when buttons are pressed', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RecipeDetailsPage(recipeData: mockRecipeData),
      ),
    );

    // Tap on the 'View Recipe Info' button
    await tester.tap(find.text('View Recipe Info'));
    await tester.pumpAndSettle();

    // Verifica se il pulsante 'View Recipe Info' lancia l'URL corretto
    expect(() => launch('https://example.com/recipe'), returnsNormally);

    // Tap on the 'Search on Giallo Zafferano' button
    await tester.tap(find.text('Search on Giallo Zafferano'));
    await tester.pumpAndSettle();

    // Verifica se il pulsante 'Search on Giallo Zafferano' lancia l'URL corretto
    expect(() => launch('https://www.giallozafferano.it/ricerca-ricette/Spaghetti%20Carbonara'), returnsNormally);
  });
}*/

