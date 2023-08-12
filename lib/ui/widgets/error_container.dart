import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/material.dart';

import '../../utils/uiUtils.dart';
import 'customRoundButton.dart';

class ErrorContainer extends StatelessWidget {
  final String errorMessage;
  final bool? showRetryButton;
  final bool? showErrorImage;
  final Color? errorMessageColor;
  final double? errorMessageFontSize;
  final Function? onTapRetry;
  final Color? retryButtonBackgroundColor;
  final Color? retryButtonTextColor;

  const ErrorContainer(
      {Key? key,
      required this.errorMessage,
      this.errorMessageColor,
      this.errorMessageFontSize,
      this.onTapRetry,
      this.showErrorImage,
      this.retryButtonBackgroundColor,
      this.retryButtonTextColor,
      this.showRetryButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.025),
        ),
        errorMessage == "noInternetFound".translate(context: context)
            ? SizedBox(
                height: MediaQuery.of(context).size.height * (0.35),
                child: UiUtils.setSVGImage("noInternet"),
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * (0.35),
                child: UiUtils.setSVGImage("somethingWentWrong"),
              ),
        SizedBox(
          height: MediaQuery.of(context).size.height * (0.025),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            errorMessage.translate(context: context),
            textAlign: TextAlign.center,
            style: TextStyle(color: errorMessageColor ?? Theme.of(context).colorScheme.secondary, fontSize: errorMessageFontSize ?? 16),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        (showRetryButton ?? true)
            ? CustomRoundedButton(
                height: 40,
                widthPercentage: 0.3,
                backgroundColor: retryButtonBackgroundColor ?? Theme.of(context).colorScheme.primary,
                onTap: () {
                  onTapRetry?.call();
                },
                titleColor: (retryButtonTextColor ?? Theme.of(context).scaffoldBackgroundColor),
                buttonTitle: 'Retry',
                showBorder: false)
            : const SizedBox()
      ],
    );
  }
}
