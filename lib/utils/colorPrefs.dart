import 'package:flutter/material.dart';

extension ColorPrefs on ColorScheme {
  static Map<int, Color> color = {
    //grey
    50: const Color.fromRGBO(52, 63, 83, .1),
    100: const Color.fromRGBO(52, 63, 83, .2),
    200: const Color.fromRGBO(52, 63, 83, .3),
    300: const Color.fromRGBO(52, 63, 83, .4),
    400: const Color.fromRGBO(52, 63, 83, .5),
    500: const Color.fromRGBO(52, 63, 83, .6),
    600: const Color.fromRGBO(52, 63, 83, .7),
    700: const Color.fromRGBO(52, 63, 83, .8),
    800: const Color.fromRGBO(52, 63, 83, .9),
    900: const Color.fromRGBO(52, 63, 83, 1),
  };
//
  static const Color greenColor = Colors.green;
  static const Color starRatingColor = Colors.amber;
  static const Color redColor = Colors.red;
//theme colors

  static Color lightPrimaryColor = const Color(0xffF2F1F6); //background color
  static Color lightSecondaryColor = const Color(0xffFFFFFF);
  static Color lightAccentColor = const Color(0xff2560FC);

  static Color lightHeadingFontColor = const Color(0xff343F53);
  static Color lightSubHeadingColor = const Color(0xff989898);
  static Color lightSubHeadingColor1 = const Color(0xff000000);

  static Color darkPrimaryColor = const Color(0xff121212);
  static Color darkSecondaryColor = const Color(0xff202021);
  static Color darkAccentColor = const Color(0xff3354AB);

  static Color darkHeadingFontColor = const Color(0xff647AA3);
  static Color darkSubHeadingColor = const Color(0x99FFFFFF);
  static Color darkSubHeadingColor1 = const Color(0xDDFFFFFF);

  Color get primaryColor => brightness == Brightness.light ? lightPrimaryColor : darkPrimaryColor;
  Color get secondaryColor =>
      brightness == Brightness.light ? lightSecondaryColor : darkSecondaryColor;
  Color get accentColor => brightness == Brightness.light ? lightAccentColor : darkAccentColor;
  Color get headingFontColor =>
      brightness == Brightness.light ? lightHeadingFontColor : darkHeadingFontColor;
  Color get lightGreyColor =>
      brightness == Brightness.light ? lightSubHeadingColor : darkSubHeadingColor;
  Color get blackColor =>
      brightness == Brightness.light ? lightSubHeadingColor1 : darkSubHeadingColor1;

  Color get shimmerBaseColor => brightness == Brightness.light
      ? const Color.fromARGB(255, 225, 225, 225)
      : const Color.fromARGB(255, 150, 150, 150);
  Color get shimmerHighlightColor =>
      brightness == Brightness.light ? Colors.grey.shade100 : Colors.grey.shade300;
  Color get shimmerContentColor => brightness == Brightness.light
      ? Colors.white.withOpacity(0.85)
      : Colors.white.withOpacity(0.7);

  static Color whiteColors = Colors.white;
}

const Color primaryColor = Color(0xffF2F1F6); //background color

const Color subHeadingColor = Color(0xffCFCFCF);

const Color darkPrimaryColor = Color(0xff202021);

const Color darkSubHeadingColor = Color(0xff555555);

const Color pageBackgroundColor = Color(0xfff2f1f6);

//shimmer colors
