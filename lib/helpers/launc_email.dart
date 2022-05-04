import 'package:url_launcher/url_launcher.dart';

Future launchEmail(String email) async {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'email',
    query: encodeQueryParameters(<String, String>{
      'subject': 'Cardinal Realty Support',
    }),
  );

  await launchUrl(emailLaunchUri);
}
