import 'dart:math';

import 'package:aria/theme/colors.dart';
import 'package:aria/theme/dp.dart';
import 'package:aria/theme/time.dart';
import 'package:aria/utils/animation.dart';
import 'package:aria/utils/notations.dart';
import 'package:flutter/material.dart';

enum Behavior {
  idle,
  accelerate,
  decelerate,
}

class AnimatedAccelerationState {
  const AnimatedAccelerationState({
    required this.velocity,
    required this.position,
    required this.controller,
  });

  final double velocity;
  final double position;
  final AnimationController controller;

  AnimatedAccelerationState copyWith({
    double? velocity,
    double? position,
    AnimationController? controller,
  }) {
    return AnimatedAccelerationState(
      velocity: velocity ?? this.velocity,
      position: position ?? this.position,
      controller: controller ?? this.controller,
    );
  }
}

class AnimatedAcceleration extends StatefulWidget {
  const AnimatedAcceleration({Key? key, required this.builder})
      : super(key: key);

  final Widget Function(BuildContext, AnimatedAccelerationState) builder;

  @override
  State<AnimatedAcceleration> createState() => _AnimatedAccelerationState();
}

class _AnimatedAccelerationState extends State<AnimatedAcceleration>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  /// Hold the acceleration and constants required by the basic math
  static const _kAcceleration = 1.0;
  static const _kMaxVelocity = 10.0;

  /// Calc variables & state
  var _velocity = 0.0;
  late var _initialVelocity = _velocity;
  var _behavior = Behavior.idle;

  @anchor
  var _position = 0.5;

  @anchor
  late var _initialPosition = _position;

  /// Returns 0 if stopped or 1 if running fast
  double get _velocityLevel {
    return _velocity.clamp(-_kMaxVelocity, _kMaxVelocity).abs() / _kMaxVelocity;
  }

  double? get _elapsed => _controller?.lastElapsedDuration?.inDecimalSeconds;

  void _looper() {
    if (_controller == null) return;

    final acceleration = (() {
      if (_behavior == Behavior.accelerate) return _kAcceleration;
      if (_behavior == Behavior.decelerate) return -_kAcceleration;

      return 0;
    })();

    _velocity = _initialVelocity + (acceleration * _elapsed!);

    _position = _initialPosition +
        _initialVelocity * _elapsed! +
        (acceleration * pow(_elapsed!, 2)) / 2;

    _position = (_position % 1).abs();
  }

  void _setBehavior(Behavior target) {
    if (_behavior == target) return;

    _behavior = target;
    _initialVelocity = _velocity;
    _initialPosition = _position;
    _controller?.repeat();
  }

  Widget _buildTapArea(String text, Behavior behavior) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setBehavior(behavior),
        onTapUp: (_) => _setBehavior(Behavior.idle),
        onTapCancel: () => _setBehavior(Behavior.idle),
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
    return AnimatedBuilder(
      animation: _controller!.view,
      builder: (context, child) {
        return widget.builder(
          context,
          AnimatedAccelerationState(
            velocity: _velocityLevel,
            position: _position,
            controller: _controller!,
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: k500ms);

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
