import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension BuildContextAlias on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get media => MediaQuery.of(this);
  Size get screen => media.size;
  double get width => screen.width;
  double get height => screen.height;
  double get shortestSide => screen.shortestSide;
  double get longestSide => screen.longestSide;
}
