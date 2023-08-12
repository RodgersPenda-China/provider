import 'package:edemand_partner/app/appTheme.dart';
import 'package:edemand_partner/data/model/user_details_model.dart';
import 'package:edemand_partner/utils/hive_keys.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';

class HiveUtils {
  static String? getJWT() {
    return Hive.box(HiveKeys.userDetailsBox).get(HiveKeys.jwtToken);
  }

  static AppTheme getCurrentTheme() {
    var current = Hive.box(HiveKeys.themeBox).get(HiveKeys.currentTheme);

    if (current == null) {
      return AppTheme.light;
    }
    if (current == "light") {
      return AppTheme.light;
    }
    if (current == "dark") {
      return AppTheme.dark;
    }
    return AppTheme.light;
  }

  static setCurrentTheme(AppTheme theme) {
    String newTheme;
    if (theme == AppTheme.light) {
      newTheme = "light";
    } else {
      newTheme = "dark";
    }
    Hive.box(HiveKeys.themeBox).put(HiveKeys.currentTheme, newTheme);
  }

  static void setUserData(Map data) async {
    await Hive.box(HiveKeys.userDetailsBox).putAll(data);
  }

  static void setJWT(String token) async {
    await Hive.box(HiveKeys.userDetailsBox).put('token', token);
  }

  // static UserDetailsModel getUserDetails() {
  //   return UserDetailsModel.fromMap(Map.from(Hive.box(HiveKeys.userDetailsBox).toMap()));
  // }

  static ProviderDetails getProviderDetails() {
    try {
      return ProviderDetails.fromJson(Map.from(Hive.box(HiveKeys.userDetailsBox).toMap()));
    } catch (_) {}
    return ProviderDetails();
  }

  static setUserIsAuthenticated() {
    Hive.box(HiveKeys.authBox).put(HiveKeys.isAuthenticated, true);
  }

  static setUserIsNotAuthenticated() async {
    await Hive.box(HiveKeys.authBox).put(HiveKeys.isAuthenticated, false);
  }

  static setUserIsNotNew() {
    Hive.box(HiveKeys.authBox).put(HiveKeys.isAuthenticated, true);
    return Hive.box(HiveKeys.authBox).put(HiveKeys.isUserFirstTime, false);
  }

  static bool isUserAuthenticated() {
    return Hive.box(HiveKeys.authBox).get(HiveKeys.isAuthenticated) ?? false;
  }

  static bool isUserFirstTime() {
    return Hive.box(HiveKeys.authBox).get(HiveKeys.isUserFirstTime) ?? false;
  }

  static logoutUser({required VoidCallback onLogout}) async {
    await setUserIsNotAuthenticated();
    await Hive.box(HiveKeys.userDetailsBox).clear();
    onLogout.call();
  }

  static clear() async {
    await Hive.box(HiveKeys.userDetailsBox).clear();
  }
}
