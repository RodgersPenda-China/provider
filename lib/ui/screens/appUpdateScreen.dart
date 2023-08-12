import 'dart:io';

import 'package:edemand_partner/ui/widgets/customRoundButton.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateScreen extends StatelessWidget {
  final bool isForceUpdate;

  const AppUpdateScreen({Key? key, required this.isForceUpdate})
      : super(key: key);

  static Route route(RouteSettings settings) {
    Map arguments = settings.arguments as Map;
    return CupertinoPageRoute(builder: ((context) {
      return AppUpdateScreen(
        isForceUpdate: arguments['isForceUpdate'],
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width * 0.6,
                width: MediaQuery.of(context).size.width * 0.9,
                child: const RiveAnimation.asset(
                  "assets/animation/maintenance_mode.riv",
                  fit: BoxFit.contain,
                  artboard: "we are updating",
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                   "updateAppTitle".translate(context: context),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.headingFontColor,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 20.0),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                        isForceUpdate
                            ? "compulsoryUpdateSubTitle".translate(context: context)
                            : "normalUpdateSubTitle".translate(context: context),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.headingFontColor,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 16.0),
                    textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomRoundedButton(
                  onTap: () {
                    if (Platform.isIOS) {
                      launchUrl(Uri.parse(Constant.iosAppId),
                          mode: LaunchMode.externalApplication);
                    } else if (Platform.isAndroid) {
                      launchUrl(Uri.parse(Constant.playStoreApplicationLink),
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  widthPercentage: 1,
                  backgroundColor:
                      Theme.of(context).colorScheme.headingFontColor,
                  showBorder: false,
                  buttonTitle: "update".translate(context: context),
                ),
              ),
              if (!isForceUpdate)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomRoundedButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    widthPercentage: 1,
                    backgroundColor: Theme.of(context).colorScheme.primaryColor,
                    showBorder: true,
                    borderColor: Theme.of(context).colorScheme.headingFontColor,
                    buttonTitle:"notNow".translate(context: context),
                    titleColor: Theme.of(context).colorScheme.headingFontColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
