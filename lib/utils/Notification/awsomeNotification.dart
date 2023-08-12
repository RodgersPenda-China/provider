// ignore_for_file: file_names

import 'dart:math';

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LocalAwsomeNotification {
  final String soundNotificationChannel = "soundNotification";
  final String normalNotificationChannel = "normalNotification";

  //AwesomeNotifications notification = AwesomeNotifications();

  init(BuildContext context) {

  }


  createNotification(
      {required RemoteMessage notificationData,
      required bool isLocked,
      required bool playCustomSound}) async {
    try {

    } catch (e) {
      rethrow;
    }
  }

  createImageNotification(
      {required RemoteMessage notificationData,
      required bool isLocked,
      required bool playCustomSound}) async {
    try {

    } catch (e) {
      rethrow;
    }
  }

  createSoundNotification(
      {required String title,
      required String body,
      required RemoteMessage notificationData,
      required bool isLocked}) async {
    try {
      // await notification.createNotification(
      //   content: NotificationContent(
      //       id: Random().nextInt(5000),
      //       title: title,
      //       locked: false,
      //       autoDismissible: true,
      //       body: body,
      //       color: const Color.fromARGB(255, 79, 54, 244),
      //       wakeUpScreen: true,
      //       /* largeIcon: notificationData.data["image"],
      //       bigPicture: notificationData.data["image"],*/
      //       channelKey: soundNotificationChannel,
      //       notificationLayout: NotificationLayout.BigPicture),
      //);
    } catch (e) {
      rethrow;
    }
  }

  requestPermission() async {
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.getNotificationSettings();

    // if (notificationSettings.authorizationStatus == AuthorizationStatus.notDetermined) {
    //   await notification.requestPermissionToSendNotifications(
    //     channelKey: soundNotificationChannel,
    //     permissions: [
    //       // NotificationPermission.Alert,
    //       // NotificationPermission.Sound,
    //       // NotificationPermission.Badge,
    //       // NotificationPermission.Vibration,
    //       // NotificationPermission.Light
    //     ],
    //   );
    //
    //   if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized ||
    //       notificationSettings.authorizationStatus == AuthorizationStatus.provisional) {}
    // } else if (notificationSettings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

}
