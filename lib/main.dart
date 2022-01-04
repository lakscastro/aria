import 'package:aria/pages/home_page.dart';
import 'package:aria/theme/colors.dart';
import 'package:aria/theme/typo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  runApp(const Root());
}

class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData.dark().copyWith();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        scaffoldBackgroundColor: kBackgroundColor,
        cardColor: kSurfaceColor,
        highlightColor: kHighlightColor,
        splashColor: kSplashColor,
        textTheme: theme.textTheme.apply(
          fontFamily: kFontFamily,
          bodyColor: kBodyColor,
        ),
      ),
      home: const HomePage(),
    );
  }
}
