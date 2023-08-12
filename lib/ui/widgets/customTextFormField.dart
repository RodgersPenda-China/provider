// ignore_for_file:file_names

import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? currNode;
  final FocusNode? nextFocus;
  final TextInputType textInputType;
  final bool isPswd;
  final double? heightVal;
  final Widget? prefix;
  final String? hintText;
  final String? labelText;
  final bool? isReadOnly;
  final VoidCallback? callback;
  final bool? isDense;
  final Color? backgroundColor;
  final bool? isRoundedBorder;
  final Color? borderColor;
  final Color? hintTextColor;
  final String? Function(String?)? validator;
  final bool? forceUnfocus;
  final Function()? onSubmit;
  final List<TextInputFormatter>? inputFormatters;
  final bool? expand;
  final int? minLines;
  final TextStyle? labelStyle;
  const CustomTextFormField({
    Key? key,
    required this.controller,
    this.currNode,
    this.nextFocus,
    this.textInputType = TextInputType.text,
    this.isPswd = false,
    this.heightVal,
    this.prefix,
    this.hintText,
    this.labelText,
    this.isReadOnly,
    this.callback,
    this.isDense,
    this.backgroundColor,
    this.isRoundedBorder,
    this.borderColor,
    this.hintTextColor,
    this.validator,
    this.forceUnfocus,
    this.onSubmit,
    this.inputFormatters,
    this.expand,
    this.minLines,
    this.labelStyle,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isPasswordVisible = false;

  togglePassword() {
    return IconButton(
        onPressed: () {
          setState(() {
            isPasswordVisible = !isPasswordVisible;
          });
        },
        icon: Icon(isPasswordVisible ? Icons.visibility_off : Icons.visibility));
  }

  bool _checkPasswordField() {
    if (widget.isPswd == true) {
      // if it is password field.
      // it will check the variable to check if we should show password or not
      return isPasswordVisible == false;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        focusNode: widget.currNode,
        inputFormatters: widget.inputFormatters,

        onEditingComplete: () {
          if (widget.nextFocus != null) {
            FocusScope.of(context).requestFocus(widget.nextFocus);
          } else if (widget.currNode != null) {
            if (widget.forceUnfocus ?? false) widget.currNode!.unfocus();
            widget.onSubmit?.call();
          }
        },
        onFieldSubmitted: (value) {},
        validator: widget.validator,
        onTap: widget.callback,

        cursorColor: Theme.of(context).colorScheme.lightGreyColor,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: widget.labelStyle ?? TextStyle(color: Theme.of(context).colorScheme.lightGreyColor, fontSize: 12),
          prefixIcon: widget.prefix,
          hintText: widget.hintText,
          hintStyle: TextStyle(color: widget.hintTextColor ?? Theme.of(context).colorScheme.lightGreyColor),
          isDense: widget.isDense ?? true,
          suffixIcon: widget.isPswd ? togglePassword() : null,
          fillColor: widget.backgroundColor ?? Theme.of(context).colorScheme.secondaryColor,
          errorStyle: const TextStyle(fontSize: 10, color: Colors.red),
          filled: true,
          errorBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.red), borderRadius: BorderRadius.circular(10)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ((widget.isRoundedBorder ?? false) && widget.borderColor != null) ? widget.borderColor! : Theme.of(context).colorScheme.headingFontColor),
              borderRadius: BorderRadius.circular(10)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ((widget.isRoundedBorder ?? false) && widget.borderColor != null) ? widget.borderColor! : Theme.of(context).colorScheme.headingFontColor),
              borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: ((widget.isRoundedBorder ?? false) && widget.borderColor != null) ? widget.borderColor! : Theme.of(context).colorScheme.headingFontColor),
              borderRadius: BorderRadius.circular(10)),
          border: OutlineInputBorder(borderSide: widget.isRoundedBorder == true ? const BorderSide() : BorderSide.none, borderRadius: BorderRadius.circular(10)),
        ),
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.titleSmall,
        readOnly: widget.isReadOnly ?? false,
        keyboardType: widget.textInputType,
        minLines: widget.minLines,
        maxLines: ((widget.textInputType == TextInputType.multiline) ? (widget.expand == true ? null : 3) : 1), //assigned 1 because null is not working with ObsecureText
        textInputAction: (widget.nextFocus != null)
            ? TextInputAction.next
            : (widget.textInputType == TextInputType.multiline)
                ? TextInputAction.newline
                : TextInputAction.done,
        obscureText: _checkPasswordField(),
        controller: widget.controller,
      ),
    );
  }
}
