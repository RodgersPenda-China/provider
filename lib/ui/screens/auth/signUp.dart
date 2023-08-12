// ignore_for_file: file_names, use_build_context_synchronously
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/cubits/countryCodeCubit.dart';
import 'package:edemand_partner/data/cubits/verify_phone_number_from_api_cubit.dart';
import 'package:edemand_partner/data/cubits/verify_phonenumber_cubit.dart';
import 'package:edemand_partner/ui/widgets/customRoundButton.dart';
import 'package:edemand_partner/ui/widgets/error_container.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) {
      return const SignUpScreen();
    });
  }
}

class _SignUpScreenState extends State<SignUpScreen> {
  String phoneNumberWithCountryCode = "";
  String onlyPhoneNumber = "";
  String countryCode = "";

  final GlobalKey<FormState> verifyPhoneNumberFormKey = GlobalKey<FormState>();
  final TextEditingController _numberFieldController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _numberFieldController.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  _onContinueButtonClicked() {
    UiUtils.removeFocus();

    bool isvalidNumber = verifyPhoneNumberFormKey.currentState!.validate();

    if (isvalidNumber) {
      //
      String countryCallingCode = context.read<CountryCodeCubit>().getSelectedCountryCode();
      //
      phoneNumberWithCountryCode = countryCallingCode + _numberFieldController.text;
      onlyPhoneNumber = _numberFieldController.text;
      countryCode = countryCallingCode;
      /*context.read<VerifyPhoneNumberCubit>().verifyPhoneNumber(phoneNumberWithCountryCode, onCodeSent: () {
        "codeHasBeenSentToYourMobileNumber".translate(context: context);
      });*/
      context
          .read<VerifyPhoneNumberFromAPICubit>()
          .verifyPhoneNumberFromAPI(mobileNumber: onlyPhoneNumber);
    }
  }

  Padding _buildPhoneNumberFiled() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 10.0, bottom: 25),
      child: TextFormField(
          controller: _numberFieldController,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
          keyboardType: TextInputType.phone,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            contentPadding: const EdgeInsetsDirectional.only(bottom: 2, start: 15),
            filled: true,
            fillColor: Theme.of(context).colorScheme.primaryColor,
            hintStyle: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.lightGreyColor),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor),
                borderRadius: const BorderRadius.all(Radius.circular(12))),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(12))),
            errorStyle: const TextStyle(fontSize: 12),
            hintText: "hintMobileNumber".translate(context: context),
            prefixIcon: Padding(
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
                              Future.delayed(const Duration(milliseconds: 250)).then((value) {
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
                                      width: 35,
                                      height: 25,
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
                              UiUtils.setSVGImage("sp_down",
                                  height: 5,
                                  width: 5,
                                  imgColor: Theme.of(context).colorScheme.headingFontColor),
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
          validator: (String? number) {
            if (number != null) {
              if (number.isEmpty) {
                return "Field must not be empty";
              } else if (number.length < 6 || number.length > 15) {
                return "Mobile number should be between 6 and 15 numbers";
              }
            }
            return null;
          }),
    );
  }

  Widget _buildSubHeading() {
    return Align(
        alignment: Alignment.centerLeft,
        child: Text("enterMobileNumberToGetOTP".translate(context: context),
            style: TextStyle(
                color: Theme.of(context).colorScheme.headingFontColor,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.normal,
                fontSize: 14.0),
            textAlign: TextAlign.left));
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          elevation: 0,
          leading: UiUtils.setBackArrow(context),
        ),
        body: Form(
          key: verifyPhoneNumberFormKey,
          child: Padding(
            padding: const EdgeInsetsDirectional.all(28.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    UiUtils.setSVGImage("loginlogo", width: 100, height: 108, boxFit: BoxFit.cover),
                    const SizedBox(
                      height: 70,
                    ),
                    _buildSubHeading(),
                    _buildPhoneNumberFiled(),
                    const SizedBox(),
                    _buildContinueButton(),
                    const SizedBox(
                      height: 40,
                    ),
                    Expanded(child: _buildPrivacyPolicyAndTnCContainer()),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return BlocConsumer<VerifyPhoneNumberFromAPICubit, VerifyPhoneNumberFromAPIState>(
      listener: (context, state) async {
        if (state is VerifyPhoneNumberFromAPIFailure) {
          UiUtils.showMessage(
              context, state.errorMessage.translate(context: context), MessageType.error);
        }
        if (state is VerifyPhoneNumberFromAPISuccess) {
          if (state.error) {
            UiUtils.showMessage(
                context, "mobileAlreadyRegistered".translate(context: context), MessageType.error);
          } else {
            context.read<VerifyPhoneNumberCubit>().verifyPhoneNumber(phoneNumberWithCountryCode,
                onCodeSent: () {
              "codeHasBeenSentToYourMobileNumber".translate(context: context);
            });
          }
        }
        //
      },
      builder: (context, state) {
        Widget? child;
        if (state is VerifyPhoneNumberFromAPIInProgress) {
          child = CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondaryColor,
          );
        } else if (state is SendVerificationCodeInProgress) {
          child = null;
        }

        return BlocConsumer<VerifyPhoneNumberCubit, VerifyPhoneNumberState>(
          listener: (context, verifyPhoneNumberState) {
            if (verifyPhoneNumberState is SendVerificationCodeInProgress) {
              context.read<VerifyPhoneNumberCubit>().setInitialState();

              //
              Navigator.pushNamed(context, Routes.otpVerificationRoute, arguments: {
                "phoneNumberWithCountryCode": phoneNumberWithCountryCode,
                "phoneNumberWithOutCountryCode": onlyPhoneNumber,
                "countryCode": context.read<CountryCodeCubit>().getSelectedCountryCode()
              });
            } else if (verifyPhoneNumberState is PhoneNumberVerificationFailure) {
              var errorMessage = "";

              errorMessage =
                  verifyPhoneNumberState.error.code.toString().getFirebaseError(context: context);
              UiUtils.showMessage(context, errorMessage, MessageType.error);
            } else if (verifyPhoneNumberState is PhoneNumberVerificationSuccess) {
              // Navigator.pushNamed(context, Routes.otpVerificationRoute, arguments: {"phoneNumberWithCountryCode": phoneNumberWithCountryCode});
            }
          },
          builder: (context, verifyPhoneNumberState) {
            if (verifyPhoneNumberState is PhoneNumberVerificationInProgress) {
              child = CircularProgressIndicator(
                color: Theme.of(context).colorScheme.secondaryColor,
              );
            }
            if ((verifyPhoneNumberState is SendVerificationCodeInProgress ||
                    verifyPhoneNumberState is PhoneNumberVerificationFailure ||
                    verifyPhoneNumberState is VerifyPhoneNumberInitial) &&
                state is! VerifyPhoneNumberFromAPIInProgress) {
              child = null;
            }
            return CustomRoundedButton(
              height: 50,
              onTap: () async {
                if (verifyPhoneNumberState is PhoneNumberVerificationInProgress) {
                  return;
                }
                _onContinueButtonClicked();
              },
              buttonTitle: "continue".translate(context: context),
              widthPercentage: 0.9,
              backgroundColor: Theme.of(context).colorScheme.headingFontColor,
              showBorder: false,
              child: child,
            );
          },
        );
      },
    );
  }

  _buildPrivacyPolicyAndTnCContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "byContinueYouAccept".translate(context: context),
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.lightGreyColor, fontSize: 14),
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
    );
  }
}
