import 'dart:convert';
import 'dart:typed_data';

import 'package:cat_diet_planner/core/errors/localized_exception.dart';
import 'package:image/image.dart' as img;

class CatPhotoService {
  static String compressAndEncode(Uint8List bytes) {
    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      throw const LocalizedException('invalidImageFile');
    }

    final resized = decoded.width > 512 || decoded.height > 512
        ? img.copyResize(
            decoded,
            width: decoded.width >= decoded.height ? 512 : null,
            height: decoded.height > decoded.width ? 512 : null,
            interpolation: img.Interpolation.average,
          )
        : decoded;

    final jpg = img.encodeJpg(resized, quality: 82);
    return base64Encode(jpg);
  }
}
