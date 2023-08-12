// ignore_for_file: depend_on_referenced_packages

import 'package:edemand_partner/data/cubits/PromocodeCubit/fetch_promocodes_cubit.dart';
import 'package:edemand_partner/data/cubits/changePasswordCubit.dart';
import 'package:edemand_partner/data/cubits/countryCodeCubit.dart';
import 'package:edemand_partner/data/cubits/delete_account_cubit.dart';
import 'package:edemand_partner/data/cubits/delete_service_cubit.dart';
import 'package:edemand_partner/data/cubits/fetchServiceReviewsCubit.dart';
import 'package:edemand_partner/data/cubits/fetchTaxesCubit.dart';
import 'package:edemand_partner/data/cubits/fetch_statistics_cubit.dart';
import 'package:edemand_partner/data/cubits/resend_otp_cubit.dart';
import 'package:edemand_partner/data/cubits/signIn_cubit.dart';
import 'package:edemand_partner/data/cubits/time_slots_cubit.dart';
import 'package:edemand_partner/data/cubits/verify_otp_cubit.dart';
import 'package:edemand_partner/data/cubits/verify_phone_number_from_api_cubit.dart';
import 'package:edemand_partner/data/cubits/verify_phonenumber_cubit.dart';
import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';

import '../data/cubits/PromocodeCubit/create_promocode_cubit.dart';
import '../data/cubits/appThemeCubit.dart';
import '../data/cubits/auth_cubit.dart';
import '../data/cubits/fetchReviewsCubit.dart';
import '../data/cubits/fetchServiceCategoryCubit.dart';
import '../data/cubits/fetch_bookings_cubit.dart';
import '../data/cubits/fetch_services_Cubit.dart';
import '../data/cubits/fetch_system_settings_cubit.dart';
import '../data/cubits/languageCubit.dart';
import '../data/cubits/updateBookingStatusCubit.dart';
import '../data/cubits/user_info_cubit.dart';
// import '../firebase_options.dart';
import '../utils/Notification/notificationService.dart';
import '../utils/constant.dart';
import '../utils/hive_keys.dart';
import '../utils/uiUtils.dart';
import 'appLocalization.dart';
import 'appTheme.dart';
import 'routes.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  //locked in portrait mode only
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  //
  FirebaseMessaging.onBackgroundMessage(NotificationService.onBackgroundMessageHandler);

  if (Firebase.apps.isNotEmpty) {
    await Firebase.initializeApp(
    );
  } else {
    await Firebase.initializeApp();
  }

  await Hive.initFlutter();
  await Hive.openBox(HiveKeys.userDetailsBox);
  await Hive.openBox(HiveKeys.authBox);
  await Hive.openBox(HiveKeys.languageBox);
  await Hive.openBox(HiveKeys.themeBox);
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthenticationCubit(),
        ),
        BlocProvider(
          create: (context) => SignInCubit(),
        ),
        BlocProvider(
          create: (context) => UserInfoCubit(),
        ),
        BlocProvider(
          create: (context) => AppThemeCubit(),
        ),
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider(
          create: (context) => FetchBookingsCubit(),
        ),
        BlocProvider(
          create: (context) => FetchServicesCubit(),
        ),
        BlocProvider(
          create: (context) => FetchServiceReviewsCubit(),
        ),
        BlocProvider(
          create: (context) => FetchServiceCategoryCubit(),
        ),
        BlocProvider(
          create: (context) => CreatePromocodeCubit(),
        ),
        BlocProvider(
          create: (context) => UpdateBookingStatusCubit(),
        ),
        BlocProvider(
          create: (context) => FetchReviewsCubit(),
        ),
        BlocProvider(
          create: (context) => DeleteServiceCubit(),
        ),
        BlocProvider(
          create: (context) => TimeSlotCubit(),
        ),
        BlocProvider(
          create: (context) => FetchPromocodesCubit(),
        ),
        BlocProvider(
          create: (context) => FetchStatisticsCubit(),
        ),
        BlocProvider(
          create: (context) => FetchSystemSettingsCubit(),
        ),
        BlocProvider(
          create: (context) => DeleteAccountCubit(),
        ),
        BlocProvider(
          create: (context) => CountryCodeCubit(),
        ),
        BlocProvider(
          create: (context) => AuthenticationCubit(),
        ),
        BlocProvider(
          create: (context) => VerifyPhoneNumberCubit(),
        ),
        BlocProvider(
          create: (context) => VerifyOtpCubit(),
        ),
        BlocProvider(
          create: (context) => CountryCodeCubit(),
        ),
        BlocProvider(
          create: (context) => ResendOtpCubit(),
        ),
        BlocProvider(
          create: (context) => ChangePasswordCubit(),
        ),
        BlocProvider(
          create: (context) => FetchTaxesCubit(),
        ),
        BlocProvider(
          create: (context) =>
              VerifyPhoneNumberFromAPICubit(authenticationRepository: AuthRepository()),
        ),
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    context.read<LanguageCubit>().loadCurrentLanguage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = context.watch<AppThemeCubit>().state.appTheme;

    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) {
        return MaterialApp(
          title: Constant.appName,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: Routes.onGenerateRouted,
          initialRoute: Routes.splash,
          theme: appThemeData[currentTheme],
          builder: (context, widget) {
            return ScrollConfiguration(behavior: GlobalScrollBehavior(), child: widget!);
          },
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: appLanguages.map((language) {
            return UiUtils.getLocaleFromLanguageCode(language.languageCode);
          }).toList(),
          locale: (languageState is LanguageLoader)
              ? Locale(languageState.languageCode)
              : Locale(Constant.defaultLanguageCode),
        );
      },
    );
  }
}

///To remove scroll-glow from the ListView/GridView etc..
class CustomScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

///To apply BouncingScrollPhysics() to every scrollable widget
class GlobalScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics();
  }
}
