import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:flutter/material.dart';

enum AppTheme { dark, light }

final appThemeData = {
  AppTheme.light: ThemeData(
    scaffoldBackgroundColor: pageBackgroundColor,
    brightness: Brightness.light,
    primaryColor: primaryColor,
    secondaryHeaderColor: subHeadingColor,
    fontFamily: "PlusJakartaSans",

    //textTheme
  ),
  AppTheme.dark: ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    secondaryHeaderColor: darkSubHeadingColor,
    scaffoldBackgroundColor: darkPrimaryColor,
    fontFamily: "PlusJakartaSans",
  )
};
