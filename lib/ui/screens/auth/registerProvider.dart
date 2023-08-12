// import 'package:edemand_partner/ui/widgets/DashedStadiumBorder.dart';
// import 'package:path_drawing/path_drawing.dart';
import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/cubits/registerProviderCubit.dart';
import 'package:edemand_partner/ui/widgets/customRoundButton.dart';
import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/uiUtils.dart';

class ProviderRegistration extends StatefulWidget {
  final String mobileNumber;
  final String phoneNumberWithOutCountryCode;
  final String countryCode;

  const ProviderRegistration(
      {Key? key,
      required this.mobileNumber,
      required this.countryCode,
      required this.phoneNumberWithOutCountryCode})
      : super(key: key);

  @override
  ProviderRegistrationState createState() => ProviderRegistrationState();

  static Route<ProviderRegistration> route(RouteSettings routeSettings) {
    Map<String, String> parameter = routeSettings.arguments as Map<String, String>;

    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => RegisterProviderCubit(),
        child: ProviderRegistration(
          mobileNumber: parameter['registeredMobileNumber'].toString(),
          countryCode: parameter['countryCode'].toString(),
          phoneNumberWithOutCountryCode: parameter['phoneNumberWithOutCountryCode'].toString(),
        ),
      ),
    );
  }
}

class ProviderRegistrationState extends State<ProviderRegistration> {
  final formKey1 = GlobalKey<FormState>();

  ScrollController scrollController = ScrollController();

  ///form1
  TextEditingController userNmController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobNoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController companyNmController = TextEditingController();

  FocusNode userNmFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode mobNoFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  FocusNode companyNameFocus = FocusNode();

  @override
  void initState() {
    mobNoController.text = widget.mobileNumber;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        title: CustomText(
            titleText: "regFormTitle".translate(context: context),
            fontColor: Theme.of(context).colorScheme.headingFontColor),
        leading: UiUtils.setBackArrow(context),
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            clipBehavior: Clip.none,
            child: Form(
                key: formKey1,
                child: Column(
                  children: [
                    UiUtils.setTitleAndTFF(
                      context,
                      titleText: "compNmLbl".translate(context: context),
                      controller: companyNmController,
                      currNode: companyNameFocus,
                      validator: (companyName) => Validator.nullCheck(companyName),
                    ),
                    UiUtils.setTitleAndTFF(
                      context,
                      titleText: "userNmLbl".translate(context: context),
                      controller: userNmController,
                      currNode: userNmFocus,
                      nextFocus: emailFocus,
                      validator: (username) => Validator.nullCheck(username),
                    ),
                    UiUtils.setTitleAndTFF(
                      context,
                      titleText: "emailLbl".translate(context: context),
                      controller: emailController,
                      currNode: emailFocus,
                      nextFocus: mobNoFocus,
                      textInputType: TextInputType.emailAddress,
                      validator: (email) => Validator.validateEmail(email),
                    ),
                    UiUtils.setTitleAndTFF(context,
                        titleText: "mobNoLbl".translate(context: context),
                        controller: mobNoController,
                        currNode: mobNoFocus,
                        nextFocus: passwordFocus,
                        textInputType: TextInputType.phone,
                        isReadOnly: true),
                    UiUtils.setTitleAndTFF(
                      context,
                      titleText: "passwordLbl".translate(context: context),
                      controller: passwordController,
                      currNode: passwordFocus,
                      nextFocus: confirmPasswordFocus,
                      isPswd: true,
                      validator: (password) {
                        return Validator.nullCheck(password);
                      },
                    ),
                    UiUtils.setTitleAndTFF(
                      context,
                      titleText: "confirmPasswordLbl".translate(context: context),
                      controller: confirmPasswordController,
                      currNode: confirmPasswordFocus,
                      nextFocus: companyNameFocus,
                      isPswd: true,
                      validator: (confirmPassword) => Validator.nullCheck(confirmPassword),
                    ),
                    SizedBox(
                      height: 55,
                    )
                  ],
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                right: 15,
                left: 15,
              ),
              child: BlocConsumer<RegisterProviderCubit, RegisterProviderState>(
                listener: (context, state) {
                  if (state is RegisterProviderSuccess) {
                    Navigator.pushReplacementNamed(context, Routes.registrationSuccess, arguments: {
                      "title": "registration",
                      "message": "doLoginAndCompleteKYC",
                    });
                  } else if (state is RegisterProviderFailure) {
                    UiUtils.showMessage(
                        context, state.errorMessage.translate(context: context), MessageType.error);
                  }
                },
                builder: (context, state) {
                  Widget? child;
                  if (state is RegisterProviderInProgress) {
                    child = CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primaryColor,
                    );
                  } else if (state is RegisterProviderSuccess || state is RegisterProviderFailure) {
                    child = null;
                  }
                  return CustomRoundedButton(
                    showBorder: false,
                    buttonTitle: "submitBtnLbl".translate(context: context),
                    widthPercentage: 1,
                    backgroundColor: Theme.of(context).colorScheme.headingFontColor,
                    titleColor: Theme.of(context).colorScheme.secondaryColor,
                    child: child,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      formKey1.currentState?.save();

                      if (formKey1.currentState!.validate()) {
                        if (passwordController.text.trim().toString() !=
                            confirmPasswordController.text.trim().toString()) {
                          UiUtils.showMessage(
                              context,
                              "confirmPasswordDoesNotMatch".translate(context: context),
                              MessageType.error);
                          return;
                        }

                        Map<String, dynamic> parameter = {
                          "company_name": companyNmController.text.trim().toString(),
                          "username": userNmController.text.trim().toString(),
                          "password": passwordController.text.trim().toString(),
                          "password_confirm": passwordController.text.trim().toString(),
                          "email": emailController.text.trim().toString(),
                          "mobile": widget.phoneNumberWithOutCountryCode.toString(),
                          "country_code": widget.countryCode,
                        };
                        context
                            .read<RegisterProviderCubit>()
                            .registerProvider(parameter: parameter);
                      }
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
