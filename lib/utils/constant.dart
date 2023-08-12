import 'package:edemand_partner/data/model/appLanguageModel.dart';
import 'package:edemand_partner/ui/screens/main_activity.dart';
import 'package:flutter/material.dart';

class Constant {
  static const String appName = 'eDemand Provider';

  static const String svgPath = 'assets/images/svg/';

  static const String baseUrl = "http://rentcar.ioevisa.net/provide/";

  static const bool isDemoModeEnable = false;

  static const int resendOTPCountDownTime = 30; //in seconds

  static const int limit = 10;

  static String? systemCurrency;
  static String? systemCurrencyCountryCode;
  static String? decimalPointsForPrice;
  static String? defaultCountryCode = "IN";

  static const int animationDuration = 1; //value is in seconds
  //
  static String defaultLanguageCode = "en";

  static const String playStoreApplicationLink =
      "https://play.google.com/store/apps/details?id=wrteam.edemand.provider";

  static const String iosAppId = "https://testflight.apple.com/join/n5tteGPs";
}

//global key
GlobalKey<MainActivityState> mainActivityNavigationBarGlobalKey = GlobalKey<MainActivityState>();

//add  gradient color to show in the chart on home screen
List<LinearGradient> gradientColorForBarChart = [
  LinearGradient(
      colors: [Colors.green.shade300, Colors.green],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight),
  LinearGradient(
      colors: [Colors.blue.shade300, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight),
  LinearGradient(
      colors: [Colors.purple.shade300, Colors.purple],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight),
];

const List<AppLanguage> appLanguages = [
  //Please add language code here and language name and svg image in assets/images/svg/
  AppLanguage(languageCode: "en", languageName: "English", imageURL: 'america_flag'),
  AppLanguage(languageCode: "hi", languageName: "हिन्दी - Hindi", imageURL: 'india_flag'),
  AppLanguage(languageCode: "ar", languageName: "عربى - Arabic", imageURL: 'arab_flag'),
];

// to manage snackBar/toast/message
enum MessageType { success, error, warning }

Map<MessageType, Color> messageColors = {
  MessageType.success: Colors.green,
  MessageType.error: Colors.red,
  MessageType.warning: Colors.orange
};

Map<MessageType, IconData> messageIcon = {
  MessageType.success: Icons.done_rounded,
  MessageType.error: Icons.error_outline_rounded,
  MessageType.warning: Icons.warning_amber_rounded
};
