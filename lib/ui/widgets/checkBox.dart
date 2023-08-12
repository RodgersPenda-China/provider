import 'package:flutter/material.dart';

import '../../utils/colorPrefs.dart';

class CheckBox extends StatelessWidget {
  final List<bool> isChecked;
  final int indexVal;
  final Function(bool?) onChanged;

  const CheckBox({Key? key, required this.isChecked, required this.indexVal, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Theme.of(context).colorScheme.secondaryColor,
      value: isChecked[indexVal],
      fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
        if (states.contains(MaterialState.disabled)) {
          return Theme.of(context).colorScheme.lightGreyColor.withOpacity(.35);
        } else if (states.contains(MaterialState.selected)) {
          return ColorPrefs.greenColor;
        }
        return Theme.of(context).colorScheme.lightGreyColor;
      }),
      onChanged: onChanged,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
    );
  }
}
