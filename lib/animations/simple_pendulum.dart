import 'dart:math';

import 'package:aria/theme/colors.dart';
import 'package:aria/theme/dp.dart';
import 'package:aria/utils/animation.dart';
import 'package:aria/utils/math.dart';
import 'package:aria/utils/notations.dart';
import 'package:flutter/material.dart';

class SimplePendulum extends StatefulWidget {
  const SimplePendulum({Key? key}) : super(key: key);

  @override
  _SimplePendulumState createState() => _SimplePendulumState();
}

class _SimplePendulumState extends SingleInfiniteAnimation<SimplePendulum> {
  double get _time => controller?.lastElapsedDuration?.inDecimalSeconds ?? 0;

  static const _kGravity = 9.8;

  var _velociy = 0.0;
  var _amplitude = 0.0;

  double get _velocityX => _velociy * cos(_amplitude);
  double get _velocityY => _velociy * sin(_amplitude);

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
            child: Padding(
              padding: k5dp.padding(),
              child: AnimatedBuilder(
                animation: controller!,
                builder: (context, child) => CustomPaint(
                  painter: _SimplePendulumPainter(_time),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SimplePendulumPainter extends CustomPainter {
  _SimplePendulumPainter(this.time);

  /// In decimal seconds
  final double time;

  static const _kCircleSize = 100.0;
  static const _kColor = kGreenColor;

  @anchor
  static const _kPendulumRadius = 1.0;

  late Canvas _canvas;
  late Size _size;

  Offset get _center => _size.center(Offset.zero);
  double get _radius => _kPendulumRadius * _size.shortestSide / 2;

  Paint get _paint => Paint()..color = _kColor;

  Offset get _sun => _center.translate(_center.dx / 2, 0);

  void _drawSun() {
    const color = Color(0xFFD2421A);

    _canvas.drawShadow(
      Path()
        ..addArc(
          Rect.fromCircle(center: _sun, radius: _kCircleSize),
          0,
          k2pi,
        ),
      color,
      _kCircleSize,
      true,
    );

    _canvas.drawCircle(
      _sun,
      _kCircleSize,
      Paint()..color = Colors.red,
    );
  }

  void _drawPlanets() {
    final planets = <List<double>>[
      [
        0.42,
        1.0,
        0xFF436BF3,
      ],
      [
        0.42,
        0.95,
        0xFFCDF2F5,
      ],
      [
        0.95,
        0.9,
        0xFFC6AC71,
      ],
      [
        1,
        0.85,
        0xFFB2745F,
      ],
      [
        0.13,
        0.8,
        0xFFF7835D,
      ],
      [
        0.3,
        0.7,
        0xFF506EAE,
      ],
      [
        0.2,
        0.6,
        0xFFD8A23B,
      ],
      [
        0.1,
        0.5,
        0xFFA19D9E,
      ],
    ];

    for (var i = 0; i < planets.length; i++) {
      final planet = planets[i];

      _drawBodyTrajetory(planet.first, planet[1], planet[2] ~/ 1);
    }

    for (var i = 0; i < planets.length; i++) {
      final planet = planets[i];

      _drawBody(planet.first, planet[1], planet[2] ~/ 1);
    }
  }

  void _drawBody(@anchor double size, double radius, int color) {
    final longest = _radius / 1.2;

    final position = ellipticalPoint(
          _sun.dx * radius,
          longest * radius,
          k2pi * (time / (radius * 5)),
        ) +
        _center;

    final colored = Color(color);

    _canvas.drawShadow(
      Path()
        ..addArc(
          Rect.fromCircle(center: position, radius: size * _kCircleSize / 2),
          0,
          k2pi,
        ),
      colored,
      50,
      true,
    );

    final coloredHSL = HSLColor.fromColor(colored);
    _canvas.drawCircle(
      position,
      (size * _kCircleSize / 2) + 1,
      Paint()
        ..color =
            coloredHSL.withLightness(coloredHSL.lightness + 0.1).toColor(),
    );

    _canvas.drawCircle(
      position,
      size * _kCircleSize / 2,
      Paint()..color = colored,
    );
  }

  void _drawBodyTrajetory(@anchor double size, double radius, int color) {
    var cursor = 0.0;
    final path = Path();

    final longest = _radius / 1.2;

    while (cursor <= 10.0) {
      final position = ellipticalPoint(
            _sun.dx * radius,
            longest * radius,
            k2pi * (cursor / (radius * 10)),
          ) +
          _center;

      path.addArc(Rect.fromCircle(center: position, radius: 4), 0, k2pi);

      cursor += 0.1;
    }

    _canvas.drawPath(path, Paint()..color = kDarkerColor);
  }

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    _drawPlanets();
    _drawSun();
  }

  @override
  bool shouldRepaint(_SimplePendulumPainter oldDelegate) =>
      oldDelegate.time != time;
}
