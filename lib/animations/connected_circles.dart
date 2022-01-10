import 'dart:ui';

import 'package:aria/theme/colors.dart';
import 'package:aria/theme/dp.dart';
import 'package:aria/utils/math.dart';
import 'package:aria/utils/notations.dart';
import 'package:aria/widgets/animated_acceleration.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConnectedCircles extends StatefulWidget {
  const ConnectedCircles({Key? key}) : super(key: key);

  @override
  State<ConnectedCircles> createState() => _ConnectedCirclesState();
}

class _ConnectedCirclesState extends State<ConnectedCircles> {
  Widget _buildAnimationSurface(AnimatedAccelerationState state) {
    return AspectRatio(
      aspectRatio: k16p3,
      child: DottedBorder(
        color: kBorderColor,
        dashPattern: const [k4dp],
        strokeWidth: k1dp,
        child: ColoredBox(
          color: kSurfaceColor,
          child: Padding(
            padding: k4dp.symmetric(vertical: true),
            child: SizedBox.expand(
              child: AnimatedBuilder(
                animation: state.controller,
                builder: (context, child) {
                  return CustomPaint(
                    willChange: true,
                    painter: ConnectedCirclesPainter(state.position),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedAcceleration(
      builder: (context, state) => _buildAnimationSurface(state),
    );
  }
}

class ConnectedCirclesPainter extends CustomPainter {
  ConnectedCirclesPainter(this.value);

  static const _kCircleStrokeWidth = k1dp;
  static const _kPreferredCircleSize = 75.0;

  @anchor
  final double value;

  late Canvas _canvas;
  late Size _size;

  double get _slot => (_size.width / _circleCount).clamp(0, _size.shortestSide);
  double get _radius => _slot / 2;
  double get _circleSize => _kPreferredCircleSize.clamp(0, _size.shortestSide);
  int get _circleCount =>
      (_size.longestSide ~/ _circleSize).clamp(0, _size.shortestSide) ~/ 1;
  double get _padding => (_size.longestSide - _slot * _circleCount) / 2;

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    _drawShape();
  }

  @override
  bool shouldRepaint(ConnectedCirclesPainter oldDelegate) =>
      value != oldDelegate.value;

  Offset get _center => Offset(_size.width / 2, _size.height / 2);

  void _drawShape() {
    final connections = <Offset>[];

    for (var i = 0; i < _circleCount; i++) {
      final offset = Offset(_slot * i + _padding, _center.dy);
      final center = Offset(offset.dx + _radius, offset.dy);

      final circleFragmentLength = _circleCount;

      /// Split circle into lines
      for (var j = 0; j < circleFragmentLength; j++) {
        final step = k2pi / circleFragmentLength;
        final radians = 1 - (j * step + value * k2pi) % k2pi;

        _canvas.drawLine(
          center,
          circlePoint(_radius, radians).translate(center.dx, center.dy),
          Paint()..color = kBorderColor,
        );

        if (j == i) {
          final marker = step / 2 + radians;
          final markerPosition =
              circlePoint(_radius / 2, marker).translate(center.dx, center.dy);

          connections.add(markerPosition);
        }
      }

      _canvas.drawCircle(
        center,
        _radius,
        Paint()
          ..color = kLightColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = _kCircleStrokeWidth,
      );
    }

    for (var i = 0; i < connections.length - 1; i++) {
      _canvas.drawLine(
        connections[i],
        connections[i + 1],
        Paint()
          ..color = kLightColor
          ..strokeWidth = k1dp,
      );

      void drawCircle(Offset center) {
        final path = Path()
          ..addArc(
            Rect.fromCircle(center: center, radius: _radius / 2),
            0,
            k2pi,
          );

        _canvas.drawPath(
          path,
          Paint()..color = kLightColor,
        );
      }

      if (i == 0) {
        drawCircle(connections[i]);
      } else if (i == connections.length - 2) {
        drawCircle(connections[i + 1]);
      }
    }
  }
}
