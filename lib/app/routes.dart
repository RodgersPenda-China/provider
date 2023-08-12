import 'package:edemand_partner/ui/screens/Withdrawal/withdrawal_requests.dart';
import 'package:edemand_partner/ui/screens/appUpdateScreen.dart';
import 'package:edemand_partner/ui/screens/auth/countryCodePickerScreen.dart';
import 'package:edemand_partner/ui/screens/auth/login_screen.dart';
import 'package:edemand_partner/ui/screens/auth/otpverification_screen.dart';
import 'package:edemand_partner/ui/screens/auth/registerProvider.dart';
import 'package:edemand_partner/ui/screens/auth/registrationSuccessfullScreen.dart';
import 'package:edemand_partner/ui/screens/auth/registration_form.dart';
import 'package:edemand_partner/ui/screens/auth/signUp.dart';
import 'package:edemand_partner/ui/screens/language.dart';
import 'package:edemand_partner/ui/screens/maintenanceModeScreen.dart';
import 'package:edemand_partner/ui/screens/promocode/add_promocode.dart';
import 'package:edemand_partner/ui/screens/promocode/promo_code.dart';
import 'package:edemand_partner/ui/screens/settings/about_us.dart';
import 'package:edemand_partner/ui/screens/settings/contact_us.dart';
import 'package:edemand_partner/ui/screens/settings/privacy_policy.dart';
import 'package:edemand_partner/ui/screens/settings/terms_and_conditions.dart';
import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/ui/widgets/imagePreview.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ui/screens/Withdrawal/send_withdrawal_requests.dart';
import '../ui/screens/booking_details.dart';
import '../ui/screens/categories.dart';
import '../ui/screens/main_activity.dart';
import '../ui/screens/services/create_service.dart';
import '../ui/screens/services/service_details.dart';
import '../ui/screens/splash_screen.dart';
import '../ui/screens/transactions/transactions.dart';

class Routes {
  static const String splash = 'splash';
  static const String main = 'mainActivity';
  static const String language = 'language';
  static const String registration = 'registration';
  static const String createService = 'CreateService';
  static const String promoCode = 'Promocode';
  static const String addPromoCode = 'AddPromocode';
  static const String withdrawalRequests = 'withdrawalRequests';
  static const String sendwithdrawalRequest = 'sendwithdrawalRequest';
  static const String transactions = 'Transactions';
  static const String categories = 'Categories';
  static const String serviceDetails = 'ServiceDetails';
  static const String bookingDetails = 'BookingDetails';
  static const String loginScreenRoute = 'loginRoute';
  static const String termsConditions = 'termsConditions';
  static const String pricacyPolicy = 'privacyPolicy';
  static const String aboutUs = 'aboutUs';
  static const String contactUs = 'contactUs';
  static const String otpVerificationRoute = "/login/OtpVerification";
  static const String maintenanceModeScreen = "/maintenanceModeScreen";
  static const String appUpdateScreen = "/appUpdateScreen";
  static const String imagePreviewScreen = "/imagePreviewScreen";
  static const String countryCodePickerRoute = "/countryCodePicker";
  static const String signUpScreen = "/signUpScreen";
  static const String providerRegistration = "/providerRegistration";
  static const String registrationSuccess = "/registrationSuccess";

  static String currentRoute = splash;

  static Route<dynamic> onGenerateRouted(RouteSettings routeSettings) {
    currentRoute = routeSettings.name ?? "";

    switch (routeSettings.name) {
      case splash:
        return CupertinoPageRoute(builder: ((context) => const SplashScreen()));

      case main:
        return MainActivity.route(routeSettings);

      case language:
        return Language.route(routeSettings);

      case registration:
        return RegistrationForm.route(routeSettings);

      case createService:
        return CreateService.route(routeSettings);

      case promoCode:
        return PromoCode.route(routeSettings);

      case addPromoCode:
        return AddPromoCode.route(routeSettings);

      case withdrawalRequests:
        return WithdrawalRequestsScreen.route(routeSettings);

      case sendwithdrawalRequest:
        return SendWithdrawalRequest.route(routeSettings);

      case transactions:
        return Transactions.route(routeSettings);

      case categories:
        return Categories.route(routeSettings);

      case serviceDetails:
        return ServiceDetails.route(routeSettings);

      case bookingDetails:
        return BookingDetails.route(routeSettings);

      case loginScreenRoute:
        return LoginScreen.route(routeSettings);

      case termsConditions:
        return TermsAndConditions.route(routeSettings);

      case pricacyPolicy:
        return PrivacyPolicy.route(routeSettings);

      case aboutUs:
        return AboutUs.route(routeSettings);

      case contactUs:
        return ContactUs.route(routeSettings);

      case maintenanceModeScreen:
        return MaintenanceModeScreen.route(routeSettings);

      case appUpdateScreen:
        return AppUpdateScreen.route(routeSettings);

      case imagePreviewScreen:
        return ImagePreview.route(routeSettings);

      case countryCodePickerRoute:
        return CountryCodePickerScreen.route(routeSettings);

      case otpVerificationRoute:
        return OtpVerificationScreen.route(routeSettings);

      case signUpScreen:
        return SignUpScreen.route(routeSettings);

      case providerRegistration:
        return ProviderRegistration.route(routeSettings);

      case registrationSuccess:
        return RegistrationSuccess.route(routeSettings);

      default:
        return CupertinoPageRoute(
            builder: ((context) => Scaffold(
                  body: CustomText(titleText: "pageNotFoundErrorMsg".translate(context: context)),
                )));
    }
  }
}
