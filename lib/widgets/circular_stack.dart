import 'package:aria/theme/colors.dart';
import 'package:aria/theme/time.dart';
import 'package:aria/utils/math.dart';
import 'package:aria/utils/notations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CircularStack extends StatefulWidget {
  const CircularStack({
    Key? key,
    this.radius,
    required this.stackLength,
    required this.dotsLength,
    required this.color,
    this.curve,
    this.spacing = 10.0,
    this.dotRadius = 5.0,
    this.withLines = true,
  }) : super(key: key);

  final double? radius;
  final int stackLength;
  final int dotsLength;
  final double dotRadius;
  final Color color;
  final Curve? curve;
  final double spacing;
  final bool withLines;

  @override
  _CircularStackState createState() => _CircularStackState();
}

class _CircularStackState extends State<CircularStack>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progress;

  static const _kDefaultRadius = 40.0;

  double get _radius => widget.radius ?? _kDefaultRadius;

  int get _index => widget.stackLength - 1;

  double get _offsetY => _index * 10;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: k5000ms + Duration(milliseconds: randomInt(100)),
    );

    final curves = <Curve>[
      Curves.linear,
      Curves.ease,
      Curves.easeIn,
      Curves.easeInOut,
      Curves.easeOutQuint,
      Curves.bounceInOut,
      Curves.easeInQuad,
      Curves.easeInSine,
      Curves.fastOutSlowIn,
      Curves.elasticInOut,
    ];

    _progress = CurvedAnimation(
      parent: _controller.view,
      curve: widget.curve ?? curves[_index % (curves.length - 1)],
    );

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

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
            painter: CircularStackPainter(
              progress: 1 - _progress.value,
              color: widget.color,
              dotsLength: widget.dotsLength,
              stackLength: widget.stackLength,
              spacing: widget.spacing,
              dotRadius: widget.dotRadius,
              withLines: widget.withLines,
            ),
          );
        },
      ),
    );
  }
}

class CircularStackPainter extends CustomPainter {
  CircularStackPainter({
    required this.progress,
    required this.stackLength,
    required this.dotsLength,
    required this.color,
    required this.spacing,
    required this.dotRadius,
    required this.withLines,
  });

  @anchor
  final double progress;
  final int stackLength;
  final int dotsLength;
  final Color color;
  final double spacing;
  final double dotRadius;
  final bool withLines;

  late Canvas _canvas;
  late Size _size;

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    for (var i = stackLength - 1; i >= 0; i--) {
      _drawIndicator(Offset(0, -spacing * i));
    }
  }

  @override
  bool shouldRepaint(CircularStackPainter oldDelegate) =>
      progress != oldDelegate.progress;

  double get _radius => _size.shortestSide / 2;
  Offset get _center => Offset(_radius, _radius);

  void _drawIndicator([Offset offset = Offset.zero]) {
    final center = _center - offset;

    /// Stack background and border
    _canvas.drawCircle(center, _radius, Paint()..color = kAlmostBlackColor);
    _canvas.drawCircle(
      center,
      _radius,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke,
    );

    if (offset != Offset.zero) return;

    void connect(Offset from, Offset to, double opacity) {
      _canvas.drawLine(from, to, Paint()..color = color.withOpacity(opacity));
    }

    Offset circleAt(int index) {
      final isReverse = index % 2 == 0;

      final progress = isReverse ? 1 - this.progress : this.progress;

      final delay = index * (k2pi / dotsLength);
      final where = delay + k2pi * progress;

      return circlePoint(_radius, where % k2pi) +
          Offset(_radius, _radius) -
          offset;
    }

    for (var i = 0; i < dotsLength; i++) {
      final circle = circleAt(i);

      for (var j = 0; j < dotsLength; j++) {
        if (j == i) continue;

        final neighbor = circleAt(j);

        final distance = distanceBetween(circle, neighbor);

        final distanceOpacity = (1 - distance / (_radius * 2)).clamp(0, 1) / 1;

        if (withLines) {
          connect(circle, neighbor, distanceOpacity);
        }
      }

      _canvas.drawCircle(circle, dotRadius, Paint()..color = color);
    }
  }
}
