import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo_example/controller/permissions_controller.dart';
import 'package:ultralytics_yolo_example/utils/query_provider.dart';
import 'package:ultralytics_yolo_example/view/camera_view.dart';
import 'package:ultralytics_yolo_example/view/detect_view.dart';
import 'package:ultralytics_yolo_example/view/recipeslist_view.dart';
import 'package:visibility_detector/visibility_detector.dart';


void main() {
  testWidgets('CameraView initial state', (WidgetTester tester) async {
    // Initialize VisibilityDetector
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    // Build the widget tree
    await tester.pumpWidget(
      const ProviderScope(
        child: CameraView(),
      ),
    );

    // Verify if the CameraView is present
    expect(find.byKey(const Key('camera-view-key')), findsOneWidget);

    // Verify if the CameraButton is present
    expect(find.byType(CameraButton), findsOneWidget);

    // Verify if the DetectView is present
    expect(find.byType(DetectView), findsOneWidget);
  });

  testWidgets('CameraButton tap toggles camera state', (WidgetTester tester) async {
    // Initialize VisibilityDetector
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    // Build the widget tree
    await tester.pumpWidget(
      const ProviderScope(
        child: CameraView(),
      ),
    );

    // Verify initial camera state
    expect(find.byType(DetectView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsAny);

    // Tap the CameraButton
    await tester.tap(find.byType(CameraButton));
    await tester.pump();

    // Verify the camera state is toggled
    expect(find.byType(DetectView), findsOne);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Tap the CameraButton again
    await tester.tap(find.byType(CameraButton));
    await tester.pump();

    // Verify the camera state is toggled back
    expect(find.byType(DetectView), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOne);
  });

  testWidgets('Navigator pushes to ListRecipes on buildListRecipes', (WidgetTester tester) async {
    // Build the widget tree
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: CameraView()),
      ),
    );

    // Define a sample JSON response
final jsonResponse = {
      'hits': [
        {
          'recipe': {
            'uri' : 'http://www.edamam.com/ontologies/edamam.owl#recipe_1f7f87ba76034fe2bdefab212f18d4dc',
            'label': 'Sushi rice',
            'image': 'test_mode',
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
            'totalWeight': 100.2,
          },
        },
      ],
    };
    // Call buildListRecipes to navigate to ListRecipes
    await CameraView.buildListRecipes(tester.element(find.byType(CameraView)), jsonResponse);
    await tester.pumpAndSettle();

    // Verify if the ListRecipes page is pushed
    expect(find.byType(ListRecipes), findsOneWidget);
  });

  testWidgets('Permissions controller handles permissions', (WidgetTester tester) async {
    // Mock the providers
    final mockPermissionsProvider = Provider((ref) => AsyncValue.data(true));

    // Build the widget tree
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(home: CameraView()),
      ),
    );

    // Verify if the permissions are handled correctly
    expect(find.byType(CameraButton), findsOneWidget);

    // Simulate permissions error
    await tester.pumpWidget(
      ProviderScope(
        child: const MaterialApp(home: CameraView()),
      ),
    );

    // Verify if the permissions error is displayed
    expect(find.text('No permissions'), findsOneWidget);
  });
}

