import 'package:edemand_partner/data/cubits/fetchWithdrawalRequestCubit.dart';
import 'package:edemand_partner/data/cubits/fetch_system_settings_cubit.dart';
import 'package:edemand_partner/data/cubits/sendWithdrawalRequestCubit.dart';
import 'package:edemand_partner/data/model/withdrawal_model.dart';
import 'package:edemand_partner/ui/screens/Withdrawal/send_withdrawal_requests.dart';
import 'package:edemand_partner/ui/widgets/customContainer.dart';
import 'package:edemand_partner/ui/widgets/customShimmerContainer.dart';
import 'package:edemand_partner/ui/widgets/shimmerLoadingContainer.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/uiUtils.dart';
import '../../widgets/customText.dart';
import '../../widgets/error_container.dart';
import '../../widgets/no_data_container.dart';

class WithdrawalRequestsScreen extends StatefulWidget {
  const WithdrawalRequestsScreen({Key? key}) : super(key: key);

  @override
  WithdrawalRequestsScreenState createState() => WithdrawalRequestsScreenState();

  static Route<WithdrawalRequestsScreen> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FetchWithdrawalRequestCubit(),
          ),
          BlocProvider(
            create: (context) => SendWithdrawalRequestCubit(),
          ),
        ],
        child: const WithdrawalRequestsScreen(),
      ),
    );
  }
}

class WithdrawalRequestsScreenState extends State<WithdrawalRequestsScreen> {
  TextEditingController searchController = TextEditingController();
  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(_pageScrollListen);

  ValueNotifier<bool> isScrolling = ValueNotifier(false);

  @override
  void initState() {
    context.read<FetchWithdrawalRequestCubit>().fetchWithdrawals();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    isScrolling.dispose();
    super.dispose();
  }

  _pageScrollListen() {
    if (_pageScrollController.position.pixels > 7 && !isScrolling.value) {
      isScrolling.value = true;
    } else if (_pageScrollController.position.pixels < 7 && isScrolling.value) {
      isScrolling.value = false;
    }
    if (_pageScrollController.isEndReached()) {
      if (context.read<FetchWithdrawalRequestCubit>().hasMoreData()) {
        context.read<FetchWithdrawalRequestCubit>().fetchMoreWithdrawals();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        title: CustomText(
          titleText: "withdrawalRequest".translate(context: context),
          fontColor: Theme.of(context).colorScheme.blackColor,
        ),
        leading: UiUtils.setBackArrow(context),
      ),
      body: mainWidget(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget mainWidget() {
    return BlocBuilder<FetchWithdrawalRequestCubit, FetchWithdrawalRequestState>(
      builder: (context, state) {
        if (state is FetchWithdrawalRequestFailure) {
          return Center(
              child: ErrorContainer(
                  onTapRetry: () {
                    context.read<FetchWithdrawalRequestCubit>().fetchWithdrawals();
                  },
                  errorMessage: state.errorMessage.toString()));
        }
        if (state is FetchWithdrawalRequestSuccess) {
          if (state.withdrawals.isEmpty) {
            return NoDataContainer(titleKey: "noDataFound".translate(context: context));
          }
          return Stack(
            children: [
              SingleChildScrollView(
                controller: _pageScrollController,
                clipBehavior: Clip.none,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 110,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      itemCount: state.withdrawals.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        WithdrawalModel withdrawal = state.withdrawals[index];
                        return CustomContainer(
                            height: MediaQuery.of(context).size.height * 0.125,
                            padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                            bgColor: Theme.of(context).colorScheme.secondaryColor,
                            cornerRadius: 10,
                            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    titleText: "bankDetailsLbl".translate(context: context),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontColor: Theme.of(context).colorScheme.blackColor,
                                  ),
                                  CustomText(
                                    titleText: "amountLbl".translate(context: context),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontColor: Theme.of(context).colorScheme.blackColor,
                                  ),
                                  CustomText(
                                    titleText: "statusLbl".translate(context: context),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontColor: Theme.of(context).colorScheme.blackColor,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    titleText: withdrawal.paymentAddress!,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    maxLines: 2,
                                    fontColor: Theme.of(context).colorScheme.blackColor,
                                  ),
                                  CustomText(
                                    titleText: withdrawal.amount!,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    fontColor: Theme.of(context).colorScheme.blackColor,
                                  ),
                                  CustomText(
                                    titleText: withdrawal.status!,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    fontColor: Theme.of(context).colorScheme.blackColor,
                                  ),
                                ],
                              )
                            ]));
                      },
                      separatorBuilder: ((context, index) => const SizedBox(
                            height: 10,
                          )),
                    ),
                    if (state.isLoadingMore) ...[
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.headingFontColor,
                      )
                    ]
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: InkWell(
                  onTap: () {
                    UiUtils.showBottomSheet(
                      enableDrag: true,
                      context: context,
                      child: Wrap(
                        children: [
                          BlocProvider(
                            create: (context) => SendWithdrawalRequestCubit(),
                            child: const SendWithdrawalRequest(),
                          ),
                        ],
                      ),
                    );
                    return;
                  },
                  child: ValueListenableBuilder(
                    valueListenable: isScrolling,
                    builder: (context, value, child) => Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primaryColor,
                          boxShadow: isScrolling.value
                              ? [
                                  BoxShadow(
                                      offset: const Offset(0, 0.75),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      color:
                                          Theme.of(context).colorScheme.blackColor.withOpacity(0.2))
                                ]
                              : []),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        height: 95,
                        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.headingFontColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "yourBalanceLbl".translate(context: context),
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Theme.of(context).colorScheme.secondaryColor),
                                ),
                                Text(
                                  UiUtils.getPriceFormat(
                                    context,
                                    double.parse((context.watch<FetchSystemSettingsCubit>().state
                                            as FetchSystemSettingsSuccess)
                                        .availableAmount
                                        .replaceAll(",", "")),
                                  ),
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).colorScheme.secondaryColor),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryColor,
                                  borderRadius: BorderRadius.circular(10)),
                              height: 50,
                              width: 50,
                              child: Icon(
                                Icons.add_outlined,
                                color: Theme.of(context).colorScheme.blackColor,
                                size: 40,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            itemCount: 8,
            physics: const NeverScrollableScrollPhysics(),
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ShimmerLoadingContainer(
                    child: CustomShimmerContainer(
                  height: MediaQuery.of(context).size.height * 0.18,
                )),
              );
            });
      },
    );
  }
}
