import 'package:aria/animations/circular_particle_acceleration.dart';
import 'package:aria/animations/connected_circles.dart';
import 'package:aria/animations/outline_circle.dart';
import 'package:aria/animations/particle_acceleration.dart';
import 'package:aria/animations/sine_particle_acceleration.dart';
import 'package:aria/models/animation_card.dart';

final animations = [
  AnimationCard(
    builder: (context) => const ParticleAcceleration(),
    title: 'road to nowhere',
    description: 'particle with static acceleration',
    fun: 4,
  ),
  AnimationCard(
    builder: (context) => const CircularParticleAcceleration(),
    title: 'the polar express',
    description: 'circle based animation with static acceleration',
    fun: 5,
  ),
  AnimationCard(
    builder: (context) => const SineParticleAcceleration(),
    title: 'we need to survive',
    description:
        'sine based animation with static acceleration, also I noticed that the physics need to be improved',
    fun: 2,
  ),
  AnimationCard(
    builder: (context) => const OutlineCircle(),
    title: 'fault',
    description: 'infinite outline circle animation',
    fun: 0,
  ),
  AnimationCard(
    builder: (context) => const ConnectedCircles(),
    title: 'left! right!',
    description: 'play with a set of connected circles',
    fun: 3,
  ),
]..sort((a, b) => a.fun - b.fun);
