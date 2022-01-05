import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

const kMinAnimationComplexity = 0;
const kMaxAnimationComplexity = 4;

class AnimationCard extends Equatable {
  const AnimationCard({
    required this.builder,
    required this.title,
    required this.description,
    required this.complexity,
  }) : assert(
          complexity >= kMinAnimationComplexity &&
              complexity <= kMaxAnimationComplexity,
        );

  final WidgetBuilder builder;
  final String title;
  final String description;
  final int complexity;

  @override
  List<Object?> get props => [title, description, complexity];
}
