import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String titleText;
  final Color? fontColor;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double fontSize;
  final TextAlign textAlign;
  final int maxLines;
  final bool showLineThrough;

  const CustomText(
      {Key? key,
      required this.titleText,
      this.fontColor,
      this.showLineThrough = false,
      this.fontWeight = FontWeight.w200,
      this.fontStyle = FontStyle.normal,
      this.fontSize = 16.0,
      this.textAlign = TextAlign.start,
      this.maxLines = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText,
      maxLines: maxLines,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: fontColor ?? Theme.of(context).colorScheme.lightGreyColor,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          fontSize: fontSize,
          letterSpacing: 0.5,
          decoration: showLineThrough! ? TextDecoration.lineThrough : null),
      textAlign: textAlign,
    );
  }
}
