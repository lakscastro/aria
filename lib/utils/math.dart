import 'dart:math';

import 'package:flutter/cupertino.dart';

const k2pi = pi * 2;

Offset circlePoint(double radius, double radians) =>
    Offset(radius * cos(radians), -radius * sin(radians));

int randomInt([int min = 0, int max = 1000]) {
  final random = Random();

  return random.nextInt(max - min) + min;
}

double distanceBetween(Offset from, Offset to) {
  final dx = (from.dx - to.dx).abs();
  final dy = (from.dy - to.dy).abs();

  return sqrt(dx * dx + dy * dy);
}
