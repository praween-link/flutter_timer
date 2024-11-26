part of '../../imports.dart';

class CircularPaint extends CustomPainter {
  final double prgressThickness;
  final double progressValue;
  final List<Color>? progressColors;
  final MaskFilter? progressMaskFilter;
  final Color? progressBackgroundColor;
  final ProgressShadow? progressShadow;
  final bool isPieShape;

  CircularPaint({
    this.prgressThickness = 8.0,
    required this.progressValue,
    this.progressColors,
    this.progressMaskFilter,
    this.progressBackgroundColor,
    this.progressShadow,
    this.isPieShape = false,
  });
  Path hitTestPath = Path();
  @override
  void paint(Canvas canvas, Size size) {
    Offset centerOffset = Offset(size.width / 2, size.height / 2);

    Rect rect = Rect.fromCenter(
        center: centerOffset, height: size.height, width: size.width);
    bool useCenter = false;

    // --Parent background
    Paint paintParent = Paint()
      ..color = (progressShadow?.color ?? Colors.blueGrey)
          .withAlpha((255.0 * 0.2).round())
      ..maskFilter =
          MaskFilter.blur(BlurStyle.normal, progressShadow?.blur ?? 9.5)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = prgressThickness + (progressShadow?.spreadRadius ?? 18);

    canvas.drawArc(
      rect,
      deg2rad(0),
      deg2rad(360),
      false,
      paintParent,
    );
    // --Child background
    Paint paint = Paint()
      ..color = progressBackgroundColor ??
          Colors.grey.withAlpha((255.0 * 0.2).round())
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = prgressThickness;

    canvas.drawArc(
      rect,
      deg2rad(0),
      deg2rad(360),
      false,
      paint,
    );

    // --frant progress bar
    List<Color> colors = [Colors.blueGrey, Colors.blueGrey];
    if (progressColors != null) {
      if (progressColors!.length == 1) {
        colors = [progressColors!.first, progressColors!.first];
      } else {
        colors = progressColors ?? [];
      }
    }
    Paint progressBarPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = prgressThickness
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: colors,
      ).createShader(rect)
      ..maskFilter = progressMaskFilter;

    /// --Pie shape
    if (isPieShape) {
      progressBarPaint.style = PaintingStyle.fill;
      rect = Rect.fromLTWH(0, 0, size.width, size.width);
      useCenter = true;
    }
    //---------

    canvas.drawArc(
      rect,
      deg2rad(-90),
      deg2rad(360 * (progressValue >= 0.99 ? 1 : progressValue)),
      useCenter,
      progressBarPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
