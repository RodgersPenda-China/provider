import 'package:edemand_partner/ui/widgets/customTextFormField.dart';
import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/material.dart';

import 'colorPrefs.dart';

class CustomDialogs {
  static showSelectDialoge(
      {
      ///{ 'value':'', 'title':''}
      required List<Map<dynamic, dynamic>> itemList,
      dynamic selectedValue}) {
    dynamic selected = selectedValue;
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: itemList.map((item) {
            return RadioListTile<dynamic>(
              controlAffinity: ListTileControlAffinity.trailing,
              value: item['value'],
              groupValue: selected,
              onChanged: (value) {
                selected = value;
                setState(() {});

                Navigator.pop(context, item);
              },
              title: Text(item['title'].toString(), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            );
          }).toList(),
        ),
      );
    });
  }

  static showConfirmDialoge({
    required BuildContext context,
    required String title,
    required String description,
    required VoidCallback onConfirmed,
    required VoidCallback onCancled,
    bool? showProgress,
    bool? hasError,
    Color? confirmButtonColor,
    String? confirmButtonName,
    String? cancleButtonName,
    Color? progressColor,
    Color? confirmTextColor,
  }) {
    return AlertDialog(
      title: Text(title),
      content: Text(
        description,
        style: const TextStyle(fontSize: 16),
      ),
      actions: [
        MaterialButton(
          onPressed: () {
            Navigator.pop(context);
            onCancled();
          },
          child: Text(cancleButtonName ?? "cancel".translate(context: context)),
        ),
        MaterialButton(
          onPressed: () {
            onConfirmed();
          },
          color: confirmButtonColor,
          elevation: 0,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                confirmButtonName ?? "ok".translate(context: context),
                style: TextStyle(color: confirmTextColor ?? Colors.white),
              ),
              SizedBox(
                width: 5.rw(context),
              ),
              if (showProgress ?? false) ...[
                SizedBox(
                    width: 13.rw(context),
                    height: 13.rh(context),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: progressColor,
                    )),
              ],
              if (hasError ?? false) ...[
                const Icon(
                  Icons.warning,
                  size: 16,
                  color: Color.fromARGB(255, 91, 6, 0),
                )
              ]
            ],
          ),
        ),
      ],
    );
  }

  static showTextFieldDialoge(BuildContext context,
      {required String title,
      GlobalKey<FormState>? formKey,
      TextEditingController? controller,
      String? hint,
      Color? titleColor,
      required String message,
      required VoidCallback onConfirmed,
      required VoidCallback onCancled,
      Color? confirmButtonColor,
      String? confirmButtonName,
      bool? showProgress,
      String? cancleButtonName,
      Color? progressColor}) {
    return AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: titleColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: formKey,
              child: CustomTextFormField(
                controller: controller,
                isDense: true,
                borderColor: Theme.of(context).colorScheme.accentColor,
                isRoundedBorder: true,
                isPswd: true,
                forceUnfocus: false,
                backgroundColor: Theme.of(context).colorScheme.primaryColor,
                hintText: "enterYourPasswrd".translate(context: context),
                hintTextColor: Theme.of(context).colorScheme.lightGreyColor,
              ),
            ),
            Text(message)
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: showProgress == false
                ? () {
                    Navigator.pop(context);
                    onCancled();
                  }
                : null,
            child: Text(cancleButtonName ?? "cancel".translate(context: context)),
          ),
          MaterialButton(
              disabledColor: confirmButtonColor?.withOpacity(0.7),
              onPressed: (showProgress == false)
                  ? () {
                      if (formKey?.currentState?.validate() ?? false) {
                        onConfirmed();
                      }
                    }
                  : null,
              color: confirmButtonColor,
              elevation: 0,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    confirmButtonName ?? "ok".translate(context: context),
                    style: const TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 5.rw(context),
                  ),
                  if (showProgress ?? false) ...[
                    SizedBox(
                        width: 13.rw(context),
                        height: 13.rh(context),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: progressColor,
                        )),
                  ],
                ],
              )),
        ]);
  }
}
