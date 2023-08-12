import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double max;
  final double current;
  final Color color;

  const ProgressBar({Key? key, required this.max, required this.current, this.color = ColorPrefs.greenColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, boxConstraints) {
        var x = boxConstraints.maxWidth;
        var percent = (current / max) * x;
        return Stack(
          children: [
            Container(
              width: x,
              height: 7,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryColor,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: percent,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ],
        );
      },
    );
  }
}
