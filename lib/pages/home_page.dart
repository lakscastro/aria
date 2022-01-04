import 'package:aria/animations/circular_particle_acceleration.dart';
import 'package:aria/animations/particle_acceleration.dart';
import 'package:aria/theme/colors.dart';
import 'package:aria/theme/context.dart';
import 'package:aria/theme/dp.dart';
import 'package:aria/widgets/complexity_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class AnimationCard {
  const AnimationCard({
    required this.builder,
    required this.title,
    required this.description,
    required this.complexity,
  }) : assert(complexity >= 0 && complexity < 10);

  final WidgetBuilder builder;
  final String title;
  final String description;
  final int complexity;
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final _animations = <AnimationCard>[
    for (var i = 0; i < 10; i++)
      if (i % 2 == 0 || i % 3 == 0)
        AnimationCard(
          builder: (context) => const ParticleAcceleration(),
          title: 'simple particle acceleration',
          description: 'a simple linear acceleration particle',
          complexity: i,
        )
      else
        AnimationCard(
          builder: (context) => const CircularParticleAcceleration(),
          title: 'circular particle acceleration',
          description:
              'a simple clock-based animation that shows a set of connected particles with accelerated and desaceleration features',
          complexity: i,
        ),
  ];

  Widget _buildAnimationCard(AnimationCard card) {
    return InkWell(
      onTap: () {
        final navigator = Navigator.of(context);
        final page = MaterialPageRoute(builder: card.builder);

        navigator.push(page);
      },
      child: Padding(
        padding: k5dp.padding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ComplexityIndicator(complexity: card.complexity),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: k5dp),
              child: Text(
                card.title,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(height: 1.2, color: kLightColor),
              ),
            ),
            Text(
              card.description,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(height: 1.2, color: kBorderColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('aria'),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'by ',
                  style: Theme.of(context).textTheme.overline,
                ),
                TextSpan(
                  text: 'laks',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: kBlackColor,
      elevation: 0,
    );
  }

  Widget _buildAnimationFeed() {
    return SliverPadding(
      padding: k3dp.padding(),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Padding(
              padding: k4dp.padding(),
              child: MasonryGridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                mainAxisSpacing: k8dp,
                children: [
                  for (final card in _animations) _buildAnimationCard(card),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsefulLinks() {
    return SliverPadding(
      padding: k20dp.symmetric(vertical: true).copyWith(bottom: k10dp),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Wrap(
              children: [
                InkWell(
                  onTap: () {},
                  child: Text(
                    'github repository',
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return SliverPadding(
      padding: k50dp.symmetric(vertical: true).copyWith(bottom: k20dp),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'written by ',
                    style: context.textTheme.overline!
                        .copyWith(color: kBorderColor),
                  ),
                  TextSpan(
                    text: 'laks ',
                    style:
                        context.textTheme.overline!.copyWith(color: kRedColor),
                  ),
                  TextSpan(
                    text: 'with ',
                    style: context.textTheme.overline!
                        .copyWith(color: kBorderColor),
                  ),
                  TextSpan(
                    text: 'dart',
                    style: context.textTheme.overline!
                        .copyWith(color: kGreenColor),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBlackColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          _buildAnimationFeed(),
          _buildUsefulLinks(),
          _buildFooter(),
        ],
      ),
    );
  }
}
