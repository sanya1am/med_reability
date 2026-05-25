import 'package:flutter/foundation.dart';

String normalizeMediaUrl(String rawUrl) {
  if (rawUrl.isEmpty) return rawUrl;

  Uri uri;

  try {
    uri = Uri.parse(rawUrl);
  } catch (_) {
    return rawUrl;
  }

  if (!uri.hasScheme) {
    return rawUrl;
  }

  if (kIsWeb) {
    return rawUrl;
  }

  final isAndroid = defaultTargetPlatform == TargetPlatform.android;
  final isLocalhost = uri.host == 'localhost' || uri.host == '127.0.0.1';

  if (isAndroid && isLocalhost) {
    return uri.replace(host: '10.0.2.2').toString();
  }

  return rawUrl;
}