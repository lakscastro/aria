import 'package:aria/theme/colors.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({
    Key? key,
    required this.child,
    this.onTap,
    this.enableSplash = true,
    this.onDoubleTap,
    this.onFocusChange,
    this.onHover,
    this.onLongPress,
    this.onTapCancel,
    this.onTapDown,
    this.onTapUp,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onDoubleTap;
  final GestureTapDownCallback? onTapDown;
  final VoidCallback? onTapCancel;
  final ValueChanged<bool>? onHover;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onFocusChange;
  final GestureTapUpCallback? onTapUp;
  final bool enableSplash;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onDoubleTap: onDoubleTap,
      onTapDown: onTapDown,
      onTapCancel: onTapCancel,
      onLongPress: onLongPress,
      onTapUp: onTapUp,
      child: InkWell(
        onHover: onHover,
        onFocusChange: onFocusChange,
        // onTap: enableSplash ? onTap ?? () {} : null,
        highlightColor: kHighlightColor,
        splashColor: kSplashColor,
        child: child,
      ),
    );
  }
}
