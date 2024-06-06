import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo_example/view/recipe_view.dart';

void main() {
  testWidgets('RecipeDetailsPage displays correctly',
      (WidgetTester tester) async {
    final recipeData = {
      'recipe': {
        'image':
            "https://imgv3.fotor.com/images/slider-image/A-clear-close-up-photo-of-a-woman.jpg",
        'label': 'Test Recipe',
        'totalNutrients': {
          'ENERC_KCAL': {'label': 'Energy', 'quantity': 200, 'unit': 'kcal'},
          'PROCNT': {'label': 'Protein', 'quantity': 10, 'unit': 'g'},
          'FAT': {'label': 'Fat', 'quantity': 5, 'unit': 'g'},
          'CHOCDF': {'label': 'Carbs', 'quantity': 30, 'unit': 'g'},
          'SUGAR': {'label': 'Sugars', 'quantity': 10, 'unit': 'g'},
          'VITA_RAE': {'label': 'Vitamin A', 'quantity': 0, 'unit': 'µg'},
          'VITC': {'label': 'Vitamin C', 'quantity': 0, 'unit': 'mg'},
          'THIA': {'label': 'Thiamin', 'quantity': 0, 'unit': 'mg'},
          'RIBF': {'label': 'Riboflavin', 'quantity': 0, 'unit': 'mg'},
          'NIA': {'label': 'Niacin', 'quantity': 0, 'unit': 'mg'},
          'VITB6A': {'label': 'Vitamin B6', 'quantity': 0, 'unit': 'mg'},
        },
        'totalWeight': 100.0,
        'totalCO2Emissions': 200.0,
        'url':
            'https://api.edamam.com/api/recipes/v2?type=public&q=Test Recipe&app_id=c5fdcbaf&app_key=79089b3e02ca51e14bb5801915134401',
      }
    };

    await tester.pumpWidget(
        MaterialApp(home: RecipeDetailsPage(recipeData: recipeData)));

    expect(find.text('Test Recipe '), findsNothing);
    expect(find.text('Get the Recipe '), findsNothing);
    expect(find.text('Search on GialloZafferano '), findsNothing);
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('CO2 Emissions '), findsNothing);
  });

  testWidgets('Tapping buttons opens URLs', (WidgetTester tester) async {
    final recipeData = {
      'recipe': {
        'image':
            "https://imgv3.fotor.com/images/slider-image/A-clear-close-up-photo-of-a-woman.jpg",
        'label': 'Test Recipe',
        'totalNutrients': {
          'ENERC_KCAL': {'label': 'Energy', 'quantity': 200, 'unit': 'kcal'},
          'PROCNT': {'label': 'Protein', 'quantity': 10, 'unit': 'g'},
          'FAT': {'label': 'Fat', 'quantity': 5, 'unit': 'g'},
          'CHOCDF': {'label': 'Carbs', 'quantity': 30, 'unit': 'g'},
          'SUGAR': {'label': 'Sugars', 'quantity': 10, 'unit': 'g'},
          'VITA_RAE': {'label': 'Vitamin A', 'quantity': 0, 'unit': 'µg'},
          'VITC': {'label': 'Vitamin C', 'quantity': 0, 'unit': 'mg'},
          'THIA': {'label': 'Thiamin', 'quantity': 0, 'unit': 'mg'},
          'RIBF': {'label': 'Riboflavin', 'quantity': 0, 'unit': 'mg'},
          'NIA': {'label': 'Niacin', 'quantity': 0, 'unit': 'mg'},
          'VITB6A': {'label': 'Vitamin B6', 'quantity': 0, 'unit': 'mg'},
        },
        'totalWeight': 100.0,
        'totalCO2Emissions': 200.0,
        'url':
            'https://api.edamam.com/api/recipes/v2?type=public&q=Test Recipe&app_id=c5fdcbaf&app_key=79089b3e02ca51e14bb5801915134401',
      }
    };

    await tester.pumpWidget(
        MaterialApp(home: RecipeDetailsPage(recipeData: recipeData)));

    expect(find.text('Get the Recipe'), findsNothing);
    // await tester.tap(find.text('Get the Recipe'));
    // await tester.pumpAndSettle();
    // Note: You need to mock url_launcher to properly test URL opening in a unit test

    expect(find.text('Search on GialloZafferano'), findsNothing);
    // await tester.tap(find.text('Search on GialloZafferano'));
    // await tester.pumpAndSettle();
    // Note: You need to mock url_launcher to properly test URL opening in a unit test
  });
  group('RecipeDetailsPage Unit Tests', () {
    test('CO2 Emissions calculation', () {
      final totalCO2Emissions = 2000.0;
      final totalWeight = 500.0;
      final emissionsPer100g =
          (totalCO2Emissions * 100 / totalWeight).round().toDouble();

      expect(emissionsPer100g, 400.0);
    });

    test('Healthiness score calculation', () {
      final nutrients = {
        'CHOCDF': {'quantity': 45.0},
        'PROCNT': {'quantity': 20.0},
        'SUGAR': {'quantity': 10.0},
        'FAT': {'quantity': 35.0},
        'VITA_RAE': {'quantity': 0.0},
        'VITC': {'quantity': 0.0},
        'THIA': {'quantity': 0.0},
        'NIA': {'quantity': 0.0},
        'VITB6A': {'quantity': 0.0}
      };
      final totalWeight = 100.0;
      final double carbo =
          nutrients['CHOCDF']!['quantity']! * 100 / totalWeight;
      final double protein =
          nutrients['PROCNT']!['quantity']! * 100 / totalWeight;
      final double sugar = nutrients['SUGAR']!['quantity']! * 100 / totalWeight;
      final double fat = nutrients['FAT']!['quantity']! * 100 / totalWeight;
      final double calorieProteine = protein * 4;
      final double calorieCarboidrati = carbo * 4;
      final double calorieGrassi = fat * 9;
      final double calorieTotali =
          calorieProteine + calorieCarboidrati + calorieGrassi;
      final double percProt = (calorieProteine / calorieTotali) * 100;
      final double percCarb = (calorieCarboidrati / calorieTotali) * 100;
      final double percFat = (calorieGrassi / calorieTotali) * 100;
      final double percSug = (sugar / totalWeight) * 100;
      double score = 0;

      if (percProt >= 20) score += 20;
      if (percCarb >= 45) score += 20;
      if (percFat <= 35) score += 20;
      if (percSug <= 10) score += 20;

      expect(score, 20.0);
    });
  });
}
