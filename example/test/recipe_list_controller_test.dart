import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo_example/providers/recipes_list_controller.dart';
import 'package:ultralytics_yolo_example/widgets/recipe_view.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'mock_http_client.dart';

void main() {
   group('ListRecipes Widget Tests', () {
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
    });
  testWidgets('Test buildListRecipes method', (WidgetTester tester) async {
    final jsonResponse = {
      'hits': [
        {
          'recipe': {
            'uri' : 'http://www.edamam.com/ontologies/edamam.owl#recipe_1f7f87ba76034fe2bdefab212f18d4dc',
            'label': 'Sushi rice',
            'image': 'https://edamam-product-images.s3.amazonaws.com/web-img/5b2/5b2bed47b31fc88db6e54b68b86fbf72.jpg?X-Amz-Security-Token=IQoJb3JpZ2luX2VjEE0aCXVzLWVhc3QtMSJHMEUCIHJ8fmNkhP7Cwj3XIhmTyiy6evL37MVtenLpNnI2sBZKAiEAnQP4tyz7iemIpj4kKqfbG1ID%2Fi6emnt%2BUyesAtqeWswqwgUItv%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FARAAGgwxODcwMTcxNTA5ODYiDNQ77%2BTIKUVtkH8r4CqWBVzsNkvpfdeVSl10e6Iqfg2S7zn7jvUpaUXT2T6whDvJlGrF5XIMH2GG75RAg%2FnU68m3jYvknPOqQOWMhLyEhzJ7DefgmKO51xhWDacBV9y9mZAL1BAJBk6abKoM%2BBKabTXy8om0qEorXgpnVHKycVwiapknrxsKKOqXscJzm30unRf87uJWviZXN3WJsu6srsVC5GiDQ7crrxON8%2Fd47zDsXF8WPBHmbG9UyHC%2BdbuPG48HlaRD01gRbfEH5jd5%2B62p6NZkiHgJpKGQnDOlN2N9OLrSXpizO1JYiw9e%2B9VFdeC2SDR7R9r5VPFMdZEzro3kif72xfaU2yIYpIQ9qlj8FclCSdBNLFOmjRe0dkdGLAYr5%2BsRbt6gy0DhhjLO1J%2FzFlID8NoiIswMuwpW19pueEj9hgrNSR79GeswrlBOs4lXkUwkw%2F1LGHfInPorO4JGJOGFLy5kHEEtjOiUG%2BQQdvPOstI1%2BmZya7AothHqekQmt5T%2FsiVazXjogADoGjuAW1SFRIqWfV5LJLPSbXrUMOEoggrwUBqvdS2v2d%2Bb0Xlh2%2FBkEXfo21xHpzZmE4xs231lrR6GCrXEdu44YfF6mrG8jfInDY29ZCqlW2VEJp7Eug2GZdw22VfkO4%2Fx2HWTxxvRZLAA%2F0QlhOsQ1pOX8HDgYr5f4e8Gl6ZifDfTstqwXFhLAtE2zdEqN2jV2zJURYVeSlZdRUkvh%2FSBzo%2F4rw%2BehnR1iIlSC4yxzU0tgNyMn7t3bCZTD5W%2B9GByrWV1jWhGvN09ihYt5Lc6BJIWkSelW4i6x%2BgrVWT%2BtjF1JJcx66sszMahcWgJ5BdiM0WAP1vh74sg1KHJFOwub0NtJZnIk5d0W1pWfy6Gp%2F0QAn2l%2FJcGMIejlrIGOrEBriWFNy%2BlJC9%2FgHKpoIInquOcMa5icElql87ULFnh45%2FCbBS8vbfvPUCkmJKiwAuT0IngB6DANYN5THyTVmGx1ZTtC3L%2Bm57mmiUYiwEWfQA2vohqWfGnOtRlkxcYEXvReLpA%2FvnO14eTIUOwVqRfstkvfy%2BxNd%2Fi7UolfTCL8LOyxQKpTsMlAWNqtDqnymkNZxy4XXZV%2FXSyStZnjZd3i4NBCMfNPt6vkk45JvygteIZ&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20240516T054136Z&X-Amz-SignedHeaders=host&X-Amz-Expires=3600&X-Amz-Credential=ASIASXCYXIIFIJEYEDEQ%2F20240516%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Signature=181ce2d482001b761dc0603dd754e737c6412a5b46d8329e82f0f6b1cac6a19c',
            'totalNutrients': {
              'CHOCDF': {'quantity': 60},
              'PROCNT': {'quantity': 30},
              'SUGAR': {'quantity': 5},
              'FAT': {'quantity': 5},
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
    
    final scrollViewFinder = find.byType(SingleChildScrollView);

    // Verifica che il widget SingleChildScrollView sia stato trovato
    expect(scrollViewFinder, findsOneWidget);
    expect(find.descendant(of: scrollViewFinder, matching: find.byType(Column)), findsWidgets);
    final columnFinder = find.descendant(
      of: scrollViewFinder,
      matching: find.byType(Column),
    );
    expect(columnFinder, findsOneWidget);
    //expect(find.descendant(of: columnFinder, matching: find.byType(GestureDetector)), findsWidgets);

    // Verifica che il titolo della finestra di dialogo sia corretto
    expect(find.text('Delightful Selections'), findsOneWidget);


    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

  // Verifica che la finestra di dialogo sia stata chiusa
    expect(find.byType(AlertDialog), findsNothing);
  });
   testWidgets('Test _buildRecipeWidget method', (WidgetTester tester) async {
    final recipeData = {
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
        'totalWeight': 100.0,
      },
    };
    when(mockHttpClient.get(Uri.parse('https://example.com/image.jpg')))
          .thenAnswer((_) async => http.Response('image data', 200));
    // Esegui il rendering del widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListRecipes.buildRecipeWidget(recipeData),
        ),
      ),
    );

    // Verifica la presenza del Card widget
    expect(find.byType(Card), findsOneWidget);

    // Verifica la presenza del testo con l'etichetta della ricetta
    expect(find.text('Test Recipe'), findsOneWidget);

    // Verifica la presenza dell'immagine
    final imageFinder = find.byType(Image);
    expect(imageFinder, findsOneWidget);

    final imageWidget = tester.widget<Image>(imageFinder);
    expect(imageWidget.image, isA<NetworkImage>());
    expect((imageWidget.image as NetworkImage).url,'https://example.com/image.jpg');
    // Verifica la presenza del dettaglio del punteggio di salute
    expect(find.text('Health Score:'), findsOneWidget);

    // Verifica la presenza del punteggio di salute specifico
    expect(find.text('Good 😊'), findsOneWidget);
  });


  testWidgets('Test _showRecipeDetails method', (WidgetTester tester) async {
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
        routes: {
          '/recipeDetails': (context) => RecipeDetailsPage(
                recipeData: jsonResponse['hits']?[0]['recipe'] ?? {},
              ),
        },
      ),
    );

    await tester.tap(find.text('Show Recipes'));
    await tester.pumpAndSettle();

    // Tappa sulla prima ricetta
    await tester.tap(find.byType(Card).first);
    await tester.pumpAndSettle();

    // Verifica che la pagina dei dettagli della ricetta sia stata visualizzata
    expect(find.byType(RecipeDetailsPage), findsOneWidget);
  });
});
}
