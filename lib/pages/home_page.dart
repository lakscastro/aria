import 'package:aria/animations/circular_particle_acceleration.dart';
import 'package:aria/animations/particle_acceleration.dart';
import 'package:aria/const/animations.dart';
import 'package:aria/const/links.dart';
import 'package:aria/models/animation_card.dart';
import 'package:aria/theme/colors.dart';
import 'package:aria/theme/context.dart';
import 'package:aria/theme/dp.dart';
import 'package:aria/theme/typo.dart';
import 'package:aria/utils/math.dart';
import 'package:aria/utils/url_launcher.dart';
import 'package:aria/widgets/circular_stack.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _buildAnimationCard(AnimationCard card) {
    final color = Color.lerp(
      kGreenColor,
      kRedColor,
      card.complexity / kMaxAnimationComplexity,
    );

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
            CircularStack(
              color: color!,
              dotsLength: card.complexity + 1,
              stackLength: card.complexity + 1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: k5dp),
              child: Text(
                card.title,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(height: kBodyHeight, color: kLightColor),
              ),
            ),
            Text(
              card.description,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(height: kBodyHeight, color: kBorderColor),
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
                  for (final card in animations) _buildAnimationCard(card),
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
            InkWell(
              onTap: () => openUrl(kGithubRepository),
              highlightColor: kHighlightColor,
              child: Container(
                width: double.infinity,
                padding: k10dp.padding(),
                child: Column(
                  children: [
                    const CircularStack(
                      withLines: false,
                      stackLength: 2,
                      dotsLength: 3,
                      curve: Curves.decelerate,
                      color: kHighContrast,
                      radius: 10,
                      dotRadius: 2,
                    ),
                    Padding(
                      padding: k10dp.padding(),
                      child: Text(
                        'open github repository',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'aria',
                            style: context.textTheme.overline!.copyWith(
                              color: kHighContrast,
                              decoration: TextDecoration.overline,
                            ),
                          ),
                          TextSpan(
                            text: ' written by ',
                            style: context.textTheme.overline!
                                .copyWith(color: kBorderColor),
                          ),
                          TextSpan(
                            text: 'laks ',
                            style: context.textTheme.overline!
                                .copyWith(color: kRedColor),
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
            ),
            Padding(padding: k20dp.padding()),
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
        ],
      ),
    );
  }
}
