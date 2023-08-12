import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';

class MaintenanceModeScreen extends StatelessWidget {
  final String message;

  const MaintenanceModeScreen({Key? key, required this.message}) : super(key: key);

  static Route<MaintenanceModeScreen> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) => MaintenanceModeScreen(message: routeSettings.arguments as String));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 250,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: const RiveAnimation.asset(
                    "assets/animation/maintenance_mode.riv",
                    fit: BoxFit.contain,
                    artboard: "maintenance",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text("underMaintenance".translate(context: context),
                      style: TextStyle(color: Theme.of(context).colorScheme.headingFontColor, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 20.0), textAlign: TextAlign.center),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text((message.isNotEmpty) ? message : "underMaintenanceSubTitle".translate(context: context),
                      style: TextStyle(color: Theme.of(context).colorScheme.headingFontColor, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 16.0), textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
