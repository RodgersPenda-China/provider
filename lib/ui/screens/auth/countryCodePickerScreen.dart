import 'package:country_calling_code_picker/country.dart';
import 'package:country_calling_code_picker/country_code_picker.dart';
import 'package:edemand_partner/data/cubits/countryCodeCubit.dart';
import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CountryCodePickerScreen extends StatelessWidget {
  const CountryCodePickerScreen({Key? key}) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) {
      return const CountryCodePickerScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(true);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.primaryColor,
          title: CustomText(
            titleText: "",
            fontColor: Theme.of(context).colorScheme.blackColor,
          ),
          leading: UiUtils.setBackArrow(context),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(top: 15),
                      height: 55,
                      child: TextField(
                        onTap: () {},
                        onChanged: (text) {
                          context.read<CountryCodeCubit>().filterCountryCodeList(text);
                        },
                        style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.blackColor),
                        cursorColor: Theme.of(context).colorScheme.accentColor,
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsetsDirectional.only(bottom: 2, start: 15),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.primaryColor,
                            hintText: "search_by_country_name".translate(context: context),
                            hintStyle: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.blackColor),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor), borderRadius: const BorderRadius.all(Radius.circular(12))),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor), borderRadius: const BorderRadius.all(Radius.circular(12))),
                            border: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).colorScheme.accentColor), borderRadius: const BorderRadius.all(Radius.circular(12))),
                            suffixIcon: Container(
                              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                              child: UiUtils.setSVGImage(
                                "search",
                                height: 12,
                                width: 12,
                              ),
                            )),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(
                        "select_your_country".translate(context: context),
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Theme.of(context).colorScheme.headingFontColor),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.lightGreyColor,
                  )
                ],
              ),
            ),
            BlocBuilder<CountryCodeCubit, CountryCodeState>(
              builder: (context, state) {
                if (state is CountryCodeLoadingInProgress) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (state is CountryCodeFetchSuccess) {
                  return Expanded(
                    child: state.temporaryCountryList!.isNotEmpty
                        ? ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                            ),
                            itemCount: state.temporaryCountryList!.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (BuildContext context, int index) {
                              Country country = state.temporaryCountryList![index];
                              return InkWell(
                                onTap: () async {
                                  await Future.delayed(Duration.zero, () {
                                    context.read<CountryCodeCubit>().selectCountryCode(country);

                                    Navigator.pop(context);
                                  });
                                },
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 35,
                                      height: 25,
                                      child: Image.asset(
                                        country.flag,
                                        package: countryCodePackageName,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                        child: Text(country.name,
                                            style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 18.0),
                                            textAlign: TextAlign.start)),
                                    Text(country.callingCode,
                                        style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontWeight: FontWeight.w400, fontStyle: FontStyle.normal, fontSize: 18.0),
                                        textAlign: TextAlign.end),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5),
                                child: Divider(
                                  thickness: 0.9,
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Text("no_country_found".translate(context: context)),
                          ),
                  );
                }
                if (state is CountryCodeFetchFail) {
                  return Center(child: Text(state.error.toString()));
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }
}
