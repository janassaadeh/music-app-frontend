import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Color> getColorFromImageUrl(
  String url, {
  double luminanceThreshold = 0.4, // lower = darker
}) async {
  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;

  final codec = await ui.instantiateImageCodec(bytes);
  final frame = await codec.getNextFrame();
  final image = frame.image;

  final byteData =
      await image.toByteData(format: ui.ImageByteFormat.rawRgba);
  final data = byteData!.buffer.asUint8List();

  // Scan pixels (step >1 = faster)
  for (int i = 0; i < data.length; i += 16) {
    final r = data[i];
    final g = data[i + 1];
    final b = data[i + 2];
    final a = data[i + 3];

    if (a == 0) continue;

    final luminance =
        (0.2126 * r + 0.7152 * g + 0.0722 * b) / 255;

    if (luminance < luminanceThreshold) {
      return Color.fromARGB(a, r, g, b);
    }
  }

  // Fallback: darkest pixel
  return _findDarkestPixel(data);
}

Color _findDarkestPixel(Uint8List data) {
  double minLum = 1.0;
  Color darkest = Colors.black;

  for (int i = 0; i < data.length; i += 4) {
    final r = data[i];
    final g = data[i + 1];
    final b = data[i + 2];
    final a = data[i + 3];

    if (a == 0) continue;

    final lum =
        (0.2126 * r + 0.7152 * g + 0.0722 * b) / 255;

    if (lum < minLum) {
      minLum = lum;
      darkest = Color.fromARGB(a, r, g, b);
    }
  }

  return darkest;
}
