import 'dart:math';

import 'package:aria/theme/colors.dart';
import 'package:aria/theme/dp.dart';
import 'package:aria/utils/math.dart';
import 'package:aria/widgets/animated_acceleration.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class CircularParticleAcceleration extends StatefulWidget {
  const CircularParticleAcceleration({Key? key}) : super(key: key);

  @override
  State<CircularParticleAcceleration> createState() =>
      _CircularParticleAccelerationState();
}

class _CircularParticleAccelerationState
    extends State<CircularParticleAcceleration> {
  Widget _buildParticleCanvas(AnimatedAccelerationState state) {
    return Expanded(
      child: Padding(
        padding: k4dp.padding(),
        child: DottedBorder(
          color: kBorderColor,
          borderType: BorderType.Circle,
          strokeWidth: k1dp,
          dashPattern: const [k4dp],
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                painter: _CircularParticleAccelerationPainter(
                    state.position, state.velocity),
                willChange: true,
                size: Size.infinite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAcceleration(
      builder: (context, state) => _buildParticleCanvas(state),
    );
  }
}

class _CircularParticleAccelerationPainter extends CustomPainter {
  _CircularParticleAccelerationPainter(this.position, this.velocity);

  static const _kRadius = 10.0;
  static const _kStrokeWidth = 2.0;

  final double position;
  final double velocity;

  late Canvas _canvas;
  late Size _size;

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    _drawBackground();

    /// [1 -] is used to reverse the current animation
    /// [position * 2] is used to skip an entire cycle of the animation
    /// [% 1] is used to normalize the advanced pointer created in the previous step
    final reversedFuturePosition = 1 - (position * 2) % 1;

    final circles = [
      _drawParticle(_radius, position),
      _drawParticle(_radius / 2, reversedFuturePosition),
      _drawParticle(0.0, position),
    ];

    for (var i = 0; i < circles.length - 1; i++) {
      connect(circles[i], circles[i + 1]);
    }
  }

  Offset get _center => Offset(_size.width / 2, _size.height / 2);
  double get _radius => _size.shortestSide / 2;

  @override
  bool shouldRepaint(_CircularParticleAccelerationPainter oldDelegate) =>
      position != oldDelegate.position || velocity != oldDelegate.velocity;

  Offset _circleWith(double radius, double position) =>
      circlePoint(radius, k2pi * (1 - position)) + _center;

  Offset _drawParticle(double radius, double position) {
    final circle = _circleWith(radius, position);

    final shadow = Path()
      ..addOval(Rect.fromCircle(center: circle, radius: _kRadius));
    _canvas.drawShadow(
      shadow,
      kBackgroundColor,
      _kRadius * velocity + _kRadius / 2,
      true,
    );

    _canvas.drawCircle(
      circle,
      _kRadius + _kStrokeWidth,
      Paint()..color = kBorderColor,
    );
    _canvas.drawCircle(
      _center,
      radius + _kStrokeWidth,
      Paint()
        ..color = kBorderColor.withOpacity(velocity / 2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = _kStrokeWidth,
    );

    _canvas.drawCircle(circle, _kRadius, Paint()..color = kSurfaceColor);

    return circle;
  }

  void _drawBackground() {
    _canvas.drawCircle(
      _center,
      _radius,
      Paint()..color = kSurfaceColor.withOpacity(velocity),
    );
  }

  void connect(Offset from, Offset to) {
    final color = kGreenColor.withOpacity(velocity);

    _canvas.drawLine(from, to, Paint()..color = color);

    _canvas.drawCircle(from, 5, Paint()..color = color);
    _canvas.drawCircle(to, 5, Paint()..color = color);
  }
}
