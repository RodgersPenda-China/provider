// ignore_for_file: file_names

import 'dart:async';

import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

import 'awsomeNotification.dart';

class NotificationService {
  static FirebaseMessaging messagingInstance = FirebaseMessaging.instance;

  static LocalAwsomeNotification localNotification = LocalAwsomeNotification();

  static late StreamSubscription<RemoteMessage> foregroundStream;
  static late StreamSubscription<RemoteMessage> onMessageOpen;

  static requestPermission() async {}

  void updateFCM() async {
    await FirebaseMessaging.instance.getToken();
  }

  static init(context) {
    requestPermission();
    registerListeners(context);
  }

  @pragma('vm:entry-point')
  static Future<void> onBackgroundMessageHandler(RemoteMessage message) async {
    if (message.data['type'] == "new_order") {
      localNotification.createSoundNotification(
          title: message.notification?.title ?? "",
          body: message.notification?.body ?? "",
          notificationData: message,
          isLocked: false);
    } else {
      if (message.data["image"] == null) {
        localNotification.createNotification(
            isLocked: false, notificationData: message, playCustomSound: false);
      } else {
        localNotification.createImageNotification(
            isLocked: false, notificationData: message, playCustomSound: false);
      }
    }
  }

  static forgroundNotificationHandler() async {
    foregroundStream = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == "new_order") {
        localNotification.createSoundNotification(
            title: message.notification?.title ?? "",
            body: message.notification?.body ?? "",
            notificationData: message,
            isLocked: false);
      } else {
        if (message.data["image"] == null) {
          localNotification.createNotification(
              isLocked: false, notificationData: message, playCustomSound: false);
        } else {
          localNotification.createImageNotification(
              isLocked: false, notificationData: message, playCustomSound: false);
        }
        /*localNotification.createNotification(
                isLocked: false, notificationData: message, playCustomSound: false);*/
      }
    });
  }

  static terminatedStateNotificationHandler() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (RemoteMessage? message) {
        if (message == null) {
          return;
        }
        if (message.data["image"] == null) {
          localNotification.createNotification(
              isLocked: false, notificationData: message, playCustomSound: false);
        } else {
          localNotification.createImageNotification(
              isLocked: false, notificationData: message, playCustomSound: false);
        }
        /*localNotification.createNotification(
            isLocked: false, notificationData: message, playCustomSound: false);*/
      },
    );
  }

  static onTapNotificationHandler(context) {
    onMessageOpen = FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        if (message.data["type"] == "order") {
          //navigate to booking tab
          mainActivityNavigationBarGlobalKey.currentState?.currtab = 1;
        } else if (message.data["type"] == "withdraw_request") {
          Navigator.pushNamed(context, Routes.withdrawalRequests);
        } else if (message.data["type"] == "settlement") {
          //
        } else if (message.data["type"] == "provider_request_status") {
          if (message.data['status'] == "approve") {
          } else {}
        } else if (message.data["type"] == "url") {
          String url = message.data["url"].toString();
          try {
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            } else {
              throw 'Could not launch $url';
            }
          } catch (e) {
            throw 'Something went wrong';
          }
        }
      },
    );
  }

  static registerListeners(context) async {
    FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
    await forgroundNotificationHandler();
    await terminatedStateNotificationHandler();
    await onTapNotificationHandler(context);
  }

  static disposeListeners() {
    onMessageOpen.cancel();
    foregroundStream.cancel();
  }
}
