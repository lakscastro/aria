import 'package:aria/theme/colors.dart';
import 'package:aria/theme/context.dart';
import 'package:aria/theme/dp.dart';
import 'package:aria/theme/time.dart';
import 'package:aria/utils/animation.dart';
import 'package:aria/utils/math.dart';
import 'package:aria/utils/notations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OutlineCircle extends StatefulWidget {
  const OutlineCircle({
    Key? key,
  }) : super(key: key);

  @override
  _OutlineCircleState createState() => _OutlineCircleState();
}

class _OutlineCircleState extends SingleInfiniteAnimationMixin<OutlineCircle> {
  static const _kMinCirclePadding = 75.0;

  @override
  Duration get duration => k5000ms;

  @override
  void initState() {
    super.initState();

    controller?.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AspectRatio(
          aspectRatio: k1p1,
          child: SizedBox.expand(
            child: AnimatedBuilder(
              animation: controller!,
              builder: (context, child) {
                return CustomPaint(
                  willChange: true,
                  painter: OutlineCirclePainter(
                    animation!.value,
                    context.shortestSide ~/ _kMinCirclePadding,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineCirclePainter extends CustomPainter {
  OutlineCirclePainter(this.value, this.circleCount);

  @anchor
  final double value;
  final int circleCount;

  late Canvas _canvas;
  late Size _size;

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    _drawShape();
  }

  @override
  bool shouldRepaint(OutlineCirclePainter oldDelegate) =>
      value != oldDelegate.value;

  double get _radius => _size.shortestSide / 2;
  Offset get _center => Offset(_radius, _radius);
  double get _step => _radius / circleCount;

  void _drawShape() {
    for (var i = 0; i < circleCount; i++) {
      final radius = _radius * value * 2 - i * _step;

      if (radius >= _radius || radius <= 0) continue;

      @anchor
      final distanceFromCenter = (radius / _radius).clamp(0, 1);

      @anchor
      final distanceFromBounds = 1.0 - distanceFromCenter;

      final path = Path()
        ..addArc(Rect.fromCircle(center: _center, radius: radius), 0, k2pi);

      _canvas.drawPath(
        path,
        Paint()
          ..color = kGreenColor.withOpacity(distanceFromBounds)
          ..style = PaintingStyle.stroke
          ..strokeWidth = circleCount * distanceFromBounds,
      );
    }
  }
}
