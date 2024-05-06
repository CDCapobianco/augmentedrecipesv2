import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ultralytics_yolo_example/providers/prediction_mode_controller.dart';
import 'package:ultralytics_yolo_example/utils.dart';

class PredictionModeSegmentedButton extends ConsumerWidget {
  const PredictionModeSegmentedButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SegmentedButton<PredictionMode>(
      segments: const <ButtonSegment<PredictionMode>>[
        ButtonSegment<PredictionMode>(
          value: PredictionMode.camera,
          label: Text('Camera'),
          icon: Icon(Icons.camera_alt),
        ),
        ButtonSegment<PredictionMode>(
          value: PredictionMode.gallery,
          label: Text('Gallery'),
          icon: Icon(Icons.photo_library_outlined),
        ),
      ],
      selected: <PredictionMode>{ref.watch(predictionModeControllerProvider)},
      onSelectionChanged: (Set<PredictionMode> newSelection) {
        ref
            .read(predictionModeControllerProvider.notifier)
            .setPredictionMode(newSelection.first);
      },
    );
  }
}
