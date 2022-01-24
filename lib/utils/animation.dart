import 'package:aria/theme/time.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension DurationUtils on Duration {
  double get inDecimalSeconds =>
      inMicroseconds / Duration.microsecondsPerSecond;
}

/// Helper class to implement a simple loop animation
abstract class SingleInfiniteAnimation<T extends StatefulWidget>
    extends State<T> with SingleTickerProviderStateMixin<T> {
  AnimationController? controller;
  Animation<double>? animation;

  @protected
  Duration get duration => k1000ms;

  @protected
  Curve get curve => Curves.linear;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(vsync: this, duration: duration);

    animation = CurvedAnimation(parent: controller!, curve: curve);
  }

  @override
  void dispose() {
    controller?.dispose();

    super.dispose();
  }
}
