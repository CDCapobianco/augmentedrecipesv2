import 'package:flutter/material.dart';

class TimeAndFps extends StatelessWidget {
  const TimeAndFps({
    required this.inferenceTimeStream,
    required this.fpsRateStream,
    super.key,
  });

  final Stream<double>? inferenceTimeStream;
  final Stream<double>? fpsRateStream;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<double?>(
            stream: inferenceTimeStream,
            builder: (context, snapshot) => Text(
              '${snapshot.data?.toStringAsFixed(0)} ms',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          const Text(
            '  |  ',
            style: TextStyle(color: Colors.white),
          ),
          StreamBuilder<double?>(
            stream: fpsRateStream,
            builder: (context, snapshot) => Text(
              '${snapshot.data?.toStringAsFixed(1)} FPS',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
