import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/ui/widgets/customRoundButton.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RegistrationSuccess extends StatelessWidget {
  final String title;
  final String message;

  const RegistrationSuccess({
    Key? key,
    required this.message,
    required this.title,
  }) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    Map<String, dynamic> arguments = routeSettings.arguments as Map<String, dynamic>;
    return CupertinoPageRoute(builder: (_) {
      return RegistrationSuccess(
        title: arguments['title'],
        message: arguments['message'],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.4),
                child: UiUtils.setSVGImage(
                  "registration",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(title.translate(context: context),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.headingFontColor,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                      fontSize: 30.0),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 10,
              ),
              Text(message.translate(context: context),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.headingFontColor,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.normal,
                      fontSize: 16.0),
                  textAlign: TextAlign.center),
              const SizedBox(
                height: 25,
              ),
              CustomRoundedButton(
                widthPercentage: 1,
                backgroundColor: Theme.of(context).colorScheme.headingFontColor,
                buttonTitle: "goToLogIn".translate(context: context),
                showBorder: false,
                onTap: () async {
                  //
                  Navigator.pushNamedAndRemoveUntil(
                      context, Routes.loginScreenRoute, (Route<dynamic> route) => false);
                },
              )
            ]),
      ),
    );
  }
}
