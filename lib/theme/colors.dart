import 'package:flutter/material.dart';

class BronetColors {
  // Blue accent (trust palette)
  static const sage         = Color(0xFF68A8D4);  // medium blue accent
  static const sageDark     = Color(0xFF4A88BB);  // darker blue
  static const sageLight    = Color(0xFF96C3E3);  // light blue
  static const sageBg       = Color(0xFFD4EAFB);  // soft blue background

  // App backgrounds
  static const bgApp        = Color(0xFFEEF5FB);
  static const bgCard       = Color(0xFFFFFFFF);
  static const bgSurface    = Color(0xFFF0F6FC);
  static const bgMuted      = Color(0xFFDFF0FA);

  // Primary blue
  static const forest       = Color(0xFF1A6CC5);
  static const forestDeep   = Color(0xFF1155A8);

  // Text
  static const textPrimary  = Color(0xFF1A3A5C);
  static const textMuted    = Color(0xFF4872A0);
  static const textLight    = Color(0xFF78A0C0);

  // Status
  static const red          = Color(0xFFFF4D6A);
  static const amber        = Color(0xFFFFB830);
  static const green        = Color(0xFF3DAD7F);

  // 0x14 = ~8% opacity — blue-tinted shadow
  static const List<BoxShadow> shadow = [
    BoxShadow(
      color: Color(0x141A6CC5),
      blurRadius: 16,
      offset: Offset(0, 4),
    )
  ];

  // 0x24 = ~14% opacity
  static const List<BoxShadow> shadowStrong = [
    BoxShadow(
      color: Color(0x241A6CC5),
      blurRadius: 28,
      offset: Offset(0, 8),
    )
  ];
}
