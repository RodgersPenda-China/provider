import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/cubits/countryCodeCubit.dart';
import 'package:edemand_partner/data/cubits/fetch_system_settings_cubit.dart';
import 'package:edemand_partner/data/cubits/signIn_cubit.dart';
import 'package:edemand_partner/data/cubits/user_info_cubit.dart';
import 'package:edemand_partner/ui/widgets/customRoundButton.dart';
import 'package:edemand_partner/ui/widgets/customTextFormField.dart';
import 'package:edemand_partner/ui/widgets/error_container.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/hive_utils.dart';
import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repository/settings_repository.dart';
import '../../../utils/validation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static Route route(RouteSettings settings) {
    return CupertinoPageRoute(
      builder: (context) => const LoginScreen(),
    );
  }

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController(text: "1234567890");
  final TextEditingController _passwordController = TextEditingController(text: "12345678");
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<FetchSystemSettingsCubit>().getSettings(isAnonymous: true);
    super.initState();
  }

  void _onLoginButtonClick() async {
    FocusScope.of(context).unfocus();
    if (_loginFormKey.currentState!.validate()) {
      String countryCallingCode = context.read<CountryCodeCubit>().getSelectedCountryCode();
      //
      context.read<SignInCubit>().SignIn(
            phoneNumber: _phoneNumberController.text,
            password: _passwordController.text,
            countryCode: countryCallingCode,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        body: BlocConsumer<SignInCubit, SignInState>(
          listener: (context, state) async {
            if (state is SignInSuccess) {
              //
              if (state.error) {
                UiUtils.showMessage(context, state.message, MessageType.error);
                return;
              }
              // context.read<SignInCubit>().getProviderDetails();
              context.read<UserInfoCubit>().setUserInfo(state.providerDetails);
              //
              HiveUtils.setUserIsAuthenticated();
              //
              try {
                String? fcmToken = await FirebaseMessaging.instance.getToken();
                await SettingsRepository().updateFCM(fcmToken!);
              } catch (_) {}

              if (state.providerDetails.providerInformation?.isApproved == "1") {
                Future.delayed(
                  Duration.zero,
                  () {
                    Navigator.pushReplacementNamed(context, Routes.main);
                  },
                );
              } else {
                Future.delayed(
                  Duration.zero,
                  () {
                    Navigator.pushReplacementNamed(context, Routes.registration,
                        arguments: {"isEditing": false});
                  },
                );
              }
            }
            if (state is SignInFailure) {
              Future.delayed(
                Duration.zero,
                () {
                  UiUtils.showMessage(context, state.errorMessage, MessageType.error);
                },
              );
            }
          },
          builder: (context, state) {
            return Form(
              key: _loginFormKey,
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      UiUtils.setSVGImage("loginlogo",
                          width: 100.rw(context), height: 108.rh(context), boxFit: BoxFit.cover),
                      const SizedBox(
                        height: 40,
                      ),
                      Text(
                        "welcome-provider".translate(context: context),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.blackColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 28.rf(context)),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      CustomTextFormField(
                        controller: _phoneNumberController,
                        textInputType: TextInputType.phone,
                        isDense: false,
                        validator: (value) {
                          return Validator.validateNumber(value!);
                        },
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.blackColor,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        borderColor: Theme.of(context).colorScheme.accentColor,
                        isRoundedBorder: true,
                        backgroundColor: Colors.transparent,
                        hintText: "enterMobileNumber".translate(context: context),
                        hintTextColor: Theme.of(context).colorScheme.lightGreyColor,
                        prefix: Padding(
                          padding: const EdgeInsetsDirectional.only(start: 12.0),
                          child: BlocBuilder<CountryCodeCubit, CountryCodeState>(
                            builder: (context, state) {
                              String code = "--";

                              if (state is CountryCodeFetchSuccess) {
                                code = state.selectedCountry!.callingCode;
                              }

                              return IntrinsicHeight(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(context, Routes.countryCodePickerRoute)
                                            .then((value) {
                                          Future.delayed(const Duration(milliseconds: 250))
                                              .then((value) {
                                            context.read<CountryCodeCubit>().fillTemporaryList();
                                          });
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              if (state is CountryCodeFetchSuccess) {
                                                return SizedBox(
                                                  width: 35.rw(context),
                                                  height: 25.rh(context),
                                                  child: Image.asset(
                                                    state.selectedCountry!.flag,
                                                    package: countryCodePackageName,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              }
                                              if (state is CountryCodeFetchFail) {
                                                return ErrorContainer(errorMessage: state.error);
                                              }
                                              return const CircularProgressIndicator();
                                            },
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          UiUtils.setSVGImage(
                                            "sp_down",
                                            height: 5,
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    VerticalDivider(
                                      thickness: 1,
                                      indent: 6,
                                      endIndent: 6,
                                      color: Theme.of(context).colorScheme.lightGreyColor,
                                    ),
                                    Text(
                                      code,
                                      style: TextStyle(
                                          color: Theme.of(context).colorScheme.blackColor,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextFormField(
                        controller: _passwordController,
                        isDense: false,
                        borderColor: Theme.of(context).colorScheme.accentColor,
                        isRoundedBorder: true,
                        isPswd: true,
                        backgroundColor: Colors.transparent,
                        hintText: "enterYourPasswrd".translate(context: context),
                        hintTextColor: Theme.of(context).colorScheme.lightGreyColor,
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      buildLoginButton(context, showProgress: (state is SignInInProgress)),
                      const SizedBox(
                        height: 25,
                      ),
                      buildNewRegistrationContainer(),
                      const SizedBox(
                        height: 40,
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "byContinueYouAccept".translate(context: context),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.lightGreyColor,
                                      fontSize: 14),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(top: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context, Routes.pricacyPolicy);
                                        },
                                        child: Text(
                                          "privacyPolicyLbl".translate(context: context),
                                          style: TextStyle(
                                              color: Theme.of(context).colorScheme.blackColor,
                                              fontSize: 14,
                                              decoration: TextDecoration.underline),
                                        ),
                                      ),
                                      Text(
                                        " & ",
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.blackColor,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context, Routes.termsConditions);
                                        },
                                        child: Text(
                                          "termsConditionLbl".translate(context: context),
                                          style: TextStyle(
                                              color: Theme.of(context).colorScheme.blackColor,
                                              fontSize: 14,
                                              decoration: TextDecoration.underline),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ]),
                        ),
                      ),

                      // buildRegisterButton()
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildRegisterButton() {
    return // Not a Member? Register now
        RichText(
            text: TextSpan(children: [
      TextSpan(
          style: TextStyle(
              color: Theme.of(context).colorScheme.blackColor,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 16.0),
          text: "notaMember".translate(context: context)),
      TextSpan(
          style: TextStyle(
              color: Theme.of(context).colorScheme.blackColor,

              // color: Color(0xff343f53),
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontSize: 16.0),
          text: "resigsterNow".translate(context: context))
    ]));
  }

  Widget buildLoginButton(BuildContext context, {bool? showProgress}) {
    return CustomRoundedButton(
      onTap: _onLoginButtonClick,
      buttonTitle: "login".translate(context: context),
      widthPercentage: 1,
      backgroundColor: Theme.of(context).colorScheme.headingFontColor,
      showBorder: false,
      child: (showProgress ?? false)
          ? CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondaryColor,
            )
          : null,
    );
  }

  buildNewRegistrationContainer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${"notMember".translate(context: context)} ",
          style: TextStyle(
              color: Theme.of(context).colorScheme.headingFontColor,
              fontWeight: FontWeight.w400,
              fontFamily: "PlusJakartaSans",
              fontStyle: FontStyle.normal,
              fontSize: 16.0),
        ),
        InkWell(
          child: Text(
            "registerNow".translate(context: context),
            style: TextStyle(
                color: Theme.of(context).colorScheme.headingFontColor,
                fontWeight: FontWeight.w700,
                fontFamily: "PlusJakartaSans",
                fontStyle: FontStyle.normal,
                fontSize: 16.0),
          ),
          onTap: () {
            Navigator.pushNamed(context, Routes.signUpScreen);
          },
        ),
      ],
    );
  }
}
