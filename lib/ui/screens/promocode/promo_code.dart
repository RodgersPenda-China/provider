import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/cubits/PromocodeCubit/fetch_promocodes_cubit.dart';
import 'package:edemand_partner/data/cubits/delete_promocode_cubit.dart';
import 'package:edemand_partner/data/model/promocode_model.dart';
import 'package:edemand_partner/ui/widgets/addFloatingButton.dart';
import 'package:edemand_partner/ui/widgets/customIconButton.dart';
import 'package:edemand_partner/ui/widgets/customShimmerContainer.dart';
import 'package:edemand_partner/ui/widgets/shimmerLoadingContainer.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/colorPrefs.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/customContainer.dart';
import '../../widgets/customText.dart';
import '../../widgets/error_container.dart';
import '../../widgets/no_data_container.dart';

class PromoCode extends StatefulWidget {
  const PromoCode({Key? key}) : super(key: key);

  @override
  PromoCodeState createState() => PromoCodeState();

  static Route<PromoCode> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => DeletePromocodeCubit(),
          ),
        ],
        child: const PromoCode(),
      ),
    );
  }
}

class PromoCodeState extends State<PromoCode> {
  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(_pageScrollListener);

  @override
  void initState() {
    context.read<FetchPromocodesCubit>().fetchPromocodeList();
    super.initState();
  }

  void _pageScrollListener() {
    if (_pageScrollController.isEndReached()) {
      context.read<FetchPromocodesCubit>().fetchMorePromocodes();
    }
  }

