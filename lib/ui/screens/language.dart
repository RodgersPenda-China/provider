import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/shadowButton.dart';

class Language extends StatefulWidget {
  final int? from;
  const Language({Key? key, this.from}) : super(key: key);

  @override
  LanguageState createState() => LanguageState();
  static Route<Language> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const Language(),
    );
  }
}

class LanguageState extends State<Language> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<Map> langList = [
    //langCode - used to setPreferences throught the app
    {
      'id': '0',
      'flagImage': 'america_flag', //'assets/images/svg/splashlogo.svg',
      'langName': "English",
      'langCode': 'en'
    },
    {'id': '1', 'flagImage': 'spain_flag', 'langName': 'Spanish', 'langCode': 'es'},
    {'id': '2', 'flagImage': 'india_flag', 'langName': 'Hindi', 'langCode': 'hi'},
    {'id': '3', 'flagImage': 'arab_flag', 'langName': 'Arabic', 'langCode': 'ar'},
    {'id': '4', 'flagImage': 'portugese_flag', 'langName': 'Portugese', 'langCode': 'pt'},
  ];

  int? selectLan;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: CustomText(
          titleText: "langTitle".translate(context: context),
          textAlign: TextAlign.center,
        ),
        leading: UiUtils.setBackArrow(context),
      ),
      body: setBuilder(),
      bottomNavigationBar: saveBtn(),
    );
  }

  setBuilder() {
    return Container(margin: const EdgeInsetsDirectional.only(top: 20, bottom: 20), child: getLangList());
    // child: Column(children: [Expanded(child: getLangList()), saveBtn()]));
  }

  getLangList() {
    return ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 20),
        physics: const AlwaysScrollableScrollPhysics(),
        itemBuilder: ((context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
                leading: UiUtils.setSVGImage(langList[index]['flagImage']),
                /* SvgPicture.asset(
                  langList[index]['flagImage'],
                  width: 30,
                  height: 30,
                ), */
                title: CustomText(
                    titleText: langList[index]['langName'],
                    fontColor: (selectLan == index) ? Theme.of(context).colorScheme.secondaryColor : Theme.of(context).colorScheme.headingFontColor,
                    fontSize: 18.0),

                /* Text(
                  langList[index]['langName'],
                  style: Theme.of(this.context).textTheme.titleLarge?.copyWith(
                      color: (selectLan == index)
                          ? ColorPrefs.whiteColor
                          : ColorPrefs.lightFontColor),
                ), */
                tileColor: selectLan == index ? Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.8) : null,
                onTap: () {
                  setState(() {
                    selectLan = index;
                  });
                },
              ),
            )),
        separatorBuilder: (context, index) {
          return const SizedBox(height: 1.0);
        },
        itemCount: langList.length);
  }

  saveBtn() {
    return Container(
        margin: const EdgeInsets.all(20),
        child: ShadowButton(
          onPressed: () {
            //check - atleast one should be selected
            //set selected language as App language & close screen
            Navigator.pop(context);
          },
          text: "saveBtn".translate(context: context),
          backgroundColor: Theme.of(context).colorScheme.lightGreyColor,
        ));
  }
}
