import 'package:edemand_partner/ui/widgets/customContainer.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/uiUtils.dart';
import '../../widgets/customText.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  TransactionsState createState() => TransactionsState();
  static Route<Transactions> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => const Transactions(),
    );
  }
}

class TransactionsState extends State<Transactions> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        title: CustomText(
          fontColor: Theme.of(context).colorScheme.blackColor,
          titleText: "transactionsLbl".translate(context: context),
        ),
        leading: UiUtils.setBackArrow(context),
      ),
      body: mainWidget(), //use BLoC here
    );
  }

  Widget mainWidget() {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      physics: const AlwaysScrollableScrollPhysics(),
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        itemCount: 8,
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {}, //open detailed Service screen
            child: CustomContainer(
                height: MediaQuery.of(context).size.height * 0.18,
                padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                bgColor: Theme.of(context).colorScheme.secondaryColor,
                cornerRadius: 10,
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        titleText: "nameLbl".translate(context: context),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontColor: Theme.of(context).colorScheme.blackColor,
                      ),
                      CustomText(
                        titleText: "paymentMethodLbl".translate(context: context),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontColor: Theme.of(context).colorScheme.blackColor,
                      ),
                      CustomText(
                        titleText: "transactionIDLbl".translate(context: context),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontColor: Theme.of(context).colorScheme.blackColor,
                      ),
                      CustomText(
                        titleText: "transactionTypeLbl".translate(context: context),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        fontColor: Theme.of(context).colorScheme.blackColor,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  // Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     CustomText(
                  //       titleText: transactionDetails[index]['name'],
                  //       fontSize: 11,
                  //       fontWeight: FontWeight.w400,
                  //       fontColor: Theme.of(context).colorScheme.blackColor,
                  //     ),
                  //     CustomText(
                  //       titleText: transactionDetails[index]
                  //           ['paymentMethod'],
                  //       fontSize: 11,
                  //       fontWeight: FontWeight.w400,
                  //       maxLines: 2,
                  //       fontColor: Theme.of(context).colorScheme.blackColor,
                  //     ),
                  //     CustomText(
                  //       titleText: transactionDetails[index]
                  //           ['transacationID'],
                  //       fontSize: 11,
                  //       fontWeight: FontWeight.w400,
                  //       fontColor: Theme.of(context).colorScheme.blackColor,
                  //     ),
                  //     CustomText(
                  //       titleText: transactionDetails[index]
                  //           ['transactionType'],
                  //       fontSize: 11,
                  //       fontWeight: FontWeight.w400,
                  //       fontColor: Theme.of(context).colorScheme.blackColor,
                  //     ),
                  //   ],
                  // )
                ])),
          );
        },
        separatorBuilder: ((context, index) => const SizedBox(
              height: 20,
            )),
      ),
    );
  }
}