  void deletePromocode(promocode) {
    DeletePromocodeCubit deletePromocodeCubit = BlocProvider.of<DeletePromocodeCubit>(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return BlocProvider.value(
          value: deletePromocodeCubit,
          child: Builder(
            builder: (context) {
              return CustomDialogs.showConfirmDialoge(
                  progressColor: Colors.white,
                  context: context,
                  showProgress:
                      context.watch<DeletePromocodeCubit>().state is DeletePromocodeInProgress,
                  confirmButtonColor: Colors.red,
                  confirmButtonName: "delete".translate(context: context),
                  cancleButtonName: "cancle".translate(context: context),
                  title: "deletePromocode".translate(context: context),
                  description: "deleteServiceDescription".translate(context: context),
                  onConfirmed: () {
                    if (promocode.id != null) {
                      if (Constant.isDemoModeEnable) {
                        UiUtils.showDemoModeWarning(context: context);
                        return;
                      }

                      ///delete promocode from here
                      context.read<DeletePromocodeCubit>().deletePromocode(
                        int.parse(promocode.id!),
                        onDelete: () {
                          Navigator.pop(context);
                        },
                      );
                    } else {
                      UiUtils.showMessage(context, "somethingWentWrong".translate(context: context),
                          MessageType.error);
                    }
                  },
                  onCancled: () {});
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        title: CustomText(
          titleText: "promoCodeLbl".translate(context: context),
          fontColor: Theme.of(context).colorScheme.blackColor,
        ),
        leading: UiUtils.setBackArrow(context),
      ),
      floatingActionButton: const AddFloatingButton(
        routeNm: Routes.addPromoCode,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: BlocListener<DeletePromocodeCubit, DeletePromocodeState>(
        listener: (context, state) {
          if (state is DeletePromocodeSuccess) {
            context.read<FetchPromocodesCubit>().deletePromocodeFromCubit(state.id);

            UiUtils.showMessage(
                context, "promocodeDeleteSuccess".translate(context: context), MessageType.success);
          }
          if (state is DeletePromocodeFailure) {
            UiUtils.showMessage(context, state.errorMessage, MessageType.error);
          }
        },
        child: mainWidget(),
      ),
    );
  }

  Widget mainWidget() {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FetchPromocodesCubit>().fetchPromocodeList();
      },
      child: SingleChildScrollView(
        clipBehavior: Clip.none,
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocBuilder<FetchPromocodesCubit, FetchPromocodesState>(
          builder: (context, state) {
            if (state is FetchPromocodesInProgress) {
              return ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemCount: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ShimmerLoadingContainer(
                          child: CustomShimmerContainer(
                        height: 150.rh(context),
                      )),
                    );
                  });
            }
            if (state is FetchPromocodesFailure) {
              return Center(
                  child: ErrorContainer(
                      onTapRetry: () {
                        context.read<FetchPromocodesCubit>().fetchPromocodeList();
                      },
                      errorMessage: state.errorMessage.toString()));
            }

            if (state is FetchPromocodesSuccess) {
              if (state.promocodes.isEmpty) {
                return NoDataContainer(titleKey: "noDataFound".translate(context: context));
              }
              return ListView.separated(
                controller: _pageScrollController,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: state.promocodes.length,
                physics: const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                itemBuilder: (context, index) {
                  PromocodeModel promocode = state.promocodes[index];
                  return CustomContainer(
                      padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                      bgColor: Theme.of(context).colorScheme.secondaryColor,
                      cornerRadius: 10,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: UiUtils.setNetworkImage(promocode.image!,
                                      ww: 80.rw(context), hh: 85.rh(context))),
                            ),
                            SizedBox(width: 12.rw(context)),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10, bottom: 2),
                                    child: CustomText(
                                      titleText: promocode.promoCode!,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontColor: Theme.of(context).colorScheme.blackColor,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3, bottom: 2),
                                    child: CustomText(
                                      maxLines: 2,
                                      titleText: promocode.message!,
                                      fontColor: Theme.of(context).colorScheme.lightGreyColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3, bottom: 2),
                                    child: setFromToTime(
                                        startDate: promocode.startDate!.split(" ")[0],
                                        endDate: promocode.endDate!.split(" ")[0]),
                                  ),
                                ],
                              ),
                            )
                          ]),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: setStatusAndButtons(
                              promoCodeStatus: promocode.status!,
                              context,
                              height: 30.rh(context),
                              editAction: () {
                                Navigator.pushNamed(context, Routes.addPromoCode,
                                    arguments: {"promocode": promocode});
                              },
                              deleteAction: () {
                                deletePromocode(promocode);
                              },
                            ),
                          ),
                        ],
                      ));
                },
                separatorBuilder: ((context, index) => const SizedBox(
                      height: 10,
                    )),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget setStatusAndButtons(BuildContext context,
      {required String promoCodeStatus,
      VoidCallback? editAction,
      VoidCallback? deleteAction,
      double? height}) {
    //set required later
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        setStatus(
          status: promoCodeStatus,
        ),
        SizedBox(width: 12.rw(context)),
        SizedBox(
          height: height,
          width: 84,
          child: CustomIconButton(
            imgName: 'edit',
            iconColor: Theme.of(context).colorScheme.blackColor,
            titleText: "editBtnLbl".translate(context: context),
            fontSize: 12.0,
            titleColor: Theme.of(context).colorScheme.blackColor,
            borderColor: Theme.of(context).colorScheme.lightGreyColor,
            bgColor: Theme.of(context).colorScheme.secondaryColor,
            onPressed: editAction,
            borderRadius: 5,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          height: height,
          width: 84,
          child: CustomIconButton(
            imgName: 'delete',
            titleText: "deleteBtnLbl".translate(context: context),
            fontSize: 12.0,
            iconColor: Theme.of(context).colorScheme.blackColor,
            borderRadius: 5,
            titleColor: Theme.of(context).colorScheme.blackColor,
            borderColor: Theme.of(context).colorScheme.lightGreyColor,
            bgColor: const Color.fromARGB(0, 255, 255, 255),
            onPressed: deleteAction, //() {},
          ),
        ),
      ],
    );
  }

  Widget setFromToTime({required String startDate, required String endDate}) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 5),
          child: UiUtils.setSVGImage('b_calender'),
        ),
        CustomText(
          fontColor: Theme.of(context).colorScheme.lightGreyColor,
          titleText: startDate,
          fontSize: 12,
        ),
        const SizedBox(
          width: 5,
        ),
        CustomText(
          fontColor: Theme.of(context).colorScheme.lightGreyColor,
          titleText: "toLbl".translate(context: context),
          fontSize: 12,
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: CustomText(
            fontColor: Theme.of(context).colorScheme.lightGreyColor,
            titleText: endDate,
            fontSize: 12,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  Widget setStatus({required String status}) {
    List<Map> statusFilterMap = [
      {"value": "0", "title": "DeActive".translate(context: context)},
      {"value": "1", "title": "Active".translate(context: context)}
    ];

    Map currentStatus = statusFilterMap.where((element) => element['value'] == status).toList()[0];

    return CustomContainer(
      height: 25,
      width: 80.rw(context),
      cornerRadius: 5,
      padding: const EdgeInsets.all(5),
      bgColor: Theme.of(context).colorScheme.headingFontColor,
      //change status color according to Status
      child: CustomText(
        titleText: currentStatus['title'],
        fontSize: 12,
        fontColor: Theme.of(context).colorScheme.secondaryColor,
        textAlign: TextAlign.center,
      ),
    );
  }
}
