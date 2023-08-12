import 'package:edemand_partner/app/app.dart';
import 'package:edemand_partner/app/appTheme.dart';
import 'package:edemand_partner/data/cubits/appThemeCubit.dart';
import 'package:edemand_partner/data/cubits/fetch_statistics_cubit.dart';
import 'package:edemand_partner/data/cubits/fetch_system_settings_cubit.dart';
import 'package:edemand_partner/data/model/statistics_model.dart';
import 'package:edemand_partner/ui/widgets/charts/categoryPieChart.dart';
import 'package:edemand_partner/ui/widgets/charts/monthlyEarningBarChart.dart';
import 'package:edemand_partner/ui/widgets/customShimmerContainer.dart';
import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/ui/widgets/customTweenAnimation.dart';
import 'package:edemand_partner/ui/widgets/error_container.dart';
import 'package:edemand_partner/ui/widgets/shimmerLoadingContainer.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  int gridItems = 4;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    //
    context.read<FetchStatisticsCubit>().getStatistics();
    context.read<FetchSystemSettingsCubit>().getSettings(isAnonymous: false);

    super.initState();
  }

  _getStatesValue(StatisticsModel states, int index) {
    switch (index) {
      case 0:
        return states.totalOrders;
      case 1:
        return states.totalCancles;
      case 2:
        return states.totalServices;
      case 3:
        return states.totalBalance;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    FirebaseMessaging.instance.getToken().then((value) {});
    FirebaseMessaging.instance.getToken();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        body: dashboard(),
      ),
    );
  }

  Widget dashboard() {
    List<Map> cardDetails = [
      {
        'id': '0',
        'imgName': context.watch<AppThemeCubit>().state.appTheme == AppTheme.light
            ? 'ttl_booking'
            : 'ttl_booking_white',
        'title': "totalBookingLbl".translate(context: context),
        'showCurrencyIcon': false,
      },
      {
        'id': '1',
        'imgName': context.watch<AppThemeCubit>().state.appTheme == AppTheme.light
            ? 'ttl_cancel'
            : 'ttl_cancel_white',
        'title': "totalCancelLbl".translate(context: context),
        'showCurrencyIcon': false,
      },
      {
        'id': '2',
        'imgName': 'ttl_services',
        'title': "totalServicesLbl".translate(context: context),
        "imgColor": Theme.of(context).colorScheme.blackColor,
        'showCurrencyIcon': false,
      },
      {
        'id': '3',
        'imgName': 'ttl_earning',
        'title': "totalEarningLbl".translate(context: context),
        "imgColor": Theme.of(context).colorScheme.blackColor,
        'showCurrencyIcon': true,
      }
    ];
    return BlocBuilder<FetchStatisticsCubit, FetchStatisticsState>(
      builder: (context, state) {
        if (state is FetchStatisticsInProgress) {
          return SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              children: [
                ScrollConfiguration(
                  behavior: CustomScrollBehaviour(),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    itemCount: gridItems,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10, //horizontal spacing between 2 cards
                        childAspectRatio: MediaQuery.of(context).size.width /
                            (MediaQuery.of(context).size.height / 2.2)),
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return const ShimmerLoadingContainer(child: CustomShimmerContainer());
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ShimmerLoadingContainer(
                      child: CustomShimmerContainer(
                    height: 250.rh(context),
                  )),
                ),
              ],
            ),
          );
        }
        if (state is FetchStatisticsFailure) {
          return Center(
              child: ErrorContainer(
                  onTapRetry: () {
                    context.read<FetchStatisticsCubit>().getStatistics();
                    context.read<FetchSystemSettingsCubit>().getSettings(isAnonymous: false);
                  },
                  errorMessage: state.errorMessage.toString()));
        }

        if (state is FetchStatisticsSuccess) {
          return SingleChildScrollView(
            clipBehavior: Clip.none,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                ScrollConfiguration(
                  behavior: CustomScrollBehaviour(),
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                    itemCount: gridItems,
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5, //horizontal spacing between 2 cards
                        childAspectRatio: 1.1),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                          color: Theme.of(context).colorScheme.secondaryColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 10),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      height: 35,
                                      width: 38,
                                      child: UiUtils.setSVGImage(cardDetails[index]['imgName'],
                                          imgColor: cardDetails[index]['imgColor'])),
                                  CustomText(
                                    titleText: cardDetails[index]['title'],
                                    fontSize: 14,
                                    fontColor: Theme.of(context).colorScheme.blackColor,
                                  ),
                                  CustomTweenAnimation(
                                      curve: Curves.fastLinearToSlowEaseIn,
                                      beginValue: 0,
                                      endValue:
                                          double.parse(_getStatesValue(state.statistics, index)),
                                      durationInSeconds: 1,
                                      builder: (context, value, child) => CustomText(
                                            titleText:
                                                "${cardDetails[index]['showCurrencyIcon'] ? Constant.systemCurrency : ""}${value.toStringAsFixed(0)}",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            fontColor:
                                                Theme.of(context).colorScheme.headingFontColor,
                                          )),
                                ]),
                          ));
                    },
                  ),
                ),
                if (state.statistics.monthlyEarnings?.monthlySales?.isNotEmpty ?? false) ...[
                  SizedBox(
                    height: 300,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 0, right: 15, left: 15),
                      child: MonthlyEarningBarChart(
                          monthlySales: state.statistics.monthlyEarnings!.monthlySales!),
                    ),
                  ),
                ],
                if (state.statistics.caregories?.isNotEmpty ?? false) ...[
                  SizedBox(
                    height: 260,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: CategoryPieChart(categoryProductCounts: state.statistics.caregories!),
                    ),
                  )
                ]
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
