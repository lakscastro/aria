import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

const kMinAnimationFun = 0;
const kMaxAnimationFun = 8;

class AnimationCard extends Equatable {
  const AnimationCard({
    required this.builder,
    required this.title,
    required this.description,
    required this.fun,
  }) : assert(
          fun >= kMinAnimationFun && fun <= kMaxAnimationFun,
        );

  final WidgetBuilder builder;
  final String title;
  final String description;
  final int fun;

  @override
  List<Object?> get props => [title, description, fun];
}
