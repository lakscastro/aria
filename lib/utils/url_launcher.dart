import 'package:url_launcher/url_launcher.dart' as launcher;

Future<void> openUrl(String url) => launcher.launch(url);
