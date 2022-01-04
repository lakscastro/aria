import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension BuildContextAlias on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  MediaQueryData get media => MediaQuery.of(this);
  Size get screen => media.size;
}
