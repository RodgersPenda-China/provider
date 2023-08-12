import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edemand_partner/app/appTheme.dart';
import 'package:edemand_partner/data/cubits/appThemeCubit.dart';
import 'package:edemand_partner/ui/widgets/customTextFormField.dart';
import 'package:edemand_partner/ui/widgets/overlayMessageContainer.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../ui/widgets/customText.dart';
import 'constant.dart';

class UiUtils {
  //
  // Toast message display duration
  static const int messageDisplayDuration = 3000;

  //space from bottom for buttons
  static const double bottomButtonSpacing = 56;

  //required days to create PromoCode
  static const int noOfDaysAllowToCreatePromoCode = 365;

  //bottom sheet radius
  static double bottomSheetTopRadius = 20.0;

  ///IconButton
  static setBackArrow(BuildContext context, {bool? canGoBack, VoidCallback? onTap}) {
    return IconButton(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      icon: UiUtils.setSVGImage(
        'backArrow',
        boxFit: BoxFit.scaleDown,
        imgColor: Theme.of(context).colorScheme.blackColor,
      ),
      onPressed: onTap ??
          () {
            if (canGoBack ?? true) {
              Navigator.of(context).pop();
            }
          },
    );
  }

/*  static String getTranslatedLabel(BuildContext context, String labelKey) {
    return (AppLocalization.of(context)!.getTranslatedValues(labelKey) ?? labelKey).trim();
  }*/

  static Locale getLocaleFromLanguageCode(String languageCode) {
    List<String> result = languageCode.split("-");
    return result.length == 1 ? Locale(result.first) : Locale(result.first, result.last);
  }

  //price format
  static String getPriceFormat(BuildContext context, double price) {
    return NumberFormat.currency(
      locale: Platform.localeName,
      name: Constant.systemCurrencyCountryCode,
      symbol: Constant.systemCurrency,
      decimalDigits: int.parse(Constant.decimalPointsForPrice ?? "0"),
    ).format(price).toString();
  }

  ///Images
  static setSVGImage(String imageName,
      {double? height, double? width, Color? imgColor, BoxFit boxFit = BoxFit.contain}) {
    String path = "${Constant.svgPath}$imageName.svg";

    return SvgPicture.asset(
      path,
      height: height,
      width: width,
      color: imgColor,
      fit: boxFit,
    );
  }

  static setNetworkImage(String imgUrl, {double? hh, double? ww}) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      matchTextDirection: true,
      fit: BoxFit.cover,
      height: hh,
      width: ww,
      placeholder: ((context, url) {
        return Image.asset("assets/images/png/placeholder.png");
      }),
      errorWidget: (context, url, error) {
        return Image.asset("assets/images/png/placeholder.png");
      },
    );
  }

  ///Text & TextFormField
  static Widget setTitleAndTFF(BuildContext context,
      {required String titleText,
      required TextEditingController controller,
      FocusNode? currNode,
      FocusNode? nextFocus,
      TextInputType textInputType = TextInputType.text,
      bool isPswd = false,
      double? heightVal,
      Widget? prefix,
      String? hintText,
      bool? isReadOnly,
      VoidCallback? callback,
      Color? titleColor,
      bool? forceUnfocus,
      bool? expands,
      int? minLines,
      Function()? onSubmit,
      String? Function(String?)? validator,
      List<TextInputFormatter>? inputFormatters,
      double? bottomPadding,
      Color? backgroundColor,
      bool? allowOnlySingleDecimalPoint}) {
    return Padding(
      padding: EdgeInsetsDirectional.only(bottom: bottomPadding ?? 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            backgroundColor: backgroundColor,
            controller: controller,
            hintTextColor: Theme.of(context).colorScheme.lightGreyColor,
            currNode: currNode,
            nextFocus: nextFocus,
            expand: expands,
            minLines: minLines,
            textInputType: textInputType,
            isPswd: isPswd,
            prefix: prefix,
            hintText: hintText,
            labelText: titleText,
            isReadOnly: isReadOnly,
            callback: callback,
            forceUnfocus: forceUnfocus,
            inputFormatters: allowOnlySingleDecimalPoint ?? false
                ? [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))]
                : inputFormatters,
            onSubmit: onSubmit,
            validator: validator,
          ),
        ],
      ),
    );
  }

  ///Divider / Container
  static setDivider(
      {required BuildContext context, Color? containerColor, double? height, double? padding}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: height ?? 1.5,
        color: Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.1),
      ),
    );
  }

