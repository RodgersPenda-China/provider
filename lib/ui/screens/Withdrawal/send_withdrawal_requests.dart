import 'package:edemand_partner/data/cubits/fetch_system_settings_cubit.dart';
import 'package:edemand_partner/data/cubits/sendWithdrawalRequestCubit.dart';
import 'package:edemand_partner/ui/widgets/customRoundButton.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:edemand_partner/utils/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendWithdrawalRequest extends StatefulWidget {
  const SendWithdrawalRequest({Key? key}) : super(key: key);

  @override
  SendWithdrawalRequestScreenState createState() => SendWithdrawalRequestScreenState();

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => SendWithdrawalRequestCubit(),
        child: const SendWithdrawalRequest(),
      ),
    );
  }
}

class SendWithdrawalRequestScreenState extends State<SendWithdrawalRequest> {
  final formKey = GlobalKey<FormState>();

  TextEditingController bankDetailsController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  FocusNode bankDetailsFocus = FocusNode();
  FocusNode amountFocus = FocusNode();
  bool? isRquestAdded;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, isRquestAdded);
        return false;
      },
      child: withdrawAmountForm(),
    );
  }

  Widget withdrawAmountForm() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryColor,
          borderRadius: BorderRadiusDirectional.only(topEnd: Radius.circular(UiUtils.bottomSheetTopRadius), topStart: Radius.circular(UiUtils.bottomSheetTopRadius))),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 0, top: 10, end: 15, start: 15),
              child: Text(
                "sendWithdrawalRequest".translate(context: context),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.headingFontColor,
                  fontSize: 18,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 15, top: 0, end: 15, start: 15),
              child: Column(
                children: [
                  //account details field
                  UiUtils.setTitleAndTFF(
                    context,
                    titleText: "bankDetailsHint".translate(context: context),
                    controller: bankDetailsController,
                    currNode: bankDetailsFocus,
                    backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                    nextFocus: amountFocus,
                    validator: (val) => Validator.nullCheck(val),
                    textInputType: TextInputType.multiline,
                    expands: true,
                    minLines: 4,
                  ),
                  //withdraw amount field
                  UiUtils.setTitleAndTFF(context,
                      titleText: "amountLbl".translate(context: context),
                      controller: amountController,
                      currNode: amountFocus,
                      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))], validator: (val) {
                    if (val != "") {
                      if (double.parse(val!) > double.parse((context.read<FetchSystemSettingsCubit>().state as FetchSystemSettingsSuccess).availableAmount)) {
                        return "bigAmount".translate(context: context);
                      }
                    }

                    return Validator.nullCheck(val);
                  }, textInputType: TextInputType.number),
                  //

                  resetAndSubmitButton()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  resetAndSubmitButton() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Expanded(child: resetBtn()),
          const SizedBox(width: 5),
          Expanded(child: submitBtn()),
        ]),
      ),
    );
  }

  submitBtn() {
    return BlocConsumer<SendWithdrawalRequestCubit, SendWithdrawalRequestState>(
      listener: (context, state) {
        if (state is SendWithdrawalRequestSuccess) {
          //update amount globally
          context.read<FetchSystemSettingsCubit>().updateAmount(state.balance);

          UiUtils.showMessage(context, "success".translate(context: context), MessageType.success, onMessageClosed: () {});

          // little bit delay because bottom sheet is closing very fast
          Future.delayed(const Duration(milliseconds: 500)).then((value) => Navigator.pop(context, true));
        }

        if (state is SendWithdrawalRequestFailure) {
          UiUtils.showMessage(context, "failed".translate(context: context), MessageType.error);
        }
      },
      builder: (context, state) {
        Widget? child;

        if (state is SendWithdrawalRequestInProgress) {
          child = CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primaryColor,
          );
        }

        return CustomRoundedButton(
          widthPercentage: 1,
          buttonTitle: "submitBtnLbl".translate(context: context),
          backgroundColor: Theme.of(context).colorScheme.headingFontColor,
          showBorder: true,
          child: child,
          onTap: () {
            UiUtils.removeFocus();
            onSubmitClick();
          },
        );
      },
    );
  }

  resetBtn() {
    return CustomRoundedButton(
      widthPercentage: 1,
      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
      buttonTitle: "resetBtnLbl".translate(context: context),
      titleColor: Theme.of(context).colorScheme.blackColor,
      showBorder: true,
      borderColor: Theme.of(context).colorScheme.headingFontColor,
      onTap: () {
        bankDetailsController.text = '';
        amountController.text = '';

        FocusScope.of(context).requestFocus(bankDetailsFocus);
        setState(() {});
      },
    );
  }

  onSubmitClick() async {
    var form = formKey.currentState; //default value
    if (form == null) return;
    form.save();
    if (form.validate()) {
      context.read<SendWithdrawalRequestCubit>().sendWithdrawalRequest(amount: amountController.text, paymentAddress: bankDetailsController.text);
    }
  }
}
