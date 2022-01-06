import 'package:aria/animations/circular_particle_acceleration.dart';
import 'package:aria/animations/particle_acceleration.dart';
import 'package:aria/animations/sine_particle_acceleration.dart';
import 'package:aria/models/animation_card.dart';

final animations = [
  AnimationCard(
    builder: (context) => const ParticleAcceleration(),
    title: 'road to nowhere',
    description: 'particle with static acceleration',
    complexity: 0,
  ),
  AnimationCard(
    builder: (context) => const CircularParticleAcceleration(),
    title: 'the polar express',
    description: 'circle based animation with static acceleration',
    complexity: 1,
  ),
  AnimationCard(
    builder: (context) => const SineParticleAcceleration(),
    title: 'we need to survive',
    description:
        'sine based animation with static acceleration, also I noticed that the physics need to be improved',
    complexity: 2,
  ),
];
