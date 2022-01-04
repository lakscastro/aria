import 'dart:math';

import 'package:aria/theme/colors.dart';
import 'package:aria/theme/time.dart';
import 'package:aria/utils/math.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ComplexityIndicator extends StatefulWidget {
  const ComplexityIndicator({Key? key, this.radius, required this.complexity})
      : super(key: key);

  final double? radius;
  final int complexity;

  @override
  _ComplexityIndicatorState createState() => _ComplexityIndicatorState();
}

class _ComplexityIndicatorState extends State<ComplexityIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  static const _kDefaultRadius = 40.0;

  double get _radius => widget.radius ?? _kDefaultRadius;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: k5000ms + Duration(milliseconds: randomInt(100)),
    );

    final curves = [
      Curves.linear,
      Curves.ease,
      Curves.easeIn,
      Curves.easeInOut,
      Curves.easeInCirc,
      Curves.bounceInOut,
      Curves.easeInQuad,
      Curves.easeInSine,
      Curves.fastOutSlowIn,
      Curves.elasticInOut,
    ];

    _progress = CurvedAnimation(
      parent: _controller.view,
      curve: curves[widget.complexity],
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  double get _offsetY => widget.complexity * 10;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _radius * 2,
      height: _radius * 2 + _offsetY,
      child: AnimatedBuilder(
        animation: _controller.view,
        builder: (context, child) {
          return CustomPaint(
            willChange: true,
            painter: ComplexityIndicatorPainter(
              1 - _progress.value,
              widget.complexity,
            ),
          );
        },
      ),
    );
  }
}

class ComplexityIndicatorPainter extends CustomPainter {
  ComplexityIndicatorPainter(this.progress, this.complexity);

  final double progress;
  final int complexity;

  late Canvas _canvas;
  late Size _size;

  double get _radius => _size.shortestSide / 2;

  Offset get _center => Offset(_radius, _radius);

  void _drawIndicator([Offset offset = Offset.zero]) {
    final color = Color.lerp(kGreenColor, kRedColor, complexity / 9)!;

    final center = _center - offset;

    final shadow = Path()
      ..addOval(Rect.fromCircle(center: center, radius: _radius));

    _canvas.drawShadow(shadow, color.withOpacity(.2), 15, true);

    _canvas.drawCircle(center, _radius, Paint()..color = kAlmostBlackColor);
    _canvas.drawCircle(
      center,
      _radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke,
    );

    for (var i = 0; i <= complexity; i++) {
      final isReverse = i % 2 == 0;

      final progress = isReverse ? 1 - this.progress : this.progress;
      final delay = i * ((pi * 2) / (complexity + 1));
      final where = delay + 2 * pi * progress;

      final circle =
          circlePoint(_radius, where % (2 * pi)) + Offset(_radius, _radius);

      _canvas.drawCircle(circle, 5, Paint()..color = color);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    for (var i = complexity; i >= 0; i--) {
      _drawIndicator(Offset(0, -10.0 * i));
    }
  }

  @override
  bool shouldRepaint(ComplexityIndicatorPainter oldDelegate) =>
      progress != oldDelegate.progress;
}