//bottomsheet
  static Future modalBottomSheet(
      {required BuildContext context, required DraggableScrollableSheet child, Color? bgColor}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      backgroundColor: bgColor ?? Theme.of(context).colorScheme.secondaryColor,
      //grayLightColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(5.0),
        child: child,
      ),
    );
  }

  static Future<dynamic> showBottomSheet(
      {required BuildContext context,
      required Widget child,
      Color? backgroundColor,
      bool? enableDrag}) async {
    final result = await showModalBottomSheet(
        enableDrag: enableDrag ?? false,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(bottomSheetTopRadius),
                topRight: Radius.circular(bottomSheetTopRadius))),
        context: context,
        builder: (_) {
          //using backdropFilter to blur the background screen
          //while bottomSheet is open
          return BackdropFilter(filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), child: child);
        });

    return result;
  }

  ///Navigation
  static pushtoNextScreen(var nextpage, BuildContext context) {
    return Navigator.of(context).pushNamed(nextpage);
  }

  ///show alert
  static Future showAlert({required String titleTxt, required BuildContext context}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: CustomText(
            titleText: titleTxt,
            fontSize: 14,
            maxLines: 2,
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(2.0))),
        );
      },
    );
  }

  static void removeFocus() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static SystemUiOverlayStyle getSystemUiOverlayStyle({required BuildContext context}) {
    return SystemUiOverlayStyle(
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarColor: Theme.of(context).colorScheme.primaryColor,
        systemNavigationBarIconBrightness:
            context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
                ? Brightness.light
                : Brightness.dark,
        //
        statusBarColor: Theme.of(context).colorScheme.primaryColor,
        //statusBarBrightness: context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark ? Brightness.light : Brightness.dark,
        statusBarIconBrightness: context.watch<AppThemeCubit>().state.appTheme == AppTheme.dark
            ? Brightness.light
            : Brightness.dark);
  }

  static showDemoModeWarning({required BuildContext context}) {
    return showMessage(context, "demoModeWarning".translate(context: context), MessageType.warning);
  }

  static showMessage(BuildContext context, String text, MessageType type,
      {Alignment? alignment, Duration? duration, VoidCallback? onMessageClosed}) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          top: alignment != null ? (alignment == Alignment.topCenter ? 50 : null) : null,
          left: 5,
          right: 5,
          bottom: alignment != null ? (alignment == Alignment.bottomCenter ? 5 : null) : 5,
          child: MessageContainer(context: context, text: text, type: type));
    });
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      overlayState.insert(overlayEntry);
    });
    await Future.delayed(duration ?? const Duration(seconds: 3));

    overlayEntry.remove();
    onMessageClosed?.call();
  }

  static time24to12hour(String time24) {
    DateTime tempDate = DateFormat("hh:mm").parse(time24);
    var dateFormat = DateFormat("h:mm a");
    return dateFormat.format(tempDate);
  }
}

///Format string
extension FormatAmount on String {
  String formatPercentage() {
    return "${toString()} %";
  }

  String formatId() {
    return " # ${toString()} "; // \u{20B9}"; //currencySymbol
  }

  String firstUpperCase() {
    String upperCase = "";
    var suffix = "";
    if (isNotEmpty) {
      upperCase = this[0].toUpperCase();
      suffix = substring(1, length);
    }
    return (upperCase + suffix);
  }
}

//scroll controller extension

extension ScrollEndListen on ScrollController {
  ///It will check if scroll is at the bottom or not
  bool isEndReached() {
    return offset >= position.maxScrollExtent;
  }
}
