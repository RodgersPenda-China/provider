// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../../utils/colorPrefs.dart';

class CustomFormDropdown extends StatefulWidget {
  final VoidCallback onTap;
  final String? Function(String?)? validator;
  final String? initialTitle;
  final String? selectedValue;

  const CustomFormDropdown({
    Key? key,
    required this.onTap,
    this.validator,
    this.initialTitle,
    this.selectedValue,
  }) : super(key: key);

  @override
  State<CustomFormDropdown> createState() => _CustomFormDropdownState();
}

class _CustomFormDropdownState extends State<CustomFormDropdown> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: true,
        validator: widget.validator,
        onTap: widget.onTap,
        style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.blackColor),
        controller: TextEditingController(text: widget.selectedValue ?? widget.initialTitle),
        decoration: InputDecoration(
          errorStyle: const TextStyle(fontSize: 12),
          fillColor: Theme.of(context).colorScheme.secondaryColor,
          filled: true,
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: Theme.of(context).colorScheme.headingFontColor),
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.lightGreyColor), borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.headingFontColor), borderRadius: BorderRadius.circular(12)),
          border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.blackColor), borderRadius: BorderRadius.circular(12)),
        ));
  }
}
