import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/material.dart';

import '../../utils/colorPrefs.dart';

class PageNumberIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;

  const PageNumberIndicator({
    Key? key,
    required this.currentIndex,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var strValue = "${"stepLbl".translate(context: context)} $currentIndex ${"ofLbl".translate(context: context)} $total";
    return Container(
      padding: const EdgeInsetsDirectional.only(end: 10),
      alignment: Alignment.center,
      child: CustomText(
        titleText: strValue,
        fontSize: 14.0,
        fontColor: Theme.of(context).colorScheme.blackColor,
      ),
    );
  }
}
