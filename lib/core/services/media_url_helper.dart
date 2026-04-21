import 'package:flutter/foundation.dart';
import 'dart:io';

String normalizeMediaUrl(String rawUrl) {
  if (rawUrl.isEmpty) return rawUrl;

  if (kIsWeb) {
    return rawUrl;
  }

  Uri? uri;
  try {
    uri = Uri.parse(rawUrl);
  } catch (_) {
    return rawUrl;
  }

  if (uri.host != 'localhost') {
    return rawUrl;
  }

  if (Platform.isAndroid) {
    return uri.replace(host: '10.0.2.2').toString();
  }

  return rawUrl;
}