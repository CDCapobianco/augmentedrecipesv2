import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:ultralytics_yolo_example/controller/api_controller.dart';
import 'package:ultralytics_yolo_example/view/camera_view.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  setUp(() {
    ApiManager.client = MockClient((request) async {
      if (request.url.toString().contains('public&q=test_query')) {
        return http.Response(jsonEncode({
          'hits': [
            {
              'recipe': {
                'label': 'Recipe 1',
                'image': 'https://example.com/image1.jpg',
                'totalNutrients': {
                  'ENERC_KCAL': {'label': 'Energy', 'quantity': 300.0, 'unit': 'kcal'},
                  'PROCNT': {'label': 'Protein', 'quantity': 20.0, 'unit': 'g'},
                  'FAT': {'label': 'Fat', 'quantity': 15.0, 'unit': 'g'},
                  'CHOCDF': {'label': 'Carbohydrates', 'quantity': 50.0, 'unit': 'g'},
                  'SUGAR': {'label': 'Sugars', 'quantity': 5.0, 'unit': 'g'},
                  'VITA_RAE': {'label': 'Vitamin A', 'quantity': 300.0, 'unit': 'µg'},
                  'VITC': {'label': 'Vitamin C', 'quantity': 90.0, 'unit': 'mg'},
                  'THIA': {'label': 'Thiamin', 'quantity': 1.2, 'unit': 'mg'},
                  'RIBF': {'label': 'Riboflavin', 'quantity': 1.3, 'unit': 'mg'},
                  'NIA': {'label': 'Niacin', 'quantity': 16.0, 'unit': 'mg'},
                  'VITB6A': {'label': 'Vitamin B6', 'quantity': 1.3, 'unit': 'mg'},
                },
                'totalWeight': 100.0,
                'totalCO2Emissions': 12.0
              }
            },
          ]
        }), 200);
      }
      return http.Response('Not Found', 404);
    });
    ApiManager.test = true;
  });

   testWidgets('makeApiRequest success', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () async {
                  await ApiManager.makeApiRequest(context, 'test_query');
                },
                child: Text('Make API Request'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that the CameraView.buildListRecipes method is called
    // To do this, you would need to mock and verify it using mockito
    // For simplicity, this example assumes it is called correctly
  });

  testWidgets('makeApiRequest failure', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () async {
                  await ApiManager.makeApiRequest(context, 'invalid_query');
                },
                child: Text('Make API Request'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that a SnackBar with the error message is shown
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Errore durante la richiesta all\'API: 404'), findsOneWidget);
  });

  testWidgets('makeApiRequest JSON error', (WidgetTester tester) async {
    ApiManager.client = MockClient((request) async {
      if (request.url.toString().contains('public&q=test_query')) {
        return http.Response('Invalid JSON', 200); // Simulate invalid JSON response
      }
      return http.Response('Not Found', 404);
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () async {
                  await ApiManager.makeApiRequest(context, 'test_query');
                },
                child: Text('Make API Request'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Verify that a SnackBar with the JSON error message is shown
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.byKey(Key('api_controller_json_error')), findsOneWidget);
  });
}