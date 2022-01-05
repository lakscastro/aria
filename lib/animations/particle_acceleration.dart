import 'package:aria/theme/colors.dart';
import 'package:aria/theme/dp.dart';
import 'package:aria/widgets/animated_acceleration.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class ParticleAcceleration extends StatefulWidget {
  const ParticleAcceleration({Key? key}) : super(key: key);

  @override
  State<ParticleAcceleration> createState() => _ParticleAccelerationState();
}

class _ParticleAccelerationState extends State<ParticleAcceleration> {
  /// Display that holds the particle
  static const _kParticleCanvasHeight = 50.0;

  Widget _buildParticleCanvas(AnimatedAccelerationState state) {
    return DottedBorder(
      color: kBorderColor,
      strokeWidth: k1dp,
      dashPattern: const [k4dp],
      child: ColoredBox(
        color: kSurfaceColor,
        child: Padding(
          padding: k4dp.padding(),
          child: CustomPaint(
            painter: _ParticleAcceleration(state.position, state.velocity),
            willChange: true,
            size: const Size.fromHeight(_kParticleCanvasHeight),
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

class _ParticleAcceleration extends CustomPainter {
  _ParticleAcceleration(this.position, this.velocity);

  static const _kRadius = 10.0;
  static const _kStrokeWidth = 2.0;
  static const _kWrapper = _kRadius * 2 + _kStrokeWidth * 2;

  final double position;
  final double velocity;

  late Canvas _canvas;
  late Size _size;

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    _drawParticle();
  }

  Offset get _center => Offset(_size.width / 2, _size.height / 2);

  Offset get _circle =>
      Offset((_size.width + _kWrapper * 2) * position, _center.dy)
          .translate(-_kWrapper, 0);

  @override
  bool shouldRepaint(_ParticleAcceleration oldDelegate) =>
      position != oldDelegate.position || velocity != oldDelegate.velocity;

  void _drawParticle() {
    final shadow = Path()
      ..addOval(Rect.fromCircle(center: _circle, radius: _kRadius));
    _canvas.drawShadow(
      shadow,
      kBackgroundColor,
      _kRadius * velocity + _kRadius / 2,
      true,
    );

    _canvas.drawCircle(
      _circle,
      _kRadius + _kStrokeWidth,
      Paint()..color = kBorderColor,
    );
    _canvas.drawCircle(_circle, _kRadius, Paint()..color = kSurfaceColor);
  }
}
