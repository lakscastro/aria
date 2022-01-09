import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';

extension DurationUtils on Duration {
  double get inDecimalSeconds =>
      inMicroseconds / Duration.microsecondsPerSecond;
}

extension AnimationControllerUtils on AnimationController {
  void infinite() {
    animateWith(_InfiniteSimulation());
  }
}

class _InfiniteSimulation extends Simulation {
  @override
  bool isDone(double timeInSeconds) => false;

  @override
  double dx(double time) => -1;

  @override
  double x(double time) => -1;
}
