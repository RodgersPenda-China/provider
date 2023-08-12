import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/cubits/languageCubit.dart';
import '../../../data/model/appLanguageModel.dart';
import '../../../utils/colorPrefs.dart';
import '../../../utils/constant.dart';
import '../../../utils/uiUtils.dart';

class ChooseLanguageBottomSheet extends StatefulWidget {
  const ChooseLanguageBottomSheet({Key? key}) : super(key: key);

  @override
  State<ChooseLanguageBottomSheet> createState() => _ChooseLanguageBottomSheetState();
}

class _ChooseLanguageBottomSheetState extends State<ChooseLanguageBottomSheet> {
  //
  Widget _getSelectLanguageHeading() {
    return Text("selectLanguage".translate(context: context),
        style: TextStyle(
          color: Theme.of(context).colorScheme.headingFontColor,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 20.0,
        ),
        textAlign: TextAlign.start);
  }

//
  getLanguageTile({required AppLanguage appLanguage}) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            context.read<LanguageCubit>().changeLanguage(appLanguage.languageCode);
            Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
              children: [
                SizedBox(
                  height: 25,
                  width: 25,
                  child: UiUtils.setSVGImage(appLanguage.imageURL, height: 25, width: 25),
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(appLanguage.languageName,
                        style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 18.0), textAlign: TextAlign.left))
              ],
            ),
          ),
        ),
        Divider(color: Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.4))
      ],
    );
  }

  //
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: _getSelectLanguageHeading(),
        ),
        Divider(color: Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.4)),
        Column(
          children: List.generate(appLanguages.length, (index) => getLanguageTile(appLanguage: appLanguages[index])),
        )
      ],
    );
  }
}
