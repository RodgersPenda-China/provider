import 'package:edemand_partner/app/appLocalization.dart';
import 'package:flutter/material.dart';

extension StringExtension on String {
  //
  String convertToAgo({required BuildContext context}) {
    Duration diff = DateTime.now().difference(DateTime.parse(this));

    if (diff.inDays >= 365) {
      return "${(diff.inDays / 365).toStringAsFixed(0)} ${"yearAgo".translate(context: context)}";
    } else if (diff.inDays >= 31) {
      return "${(diff.inDays / 31).toStringAsFixed(0)} ${"monthsAgo".translate(context: context)}";
    } else if (diff.inDays >= 1) {
      return "${diff.inDays} ${"daysAgo".translate(context: context)}";
    } else if (diff.inHours >= 1) {
      return "${diff.inHours} ${"hoursAgo".translate(context: context)}";
    } else if (diff.inMinutes >= 1) {
      return "${diff.inMinutes} ${"minutesAgo".translate(context: context)}";
    } else if (diff.inSeconds >= 1) {
      return "${diff.inSeconds} ${"secondsAgo".translate(context: context)}";
    }
    return "justNow".translate(context: context);
  }

  //
  String translate({required BuildContext context}) {
    return (AppLocalization.of(context)!.getTranslatedValues(this) ?? this).trim();
  }

  //
  getFirebaseError({required BuildContext context}) {
    if (this == "invalid-verification-code") {
      return "invalid_verification_code".translate(context: context);
    } else if (this == "invalid-phone-number") {
      return "invalid_phone_number".translate(context: context);
    } else if (this == "too-many-requests") {
      return "too_many_requests".translate(context: context);
    } else if (this == "network-request-failed") {
      return "network_request_failed".translate(context: context);
    } else {
      return "somethingWentWrong".translate(context: context);
    }
  }
}
