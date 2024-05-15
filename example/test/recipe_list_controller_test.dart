import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo_example/providers/recipes_list_controller.dart';

void main() {
  testWidgets('Test buildListRecipes method', (WidgetTester tester) async {
    final jsonResponse = {
      'hits': [
        {
          'recipe': {
            'label': 'Test Recipe',
            'image': 'https://example.com/image.jpg',
            'totalNutrients': {
              'CHOCDF': {'quantity': 10},
              'PROCNT': {'quantity': 20},
              'SUGAR': {'quantity': 5},
              'FAT': {'quantity': 15},
              'VITA_RAE': {'quantity': 100},
              'VITC': {'quantity': 10},
              'THIA': {'quantity': 5},
              'NIA': {'quantity': 15},
              'VITB6A': {'quantity': 20},
            },
            'totalWeight': 100,
          },
        },
      ],
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () {
                  ListRecipes.buildListRecipes(context, jsonResponse);
                },
                child: Text('Show Recipes'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Show Recipes'));
    await tester.pumpAndSettle();

    // Verifica che la finestra di dialogo sia stata visualizzata
    expect(find.byType(AlertDialog), findsOneWidget);
    // Verifica che non ci siano widget di ricetta
      // Trova il widget SingleChildScrollView
  final scrollViewFinder = find.byType(SingleChildScrollView);

  // Verifica che il widget SingleChildScrollView sia stato trovato
  expect(scrollViewFinder, findsOneWidget);

  // Verifica che il widget SingleChildScrollView sia vuoto
  expect(find.descendant(of: scrollViewFinder, matching: find.byType(Column)), findsOneWidget);

    // Verifica che il titolo della finestra di dialogo sia corretto
    expect(find.text('Delightful Selections'), findsOneWidget);

    // Tappa sul pulsante di chiusura
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

  // Verifica che la finestra di dialogo sia stata chiusa
    expect(find.byType(AlertDialog), findsNothing);

  });
}
