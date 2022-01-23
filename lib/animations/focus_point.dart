import 'package:aria/theme/dp.dart';
import 'package:aria/utils/math.dart';
import 'package:aria/utils/notations.dart';
import 'package:flutter/material.dart';

class FocusPoint extends StatefulWidget {
  const FocusPoint({Key? key}) : super(key: key);

  @override
  _FocusPointState createState() => _FocusPointState();
}

class _FocusPointState extends State<FocusPoint> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _FocusPointPainter(point: Offset.zero, scale: 1),
              child: const SizedBox.expand(),
            ),
          ),
          Positioned.fill(
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerDown: (_) => {},
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusPointPainter extends CustomPainter {
  _FocusPointPainter({required this.point, required this.scale});

  final Offset point;
  final double scale;

  late final Canvas _canvas;

  @real
  late final Size _size;

  @real
  double get _slot => 100.0;

  int get _countX => (_size.width / _slot).ceil();
  int get _countY => (_size.height / _slot).ceil();
  Offset get _offset => Offset(
        (_size.width - _countX * _slot).abs() / 2,
        (_size.height - _countY * _slot).abs() / 2,
      );

  @override
  void paint(Canvas canvas, Size size) {
    _canvas = canvas;
    _size = size;

    _drawBackground();
  }

  @override
  bool shouldRepaint(_FocusPointPainter oldDelegate) =>
      point != oldDelegate.point;

  void _drawBackground() {
    final size = _size * scale;

    final center = size.center(Offset.zero);
    final topCenter = size.topCenter(Offset.zero);
    final bottomCenter = size.bottomCenter(Offset.zero);
    final centerLeft = size.centerLeft(Offset.zero);
    final centerRight = size.centerRight(Offset.zero);

    final path = Path()
      ..addPolygon([topCenter, bottomCenter], false)
      ..addPolygon([centerLeft, centerRight], false);

    var leftCursorX = center.dx;
    var rightCursorX = 0.0;

    while (leftCursorX >= 0 && rightCursorX <= _size.width) {
      leftCursorX -= _slot;
      rightCursorX += _slot;

      path.addArc(
        Rect.fromCircle(
          center: topCenter.translate(0, i * _slot - _offset.dy),
          radius: 2,
        ),
        0,
        k2pi,
      );
    }
    _canvas.drawPath(
      path,
      Paint()
        ..color = Colors.red
        ..style = PaintingStyle.stroke,
    );

    /// Origin
    _canvas.drawCircle(
      center,
      k1dp,
      Paint()..color = Colors.red,
    );
  }
}

const real = 0;
const scaled = 1;
