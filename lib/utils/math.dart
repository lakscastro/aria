import 'dart:math';

import 'package:flutter/cupertino.dart';

Offset circlePoint(double radius, double radians) =>
    Offset(radius * cos(radians), -radius * sin(radians));

int randomInt([int min = 0, int max = 1000]) {
  final random = Random();

  return random.nextInt(max - min) + min;
}
