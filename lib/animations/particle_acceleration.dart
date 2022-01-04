import 'package:aria/theme/colors.dart';
import 'package:aria/theme/dp.dart';
import 'package:aria/theme/time.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

enum Behavior {
  idle,
  accelerate,
  decelerate,
}

class ParticleAcceleration extends StatefulWidget {
  const ParticleAcceleration({Key? key}) : super(key: key);

  @override
  State<ParticleAcceleration> createState() => _ParticleAccelerationState();
}

class _ParticleAccelerationState extends State<ParticleAcceleration>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  /// How slow the ball must be, should be greater than 0
  static const _kSlowDownFactor = 1000;

  /// Hold the acceleration and constants required by the basic math
  static const _kAcceleration = 1.0;
  static const _kMaxVelocity = 10.0;

  /// Display that holds the particle
  static const _kParticleCanvasHeight = 50.0;

  /// Calc variables & state
  var _velocity = 0.0;
  var _position = 0.0;
  var _behavior = Behavior.idle;

  /// Returns 0 if stopped or 1 if running fast
  double get _velocityLevel {
    return _velocity.clamp(-_kMaxVelocity, _kMaxVelocity).abs() / _kMaxVelocity;
  }

  void _looper() {
    if (_behavior == Behavior.accelerate) {
      _velocity += _kAcceleration;
    } else if (_behavior == Behavior.decelerate) {
      _velocity -= _kAcceleration;
    } else if (_behavior == Behavior.idle) {
      if (_velocity > 0) {
        _velocity -= _kAcceleration / 2;
      } else if (_velocity < 0) {
        _velocity += _kAcceleration / 2;
      }
    }

    _position += _velocity / _kSlowDownFactor;
    _position = (_position % 1).abs();
  }

  void _detachBehavior(Behavior target) {
    if (_behavior == target) {
      _behavior = Behavior.idle;
    }
  }

  Widget _buildTapArea(String text, Behavior behavior) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _behavior = behavior,
        onTapUp: (_) => _detachBehavior(behavior),
        onTapCancel: () => _detachBehavior(behavior),
        child: Padding(
          padding: k4dp.padding(),
          child: Center(
            child: Text(text, style: const TextStyle(letterSpacing: k3dp)),
          ),
        ),
      ),
    );
  }

  Widget _buildParticleCanvas() {
    return DottedBorder(
      color: kBorderColor,
      strokeWidth: k1dp,
      dashPattern: const [k4dp],
      child: ColoredBox(
        color: kSurfaceColor,
        child: Padding(
          padding: k4dp.padding(),
          child: AnimatedBuilder(
            animation: _controller!.view,
            builder: (context, child) {
              return CustomPaint(
                painter: ParticlePainter(_position, _velocityLevel),
                willChange: true,
                size: const Size.fromHeight(_kParticleCanvasHeight),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: k5000ms);

    _controller!.addListener(_looper);

    _controller!.repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTapArea('DECELERATE', Behavior.decelerate),
            _buildParticleCanvas(),
            _buildTapArea('ACCELERATE', Behavior.accelerate),
          ],
        ),
      ),
    );
  }
}

class ParticlePainter extends CustomPainter {
  ParticlePainter(this.position, this.velocity);

  final double position;
  final double velocity;

  late Canvas _canvas;
  late Size _size;

  Offset get _center => Offset(_size.width / 2, _size.height / 2);

  Offset get _circle =>
      Offset((_size.width + _kWrapper * 2) * position, _center.dy)
          .translate(-_kWrapper, 0);

  static const _kRadius = 10.0;
  static const _kStrokeWidth = 2.0;
  static const _kWrapper = _kRadius * 2 + _kStrokeWidth * 2;

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

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    _drawParticle();
  }

  @override
  bool shouldRepaint(ParticlePainter oldDelegate) =>
      position != oldDelegate.position || velocity != oldDelegate.velocity;
}
