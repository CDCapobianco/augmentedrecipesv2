// ignore_for_file: unused_field, lines_longer_than_80_chars, use_named_constants

import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ultralytics_yolo/predict/detect/detected_object.dart';

/// A painter used to draw the detected objects on the screen.

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
    // ignore: unused_local_variable
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


      // Calculate center coordinates of the bounding box
      final centerX = left + width / 2;
      final centerY = top + height / 2;

      // Draw circular frame with white border and image
      final imageSize = min(width, height) * 0.5; // Adjust the size of the image frame as needed
      final imageX = centerX - imageSize / 2;
      final imageY = centerY - imageSize / 2;

      final imageBorderRadius = imageSize / 2;
      final imageBorderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0; // Adjust the width of the border as needed

      final label = detectedObject.label;
      final imagePath = 'assets/label_images/$label.jpg';

      final imageProvider = AssetImage(imagePath);

      canvas..drawCircle(
        Offset(centerX, centerY),
        imageBorderRadius,
        imageBorderPaint,
      )

      ..save()
      ..clipPath(Path()
        ..addOval(Rect.fromCircle(center: Offset(centerX, centerY), radius: imageBorderRadius)),);
      imageProvider.resolve(const ImageConfiguration()).addListener(
        ImageStreamListener(
          (ImageInfo imageInfo, bool synchronousCall) {
            final rect = Rect.fromLTWH(
              imageX,
              imageY,
              imageSize,
              imageSize,
            );
            canvas.drawImageRect(
              imageInfo.image,
              Rect.fromLTRB(0, 0, imageInfo.image.width.toDouble(), imageInfo.image.height.toDouble()),
              rect,
              Paint(),
            );
          },
        ),
      );
      canvas.restore();

      // Label
      final capitalizedLabel = label.substring(0, 1).toUpperCase() + label.substring(1); // Capitalize first letter
      // Create a TextStyle with Google Fonts
      final googleFontTextStyle = ui.TextStyle(
        fontFamily: GoogleFonts.poppins().fontFamily, // Specify the Google Font family
        fontSize: 24, // Increase font size
        fontWeight: FontWeight.normal, // Set to bold
        color: Colors.white,
        // You can add more properties here as needed
      );

      // Create the label builder with the Google Font TextStyle
      final labelBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        ),
      )
        ..pushStyle(googleFontTextStyle)
        ..addText(capitalizedLabel);
      final labelParagraph = labelBuilder.build()..layout(ui.ParagraphConstraints(width: width));

      // Adjust vertical position of the label
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
