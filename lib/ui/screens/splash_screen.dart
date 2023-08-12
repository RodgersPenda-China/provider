// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/cubits/auth_cubit.dart';
import 'package:edemand_partner/data/cubits/countryCodeCubit.dart';
import 'package:edemand_partner/data/cubits/fetch_system_settings_cubit.dart';
import 'package:edemand_partner/data/cubits/user_info_cubit.dart';
import 'package:edemand_partner/data/model/systemSettingModel.dart';
import 'package:edemand_partner/ui/widgets/error_container.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/hive_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      //
      try {
        context.read<UserInfoCubit>().setUserInfo(HiveUtils.getProviderDetails());
        //
        context.read<FetchSystemSettingsCubit>().getSettings(isAnonymous: true);
        //
        context.read<CountryCodeCubit>().loadAllCountryCode(context);
        //
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Theme.of(context).colorScheme.accentColor,
          systemNavigationBarColor: Theme.of(context).colorScheme.accentColor,
        ));
      } catch (_) {}
    });
  }

  void checkIsUserAuthenticated({required bool isNeedToShowAppUpdate}) {
    Future.delayed(const Duration(seconds: 2)).then((value) {
      //
      AuthenticationState authenticationState = context.read<AuthenticationCubit>().state;

      if (authenticationState == AuthenticationState.authenticated) {
        if (context.read<UserInfoCubit>().providerDetails.providerInformation?.isApproved == "1") {
          Navigator.of(context).pushReplacementNamed(Routes.main);
        } else if (context.read<UserInfoCubit>().providerDetails.providerInformation?.isApproved ==
            "2") {
          Navigator.pushReplacementNamed(context, Routes.registration,
              arguments: {"isEditing": false});
        } else {
          Navigator.of(context).pushReplacementNamed(Routes.loginScreenRoute);
        }
      } else if (authenticationState == AuthenticationState.unAuthenticated) {
        Navigator.of(context).pushReplacementNamed(Routes.loginScreenRoute);
      } else if (authenticationState == AuthenticationState.firstTime) {}

      if (isNeedToShowAppUpdate) {
        //if need to show app update screen then
        // we will push update screen, with not now button option
        Navigator.pushNamed(context, Routes.appUpdateScreen, arguments: {"isForceUpdate": false});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.accentColor,
        body: BlocConsumer<FetchSystemSettingsCubit, FetchSystemSettingsState>(
          listener: (context, state) async {
            if (state is FetchSystemSettingsSuccess) {
              GeneralSettings generalSettings = state.generalSettings;
              //
              // assign currency values
              Constant.systemCurrency = generalSettings.currency;
              Constant.systemCurrencyCountryCode = generalSettings.countryCurrencyCode;
              Constant.decimalPointsForPrice = generalSettings.decimalPoint;

              //
              // if maintenance mode is enable then we will redirect maintenance mode screen
              if (generalSettings.providerAppMaintenanceMode == "1") {
                Navigator.pushReplacementNamed(context, Routes.maintenanceModeScreen,
                    arguments: generalSettings.messageForProviderApplication);
                return;
              }

              // here we will check current version and updated version from panel
              // if application current version is less than updated version then
              // we will show app update screen
              checkIsUserAuthenticated(isNeedToShowAppUpdate: false);
              String? latestAndroidVersion = generalSettings.providerCurrentVersionAndroidApp;
              String? latestIOSVersion = generalSettings.providerCurrentVersionIosApp;

              // PackageInfo packageInfo = await PackageInfo.fromPlatform();
              //
              // String currentApplicationVersion = packageInfo.version;
              //
              // final Version currentVersion = Version.parse(currentApplicationVersion);
              // final Version latestVersionAndroid = Version.parse(latestAndroidVersion ?? "1.0.0");
              // final Version latestVersionIos = Version.parse(latestIOSVersion ?? "1.0.0");
              //
              // if (((Platform.isAndroid && latestVersionAndroid > currentVersion) ||
              //     (Platform.isIOS && latestVersionIos > currentVersion))) {
              //   // If it is force update then we will show app update with only Update button
              //   if (generalSettings.providerCompulsaryUpdateForceUpdate == "1") {
              //     Navigator.pushReplacementNamed(context, Routes.appUpdateScreen,
              //         arguments: {"isForceUpdate": true});
              //     return;
              //   } else {
              //     // If it is normal update then
              //     // we will pass true here for isNeedToShowAppUpdate
              //     checkIsUserAuthenticated(isNeedToShowAppUpdate: true);
              //   }
              // } else {
              //   //if no update available then we will pass false here for isNeedToShowAppUpdate
              //   checkIsUserAuthenticated(isNeedToShowAppUpdate: false);
              // }
            }
          },
          builder: (context, state) {
            if (state is FetchSystemSettingsFailure) {
              return ErrorContainer(
                errorMessage: state.errorMessage,
                onTapRetry: () {
                  context.read<FetchSystemSettingsCubit>().getSettings(isAnonymous: true);
                },
              );
            }
            return Stack(
              children: [
                Container(
                  color: Theme.of(context).colorScheme.accentColor,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                      child: SvgPicture.asset(
                    "${Constant.svgPath}splashlogo.svg",
                    fit: BoxFit.contain,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SvgPicture.asset(
                        "${Constant.svgPath}wrteam_logo.svg",
                        fit: BoxFit.contain,
                      )),
                ),
              ],
            );
          },
        ));
  }
}
