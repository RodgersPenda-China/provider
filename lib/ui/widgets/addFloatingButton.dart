import 'package:flutter/material.dart';

// import '../../app/routes.dart';
import '../../utils/colorPrefs.dart';

class AddFloatingButton extends StatelessWidget {
  final String routeNm;
  final Function(dynamic value)? callWhenComeBack;
  const AddFloatingButton(
      {Key? key, required this.routeNm, this.callWhenComeBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.headingFontColor,
      elevation: 0.0,
      child: Icon(
        Icons.add_rounded,
        size: 40,
        color: Theme.of(context).colorScheme.primaryColor,
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(routeNm).then((value) {
          callWhenComeBack?.call(value);
        }); //Routes.createService
      }, //open Add service Screen
    );
  }
}
