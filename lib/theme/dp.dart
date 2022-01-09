import 'package:flutter/cupertino.dart';

const k0dp = 0.0;
const k1dp = 2.0;
const k2dp = 4.0;
const k3dp = 6.0;
const k4dp = 8.0;
const k5dp = 10.0;
const k6dp = 12.0;
const k7dp = 14.0;
const k8dp = 16.0;
const k9dp = 18.0;
const k10dp = 20.0;
const k20dp = 40.0;
const k50dp = 100.0;

extension Util on double {
  EdgeInsets padding() => EdgeInsets.all(this);

  EdgeInsets symmetric({bool vertical = false, bool horizontal = false}) =>
      EdgeInsets.symmetric(
        horizontal: horizontal ? this : 0,
        vertical: vertical ? this : 0,
      );
}

const k1p1 = 1 / 1;
const k1p2 = 1 / 2;
const k3p2 = 3 / 2;
const k16p9 = 16 / 9;
