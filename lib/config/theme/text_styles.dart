import 'package:flutter/material.dart';

class TextStyles {
  static const TextStyle headline1 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle headline2 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle bodyText2 = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
  );

  static TextTheme get textTheme {
    return const TextTheme(
      displayLarge: headline1,
      displayMedium: headline2,
      bodyLarge: bodyText1,
      bodyMedium: bodyText2,
    );
  }
}
