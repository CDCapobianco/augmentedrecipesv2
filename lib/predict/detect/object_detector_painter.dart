import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:ultralytics_yolo/predict/detect/detected_object.dart';

/// A painter used to draw the detected objects on the screen.

class ObjectDetectorPainter extends CustomPainter {
  /// Creates a [ObjectDetectorPainter].
  ObjectDetectorPainter(
    this._detectionResults, [
    this._colors,
    this._strokeWidth = 2.5,
  ]);

  final List<DetectedObject> _detectionResults;
  final List<Color>? _colors;
  final double _strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final colors = _colors ?? Colors.primaries;

    for (final detectedObject in _detectionResults) {
      final left = detectedObject.boundingBox.left;
      final top = detectedObject.boundingBox.top;
      final right = detectedObject.boundingBox.right;
      final bottom = detectedObject.boundingBox.bottom;
      final width = detectedObject.boundingBox.width;
      final height = detectedObject.boundingBox.height;

      if (left.isNaN ||
          top.isNaN ||
          right.isNaN ||
          bottom.isNaN ||
          width.isNaN ||
          height.isNaN) return;

      final opacity = (detectedObject.confidence - 0.2) / (1.0 - 0.2) * 0.9;

      // Calculate center coordinates of the bounding box
      final centerX = left + width / 2;
      final centerY = top + height / 2;

      // Draw circular frame with white border and image
      final imageSize = min(width, height) * 0.8; // Adjust the size of the image frame as needed
      final imageX = centerX - imageSize / 2;
      final imageY = centerY - imageSize / 2;

      final imageBorderRadius = imageSize / 4;
      final imageBorderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0; // Adjust the width of the border as needed

      canvas.drawCircle(
        Offset(centerX, centerY),
        imageBorderRadius,
        imageBorderPaint,
      );

      // Label
      final label = detectedObject.label;
      final capitalizedLabel = label.substring(0, 1).toUpperCase() + label.substring(1); // Capitalize first letter
      final labelBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.center,
          fontSize: 24, // Increase font size
          fontWeight: FontWeight.bold, // Set to bold
          textDirection: TextDirection.ltr,
        ),
      )
        ..pushStyle(
          ui.TextStyle(
            color: Colors.white,
            background: Paint()..color = colors[detectedObject.index % colors.length].withOpacity(0), 
          ),
        )
        ..addText(capitalizedLabel);
      final labelParagraph = labelBuilder.build()..layout(ui.ParagraphConstraints(width: width));

      // Adjust vertical position of the label
      final labelX = left;
      final labelY = max(0, centerY + imageSize / 2); // Adjust as needed

      canvas.drawParagraph(
        labelParagraph,
        Offset(left, labelY.toDouble()),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
