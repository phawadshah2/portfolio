import 'package:url_launcher/url_launcher.dart';

/// Opens an external link (or `mailto:`) in a new tab.
Future<void> openExternal(String url) async {
  await launchUrl(Uri.parse(url), webOnlyWindowName: '_blank');
}

Future<void> openEmail(String address) async {
  await launchUrl(Uri(scheme: 'mailto', path: address));
}
