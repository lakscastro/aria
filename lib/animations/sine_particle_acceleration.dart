import 'dart:math';

import 'package:aria/theme/colors.dart';
import 'package:aria/theme/context.dart';
import 'package:aria/theme/dp.dart';
import 'package:aria/utils/math.dart';
import 'package:aria/widgets/animated_acceleration.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class SineParticleAcceleration extends StatefulWidget {
  const SineParticleAcceleration({Key? key}) : super(key: key);

  @override
  State<SineParticleAcceleration> createState() =>
      _SineParticleAccelerationState();
}

class _SineParticleAccelerationState extends State<SineParticleAcceleration> {
  /// Display that holds the particle
  static const _kParticleCanvasHeight = 80.0;
  static const _kPeriodWidth = 150.0;

  int get _periodCount => (context.media.size.width / _kPeriodWidth).ceil();

  Widget _buildParticleCanvas(AnimatedAccelerationState state) {
    return DottedBorder(
      color: kBorderColor,
      strokeWidth: k1dp,
      dashPattern: const [k4dp],
      child: SizedBox(
        height: _kParticleCanvasHeight,
        child: ColoredBox(
          color: kSurfaceColor,
          child: Padding(
            padding: k8dp.symmetric(vertical: true),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: RepaintBoundary(
                    child: CustomPaint(
                      painter: _SineParticleTrajetoryPainter(
                        state.velocity,
                        0,
                        1,
                        _periodCount,
                        1,
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: _SineParticlePainter(
                      state.position,
                      state.velocity,
                      _periodCount,
                    ),
                    willChange: true,
                  ),
                ),
              ],
            ),
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

class SineFunction {
  const SineFunction({required this.periodCount});

  final int periodCount;

  /// [x] must be within 0 and 1
  double yFromX(double x) {
    return (1 - sin(x * k2pi * periodCount)) / 2;
  }

  /// Convert a [0-1] based [offset] to a given [bound]
  Offset applyBound(Offset relative, Offset bound) {
    return Offset(relative.dx * bound.dx, relative.dy * bound.dy);
  }
}

class _SineParticlePainter extends CustomPainter {
  _SineParticlePainter(this.position, this.velocity, this.periodCount);

  static const _kRadius = 10.0;
  static const _kDiameter = _kRadius * 2;
  static const _kStrokeWidth = 2.0;

  final double position;
  final double velocity;
  final int periodCount;

  late Canvas _canvas;
  late Size _size;

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    _drawParticle();
  }

  SineFunction get _sineFunction => SineFunction(periodCount: periodCount);

  double get _x => position;
  double get _y => _sineFunction.yFromX(position);

  Offset get _position => _sineFunction
      .applyBound(Offset(_x, _y), Offset(_size.width, _size.height))
      // Avoid being teleported from the end to the begin
      .translate(_kDiameter * (position * 2 - 1), 0);

  @override
  bool shouldRepaint(_SineParticlePainter oldDelegate) =>
      position != oldDelegate.position || velocity != oldDelegate.velocity;

  void _drawParticle() {
    final shadow = Path()
      ..addOval(Rect.fromCircle(center: _position, radius: _kRadius));
    _canvas.drawShadow(
      shadow,
      kBackgroundColor,
      _kRadius * velocity + _kRadius / 2,
      true,
    );

    final color = Color.lerp(kBorderColor, kGreenColor, velocity)!;

    _canvas.drawCircle(
      _position,
      _kRadius + _kStrokeWidth,
      Paint()..color = color,
    );
    _canvas.drawCircle(_position, _kRadius, Paint()..color = kBackgroundColor);
  }
}

class _SineParticleTrajetoryPainter extends CustomPainter {
  _SineParticleTrajetoryPainter(
    this.velocity,
    this.start,
    this.end,
    this.periodCount,
    this.radius,
  ) : assert(start <= end);

  static const _kMinTrajetoryOpacity = 0.2;

  final double velocity;
  final double start;
  final double end;
  final int periodCount;
  final double radius;

  late Canvas _canvas;
  late Size _size;

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    _drawTrajetory();
  }

  @override
  bool shouldRepaint(_SineParticleTrajetoryPainter oldDelegate) =>
      velocity != oldDelegate.velocity;

  void _drawTrajetory() {
    const kPrecision = 0.01;

    final _sineFunction = SineFunction(periodCount: periodCount);

    final path = Path();
    var cursor = start;

    while (cursor <= end) {
      final x = cursor;

      final y = _sineFunction.yFromX(x);
      final reverseY = _sineFunction.yFromX(1 - x);

      final position = _sineFunction.applyBound(
        Offset(x, y),
        Offset(_size.width, _size.height),
      );

      final reversePosition = _sineFunction.applyBound(
        Offset(x, reverseY),
        Offset(_size.width, _size.height),
      );

      path.addArc(Rect.fromCircle(center: position, radius: radius), 0.0, k2pi);
      path.addArc(
        Rect.fromCircle(center: reversePosition, radius: radius),
        0.0,
        k2pi,
      );

      cursor += kPrecision;
    }

    _canvas.drawPath(
      path,
      Paint()
        ..color =
            kBorderColor.withOpacity(velocity.clamp(_kMinTrajetoryOpacity, 1)),
    );
  }
}
