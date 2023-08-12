import 'package:edemand_partner/data/cubits/changePasswordCubit.dart';
import 'package:edemand_partner/ui/widgets/customRoundButton.dart';
import 'package:edemand_partner/ui/widgets/customTextFormField.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:edemand_partner/utils/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordBottomSheet extends StatefulWidget {
  const ChangePasswordBottomSheet({Key? key}) : super(key: key);

  @override
  State<ChangePasswordBottomSheet> createState() => _ChangePasswordBottomSheetState();
}

class _ChangePasswordBottomSheetState extends State<ChangePasswordBottomSheet> {
  //
  final formKey = GlobalKey<FormState>();

  //
  final TextEditingController _oldPasswordTextController = TextEditingController();
  final TextEditingController _newPasswordTextController = TextEditingController();
  final TextEditingController _confirmNewPasswordTextController = TextEditingController();

  //
  Widget _getSelectLanguageHeading() {
    return Text("changePassword".translate(context: context),
        style: TextStyle(
          color: Theme.of(context).colorScheme.headingFontColor,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 20.0,
        ),
        textAlign: TextAlign.start);
  }

  //
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
      listener: (context, state) async {
        if (state is ChangePasswordSuccess) {
          //
          _oldPasswordTextController.clear();
          _newPasswordTextController.clear();
          _confirmNewPasswordTextController.clear();
          //
          UiUtils.showMessage(context, state.errorMessage, MessageType.success);
          //
          await Future.delayed(const Duration(seconds: 1));
          if (mounted) {
            Navigator.pop(context);
          }
          //
        } else if (state is ChangePasswordFailure) {
          UiUtils.showMessage(context, state.errorMessage, MessageType.error);
        }
      },
      builder: (context, state) {
        Widget? child;
        if (state is ChangePasswordInProgress) {
          child = CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primaryColor,
          );
        }
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(15.0),
                child: _getSelectLanguageHeading(),
              ),
              Divider(color: Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.4)),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: CustomTextFormField(
                                  controller: _oldPasswordTextController,
                                  isPswd: true,
                                  labelText: "oldPassword".translate(context: context),
                                  validator: (value) => Validator.nullCheck(value),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: CustomTextFormField(
                                  controller: _newPasswordTextController,
                                  isPswd: true,
                                  labelText: "newPassword".translate(context: context),
                                  validator: (value) => Validator.nullCheck(value),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                child: CustomTextFormField(
                                  controller: _confirmNewPasswordTextController,
                                  isPswd: true,
                                  labelText: "confirmPasswordLbl".translate(context: context),
                                  validator: (value) => Validator.nullCheck(value),
                                ),
                              ),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
                        child: CustomRoundedButton(
                          widthPercentage: 1,
                          backgroundColor: Theme.of(context).colorScheme.headingFontColor,
                          buttonTitle: "changePassword".translate(context: context),
                          showBorder: false,
                          child: child,
                          onTap: () {
                            UiUtils.removeFocus();
                            var form = formKey.currentState; //default value
                            if (form == null) return;
                            form.save();
                            if (form.validate()) {
                              String newPassword =
                                  _newPasswordTextController.text.trim().toString();
                              String confirmNewPassword =
                                  _confirmNewPasswordTextController.text.trim().toString();
                              String oldPassword =
                                  _oldPasswordTextController.text.trim().toString();

                              bool isNewAndConfirmPasswordAreSame =
                                  newPassword == confirmNewPassword;
                              if (isNewAndConfirmPasswordAreSame) {
                                if (Constant.isDemoModeEnable) {
                                  UiUtils.showDemoModeWarning(context: context);
                                  return;
                                }
                                context.read<ChangePasswordCubit>().changePassword(
                                    oldPassword: oldPassword, newPassword: newPassword);
                              } else {
                                UiUtils.showMessage(
                                    context,
                                    "passwordDoesNotMatch".translate(context: context),
                                    MessageType.warning);
                              }
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
