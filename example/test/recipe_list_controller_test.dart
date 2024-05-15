import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ultralytics_yolo_example/providers/recipes_list_controller.dart';
import 'package:ultralytics_yolo_example/widgets/recipe_view.dart';

class MockBuildContext extends Mock implements BuildContext {}

void main() {
  testWidgets('buildListRecipes builds the dialog with recipe items correctly', (WidgetTester tester) async {
    // Preparazione dei dati di prova
    final jsonResponse = {
      'hits': [
        {'recipe': {'label': 'Recipe 1', 'image': 'https://example.com/image1.jpg'}},
        {'recipe': {'label': 'Recipe 2', 'image': 'https://example.com/image2.jpg'}},
        {'recipe': {'label': 'Recipe 3', 'image': 'https://example.com/image3.jpg'}},
        {'recipe': {'label': 'Recipe 4', 'image': 'https://example.com/image4.jpg'}},
        {'recipe': {'label': 'Recipe 5', 'image': 'https://example.com/image5.jpg'}},
      ],
    };

    // Costruisci il widget di test
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            ListRecipes.buildListRecipes(context, jsonResponse);
            return Container(); // Un widget vuoto per evitare errori di rendering nel test
          },
        ),
      ),
    );

    // Attendi il rendering del dialog
    await tester.pump();

    // Controlla se il dialog è stato costruito correttamente
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Delightful Selections'), findsOneWidget);

    // Controlla se i widget di ricetta sono stati costruiti correttamente all'interno del dialog
    expect(find.text('Recipe 1'), findsOneWidget);
    expect(find.text('Recipe 2'), findsOneWidget);
    expect(find.text('Recipe 3'), findsOneWidget);
    expect(find.text('Recipe 4'), findsOneWidget);
    expect(find.text('Recipe 5'), findsOneWidget);

    // Controlla se le immagini delle ricette sono state caricate correttamente
    expect(find.byWidgetPredicate((widget) => widget is Image && widget.image is NetworkImage), findsNWidgets(5));
  });
}
