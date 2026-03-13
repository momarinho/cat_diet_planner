import 'dart:convert';

import 'package:flutter/material.dart';

const kDefaultCatPhotoUrl =
    'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&w=200&q=80';

ImageProvider<Object> catPhotoProvider({
  String? photoPath,
  String? photoBase64,
}) {
  if (photoBase64 != null && photoBase64.isNotEmpty) {
    return MemoryImage(base64Decode(photoBase64));
  }

  if (photoPath != null && photoPath.isNotEmpty) {
    return NetworkImage(photoPath);
  }

  return const NetworkImage(kDefaultCatPhotoUrl);
}
