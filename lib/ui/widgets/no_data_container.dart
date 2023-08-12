import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:flutter/material.dart';

import '../../utils/uiUtils.dart';

class NoDataContainer extends StatelessWidget {
  final Color? textColor;
  final String titleKey;

  const NoDataContainer({Key? key, this.textColor, required this.titleKey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.35),
            child: UiUtils.setSVGImage("no_data_found"),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * (0.025),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              titleKey,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: textColor ?? Theme.of(context).colorScheme.blackColor,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
