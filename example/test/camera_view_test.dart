import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ultralytics_yolo_example/controller/api_controller.dart';
import 'package:ultralytics_yolo_example/controller/permissions_controller.dart';
import 'package:ultralytics_yolo_example/view/camera_view.dart';
import 'package:ultralytics_yolo_example/view/detect_view.dart';
import 'package:ultralytics_yolo_example/view/recipeslist_view.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MockApiManager extends Mock implements ApiManager {}
@GenerateMocks([ApiManager])

void main() {

  setUp(() {
  });
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
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    
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

    await CameraView.buildListRecipes(tester.element(find.byType(CameraView)), jsonResponse, true);
    await tester.pump();

    expect(find.byType(ListRecipes), findsNothing);
  });

  testWidgets('Permissions controller handles permissions', (WidgetTester tester) async {
    VisibilityDetectorController.instance.updateInterval = Duration.zero;

    // Mock the providers

    // Build the widget tree
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: CameraView()),
      ),
    );

    // Verify if the permissions are handled correctly
    expect(find.byType(CameraButton), findsOneWidget);

    // Simulate permissions error
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: CameraView()),
      ),
    );

    // Verify if the permissions error is displayed
    expect(find.text('No permissions'), findsNothing);
  });

  testWidgets('CameraButton contains GestureDetector and Opacity child', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
          permissionsControllerProvider.overrideWith(() => MockPermissionsController()),
        ],
          child: MaterialApp(
            home: Stack(
              children: [CameraButton(
                onTap: () {},
                cameraOn: true,
              ),]
            ),
          ),
        ),
      );

    // Verify the existence of GestureDetector
    expect(find.byKey(const Key('cameraview_gesturedetector')), findsOne);
    expect(find.byKey(const Key('cameraview_error')), findsNothing);

    // Verify the Opacity widget and its properties
    final opacityWidget = tester.widget<Opacity>(find.byKey(const Key('cameraview_opacity')));
    expect(opacityWidget.opacity, 1.0);

    // Verify the Container inside the Opacity widget
    final containerWidget = tester.widget<Container>(find.descendant(
      of: find.byType(Opacity),
      matching: find.byType(Container),
    ));


    // Verify the Container's decoration color
    final boxDecoration = containerWidget.decoration as BoxDecoration;
    //expect(boxDecoration.color, Color(0xff9e9e9e));
    expect(boxDecoration.shape, BoxShape.circle);

    // Verify the Icon inside the Container
    final iconWidget = tester.widget<Icon>(find.descendant(
      of: find.byType(Container),
      matching: find.byType(Icon),
    ));
    expect(iconWidget.icon, Icons.camera_alt);
    expect(iconWidget.color, const Color.fromARGB(255, 0, 0, 0));
  });

}


class MockPermissionsController extends PermissionsController {
  @override
  FutureOr<bool> build() {
    return true;
  }
}