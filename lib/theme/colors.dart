import 'package:flutter/material.dart';

class BronetColors {
  // Sage grey-green accent
  static const sage         = Color(0xFFA8B6A1);  // original sage
  static const sageDark     = Color(0xFF7B9180);  // grey-green
  static const sageLight    = Color(0xFFBEC8B8);  // light sage
  static const sageBg       = Color(0xFFE4EDEA);  // soft sage background

  // App backgrounds
  static const bgApp        = Color(0xFFF0F5EC);
  static const bgCard       = Color(0xFFFFFFFF);
  static const bgSurface    = Color(0xFFF0F4ED);
  static const bgMuted      = Color(0xFFE4EAE0);

  // Dark
  static const forest       = Color(0xFF2C3528);
  static const forestDeep   = Color(0xFF1E2A1A);

  // Text
  static const textPrimary  = Color(0xFF2C3528);
  static const textMuted    = Color(0xFF6E7E68);
  static const textLight    = Color(0xFF9AAA94);

  // Status
  static const red          = Color(0xFFFF4D6A);
  static const amber        = Color(0xFFFFB830);
  static const green        = Color(0xFF3DAD7F);

  static List<BoxShadow> shadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    )
  ];

  static List<BoxShadow> shadowStrong = [
    BoxShadow(
      color: Colors.black.withOpacity(0.14),
      blurRadius: 28,
      offset: const Offset(0, 8),
    )
  ];
}
