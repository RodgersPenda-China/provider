import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:flutter/material.dart';

import '../../utils/colorPrefs.dart';
import '../../utils/uiUtils.dart';

class CustomIconButton extends StatelessWidget {
  final String imgName;
  final String titleText;
  final double fontSize;
  final Color titleColor;
  final Color bgColor;
  final Color? borderColor;
  final double borderRadius;
  final TextDirection textDirection;
  final VoidCallback? onPressed;
  final Color? iconColor;
  const CustomIconButton(
      {Key? key,
      required this.imgName,
      required this.titleText,
      required this.fontSize,
      required this.titleColor,
      required this.bgColor,
      this.borderColor,
      this.borderRadius = 10,
      this.textDirection = TextDirection.ltr,
      this.onPressed,
      this.iconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: ElevatedButton.icon(
          onPressed: onPressed,
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              padding: MaterialStateProperty.all(
                  const EdgeInsetsDirectional.only(start: 2, end: 2)),
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                      side:
                          BorderSide(width: 1.0, color: borderColor ?? bgColor),
                      borderRadius: BorderRadius.circular(borderRadius))),
              backgroundColor: MaterialStateProperty.all(bgColor)),
          icon: UiUtils.setSVGImage(imgName,
              imgColor:
                  iconColor ?? Theme.of(context).colorScheme.primaryColor),
          label: CustomText(
            titleText: titleText,
            fontColor: titleColor,
            fontSize: fontSize,
          )),
    );
  }
}
