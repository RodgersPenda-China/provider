import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/ui/widgets/dashedRect.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:flutter/material.dart';

import '../../utils/colorPrefs.dart';

class SetDottedBorderWithHint extends StatelessWidget {
  final double height;
  final double width;
  final String strPrefix;
  final String str;
  final double radius;
  final Color? borderColor;

  const SetDottedBorderWithHint(
      {Key? key,
      required this.height,
      required this.width,
      required this.strPrefix,
      required this.str,
      required this.radius,
      this.borderColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: AlignmentDirectional.center, children: [
      SizedBox(
          height: height,
          width: width,
          child: DashedRect(
            color: borderColor ?? Theme.of(context).colorScheme.lightGreyColor,
            strokeWidth: 2.0,
            gap: 4.0,
          )),
      SizedBox(
        height: height,
        width: width,
        child: Center(
          child: Wrap(
            direction: (strPrefix == "chooseFileLbl".translate(context: context))
                ? Axis.vertical
                : Axis.horizontal, //different for Add Logo & choose IDs
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              UiUtils.setSVGImage('image_icon',
                  imgColor: Theme.of(context).colorScheme.lightGreyColor),
              const SizedBox(
                width: 8.0,
              ),
              if (strPrefix != "chooseFileLbl".translate(context: context))
                CustomText(
                  titleText: '$strPrefix $str',
                  fontColor: Theme.of(context).colorScheme.lightGreyColor,
                  fontSize: 14,
                )
            ],
          ),
        ),
      )
    ]);
  }
}
