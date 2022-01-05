import 'package:aria/animations/circular_particle_acceleration.dart';
import 'package:aria/animations/particle_acceleration.dart';
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
];
