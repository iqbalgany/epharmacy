import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

class Helpers {
  static String getOptimizedUrl(String originalUrl, int width) {
    if (originalUrl.contains('ik.imagekit.io')) {
      return '$originalUrl?tr=w-$width';
    }
    return originalUrl;
  }

  static Future<String?> compressAndConvertToBase64(File file) async {
    try {
      final filePath = file.absolute.path;

      final Uint8List? compressedBytes =
          await FlutterImageCompress.compressWithFile(
            filePath,
            minWidth: 600,
            minHeight: 600,
            quality: 60,
          );

      if (compressedBytes == null) {
        return null;
      }

      String base64String = base64Encode(compressedBytes);

      return base64String;
    } catch (e) {
      return null;
    }
  }
}
