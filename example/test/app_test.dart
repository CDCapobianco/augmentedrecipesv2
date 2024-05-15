/*import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ultralytics_yolo_example/app.dart';

void main() {
  testWidgets('MyApp widget test', (WidgetTester tester) async {
    // Build the MyApp widget and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(  // Aggiunto ProviderScope
        child: MyApp(),
      ),
    );

    // Verify that MyApp displays CircularProgressIndicator while loading.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Simulate the completion of loading process.
    await tester.pump();

    // Verify that CircularProgressIndicator disappears after loading.
    //expect(find.byType(CircularProgressIndicator), findsNothing);

    // Verify that FloatingActionButton is present.
    expect(find.byType(FloatingActionButton), findsOneWidget);
   

    // Tap on FloatingActionButton to toggle lens direction.
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    // Verify that ElevatedButton is present.
    //expect(find.byType(ElevatedButton), findsOneWidget);

    // Tap on ElevatedButton to make API request.
    //await tester.tap(find.byType(ElevatedButton));
    //await tester.pump();

    // You can add more assertions based on your specific widget behavior.
  });
}
*/
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/src/async_notifier.dart';
import 'package:ultralytics_yolo_example/app.dart';
import 'package:ultralytics_yolo_example/providers/permissions_controller.dart';
import 'package:ultralytics_yolo_example/widgets/detect_view.dart';

void main() {
  testWidgets('MyApp shows loading indicator when permissions are loading', (WidgetTester tester) async {
    // Setup the mocked provider to return loading state
    final container = ProviderContainer(
      overrides: [
        permissionsControllerProvider.overrideWith(
          StateProvider((ref) => const AsyncValue.loading()) as PermissionsController Function(),
        ),
      ],
    );

    // Build the widget
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );

    // Verify loading indicator is shown
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('MyApp shows error text when permissions loading fails', (WidgetTester tester) async {
    // Setup the mocked provider to return error state
    final container = ProviderContainer(
      overrides: [
        permissionsControllerProvider.overrideWith(
          StateProvider((ref) => AsyncValue.error('Error', StackTrace.current)) as PermissionsController Function(),
        ),
      ],
    );

    // Build the widget
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );

    // Verify error text is shown
    expect(find.text('No permissions'), findsOneWidget);
  });

  testWidgets('MyApp shows DetectView when permissions are granted', (WidgetTester tester) async {
    // Setup the mocked provider to return data state
    final container = ProviderContainer(
      overrides: [
        permissionsControllerProvider.overrideWith(
          StateProvider((ref) => const AsyncValue.data(true)) as PermissionsController Function(),
        ),
      ],
    );

    // Build the widget
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );

    // Verify DetectView is shown
    expect(find.byType(DetectView), findsOneWidget);

    // Verify the camera icon button is shown
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });
}
