import 'dart:async';

import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/cubits/delete_service_cubit.dart';
import 'package:edemand_partner/data/cubits/fetchServiceCategoryCubit.dart';
import 'package:edemand_partner/data/cubits/fetchTaxesCubit.dart';
import 'package:edemand_partner/data/cubits/fetch_services_Cubit.dart';
import 'package:edemand_partner/data/model/service_filter_model.dart';
import 'package:edemand_partner/data/model/service_model.dart';
import 'package:edemand_partner/ui/widgets/addFloatingButton.dart';
import 'package:edemand_partner/ui/widgets/customContainer.dart';
import 'package:edemand_partner/ui/widgets/customIconButton.dart';
import 'package:edemand_partner/ui/widgets/no_data_container.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/dialogs.dart';
import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/bottomSheets/service_filter_bottomsheet.dart';
import '../../widgets/customShimmerContainer.dart';
import '../../widgets/customText.dart';
import '../../widgets/error_container.dart';
import '../../widgets/shimmerLoadingContainer.dart';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  ServicesScreenState createState() => ServicesScreenState();
}

class ServicesScreenState extends State<ServicesScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  //
  double? minFilterRange;
  double? maxFilterRange;
  ServiceFilterDataModel? filters;

  //
  var prevVal = '';

  Timer? _searchDelay;
  String previouseSearchQuery = "";

  //
  late TextEditingController searchController = TextEditingController()
    ..addListener(searchServiceListener);

  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(_pageScrollListener);

  late final AnimationController _filterButtonOpacityAnimation =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

  //
  ValueNotifier<bool> isScrolling = ValueNotifier(false);

  @override
  void initState() {
    context.read<FetchServicesCubit>().fetchServices(filter: filters);
    context.read<FetchServiceCategoryCubit>().fetchCategories();
    context.read<FetchTaxesCubit>().fetchTaxes();
    super.initState();
  }

  void _pageScrollListener() {
    if (_pageScrollController.position.pixels > 7 && !isScrolling.value) {
      isScrolling.value = true;
    } else if (_pageScrollController.position.pixels < 7 && isScrolling.value) {
      isScrolling.value = false;
    }
    if (_pageScrollController.isEndReached()) {
      if (context.read<FetchServicesCubit>().hasMoreServices()) {
        context.read<FetchServicesCubit>().fetchMoreServices(filter: filters);
      }
    }
  }

  void searchServiceListener() {
    _searchDelay?.cancel();
    searchCallAfterDelay();
  }

  void searchCallAfterDelay() {
    if (searchController.text != "") {
      _searchDelay = Timer(const Duration(milliseconds: 500), searchService);
    } else {
      context.read<FetchServicesCubit>().fetchServices();
    }
  }

  Future<void> searchService() async {
    if (searchController.text.isNotEmpty) {
      if (previouseSearchQuery != searchController.text) {
        context.read<FetchServicesCubit>().searchService(searchController.text);
        previouseSearchQuery = searchController.text;
      }
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    isScrolling.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        body: Stack(
          children: [
            mainWidget(),
            ValueListenableBuilder(
                valueListenable: isScrolling,
                builder: (context, value, child) {
                  return Container(
                    height: 60,
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
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Align(alignment: Alignment.topCenter, child: topWidget()),
                  );
                })
          ],
        ),
        floatingActionButton: const AddFloatingButton(routeNm: Routes.createService),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  Widget topWidget() {
    return BlocConsumer<FetchServicesCubit, FetchServicesState>(
      listener: ((context, state) {
        if (state is FetchServicesSuccess) {
          _filterButtonOpacityAnimation.forward();
        }
      }),
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisSize: MainAxisSize.max, //.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              setSearchbar(),
              if (state is FetchServicesSuccess) ...{
                AnimatedBuilder(
                    animation: _filterButtonOpacityAnimation,
                    builder: (context, c) {
                      return AnimatedOpacity(
                        duration: _filterButtonOpacityAnimation.duration!,
                        opacity: _filterButtonOpacityAnimation.value,
                        child: setFilterButton(
                            maxRange: state.maxFilterRange + 1, minRange: state.minFilterRange),
                      );
                    })
              }
            ],
          ),
        );
      },
    );
  }

  Widget setSearchbar() {
    return CustomContainer(
        width: 250.rw(context),
        height: 35,
        cornerRadius: 10,
        bgColor: Theme.of(context).colorScheme.secondaryColor,
        child: TextFormField(
          autofocus: false,
          controller: searchController,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            border: InputBorder.none,
            isDense: true,
            fillColor: Theme.of(context).colorScheme.blackColor,
            hintText: "searchServicesLbl".translate(context: context),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: Theme.of(context).colorScheme.headingFontColor,
            ),
          ),
          textAlignVertical: TextAlignVertical.center,
          enableSuggestions: true,
          onEditingComplete: () {
            FocusScope.of(context).unfocus();
          },
        ));
  }

  Widget setFilterButton({required double minRange, required double maxRange}) {
    return SizedBox(
      height: 35.rh(context),
      width: 83.rw(context),
      child: CustomIconButton(
        textDirection: TextDirection.rtl,
        imgName: 'filter',
        titleText: "filterBtnLbl".translate(context: context),
        fontSize: 12,
        titleColor: Theme.of(context).colorScheme.secondaryColor,
        bgColor: Theme.of(context).colorScheme.headingFontColor,
        onPressed: () async {
          var result = await showModalBottomSheet(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            context: context,
            builder: (context) {
              return BlocProvider.value(
                value: BlocProvider.of<FetchServiceCategoryCubit>(context),
                child: Builder(builder: (context) {
                  return FilterByBottomSheet(
                    minRange: minRange,
                    maxRange: maxRange,
                    selectedMinRange: double.parse(filters?.minBudget ?? minRange.toString()),
                    selectedMaxRange: double.parse(filters?.maxBudget ?? maxRange.toString()),
                    selectedRating: filters?.rating,
                  );
                }),
              );
            },
          );

          if (result != null) {
            filters = result;

            setState(() {});
            Future.delayed(Duration.zero, () {
              context.read<FetchServicesCubit>().fetchServices(filter: result);
            });
          }
        },
      ),
    );
  }

  Widget mainWidget() {
    return BlocListener<DeleteServiceCubit, DeleteServiceState>(
      listener: (context, deleteServiceState) {
        if (deleteServiceState is DeleteServiceSuccess) {
          context.read<FetchServicesCubit>().deleteServiceFromCubit(deleteServiceState.id);
          UiUtils.showMessage(
              context, "serviceDeleatedSuccess".translate(context: context), MessageType.success);
        }
        if (deleteServiceState is DeleteServiceFailure) {
          UiUtils.showMessage(context, deleteServiceState.errorMessage, MessageType.error);
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<FetchServicesCubit>().fetchServices(filter: filters);
          context.read<FetchTaxesCubit>().fetchTaxes();
        },
        child: BlocBuilder<FetchServicesCubit, FetchServicesState>(
          builder: (context, state) {
            if (state is FetchServicesFailure) {
              return Center(
                  child: ErrorContainer(
                      onTapRetry: () {
                        context.read<FetchServicesCubit>().fetchServices(filter: filters);
                        context.read<FetchTaxesCubit>().fetchTaxes();
                      },
                      errorMessage: state.errorMessage.toString()));
            }
            if (state is FetchServicesSuccess) {
              if (state.services.isEmpty) {
                return Center(
                  child: NoDataContainer(titleKey: "noDataFound".translate(context: context)),
                );
              }
              return SingleChildScrollView(
                clipBehavior: Clip.none,
                controller: _pageScrollController,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 65,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                      itemCount: state.services.length,
                      physics: const NeverScrollableScrollPhysics(),
                      clipBehavior: Clip.none,
                      itemBuilder: (context, index) {
                        ServiceModel service = state.services[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.serviceDetails,
                                arguments: {"serviceModel": service});
                          },
                          child: CustomContainer(
                            height: 140,
                            padding: const EdgeInsets.all(14),
                            bgColor: Theme.of(context).colorScheme.secondaryColor,
                            cornerRadius: 10,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      width: 82.rw(context),
                                      height: 85,
                                      child: setImage(imaegUrl: service.imageOfTheService!),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        titleText: service.title!.firstUpperCase(),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontColor: Theme.of(context).colorScheme.blackColor,
                                      ),
                                      Divider(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .headingFontColor
                                              .withOpacity(0.4)),
                                      setRatingsAndPrice(
                                        ratings: service.rating!,
                                        numberOfRatings: service.numberOfRatings!,
                                        price: UiUtils.getPriceFormat(
                                            context, double.parse(service.price!)),
                                        discountPrice: UiUtils.getPriceFormat(
                                            context, double.parse(service.discountedPrice!)),
                                      ),
                                      Divider(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .headingFontColor
                                              .withOpacity(0.4)),
                                      setButtons(service)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: ((context, index) => const SizedBox(
                            height: 10,
                          )),
                    ),
                    if (state.isLoadingMoreServices)
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.headingFontColor,
                      )
                  ],
                ),
              );
            }
            return SingleChildScrollView(
              clipBehavior: Clip.none,
              child: Column(
                children: [
                  const SizedBox(
                    height: 65,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    addAutomaticKeepAlives: false,
                    addRepaintBoundaries: false,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsetsDirectional.all(16),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: ShimmerLoadingContainer(
                            child: CustomShimmerContainer(
                          height: 120.rh(context),
                        )),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget setImage({required String imaegUrl}) {
    return CustomContainer(
        cornerRadius: 10,
        bgColor: Colors.transparent,
        child: Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: UiUtils.setNetworkImage(imaegUrl, ww: 80.rw(context), hh: 85))));
  }

  Widget setRatingsAndPrice(
      {required String ratings,
      required String numberOfRatings,
      required String price,
      required String discountPrice}) {
    print("discount $discountPrice");
    return Row(
      mainAxisSize: MainAxisSize.min,
      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          height: 30,
          child: CustomIconButton(
              imgName: 'star',
              titleText: ratings,
              fontSize: 14.0,
              titleColor: Theme.of(context).colorScheme.primaryColor,
              bgColor: Theme.of(context).colorScheme.headingFontColor),
        ),
        const SizedBox(
          width: 8,
        ),
        CustomText(
            fontColor: Theme.of(context).colorScheme.blackColor,
            titleText: "${"fromLbl".translate(context: context)} $numberOfRatings",
            fontSize: 12.0),
        // const SizedBox(width: 50),
        if (discountPrice == "${Constant.systemCurrency}0")
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: CustomText(
                titleText: price.toString(),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                fontColor: Theme.of(context).colorScheme.blackColor,
                maxLines: 1,
              ),
            ),
          ),
        if (discountPrice != "${Constant.systemCurrency}0") ...[
          Expanded(
            child: Row(
              children: [
                const Spacer(),
                CustomText(
                  titleText: "${discountPrice.toString()} ",
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  fontColor: Theme.of(context).colorScheme.blackColor,
                  maxLines: 1,
                ),
                Expanded(
                  child: CustomText(
                    titleText: price.toString(),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    fontColor: Theme.of(context).colorScheme.lightGreyColor,
                    maxLines: 1,
                    showLineThrough: true,
                  ),
                ),
              ],
            ),
          ),
        ]
      ],
    );
  }

  Widget setButtons(ServiceModel service) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 84,
          height: 30,
          child: CustomIconButton(
            imgName: 'edit',
            iconColor: Theme.of(context).colorScheme.blackColor,
            titleText: "editBtnLbl".translate(context: context),
            fontSize: 12.0,
            titleColor: Theme.of(context).colorScheme.blackColor,
            borderColor: Theme.of(context).colorScheme.blackColor,
            bgColor: Colors.transparent,
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pushNamed(context, Routes.createService, arguments: {
                "service": service,
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 84,
          height: 30,
          child: CustomIconButton(
            imgName: 'delete',
            iconColor: Theme.of(context).colorScheme.blackColor,
            titleText: "deleteBtnLbl".translate(context: context),
            fontSize: 12.0,
            bgColor: Colors.transparent,
            titleColor: Theme.of(context).colorScheme.blackColor,
            borderColor: Theme.of(context).colorScheme.blackColor,
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                barrierColor: Colors.black.withOpacity(0.4),
                builder: (context) {
                  return CustomDialogs.showConfirmDialoge(
                      progressColor: Colors.white,
                      context: context,
                      showProgress:
                          context.watch<DeleteServiceCubit>().state is DeleteServiceInProgress,
                      confirmButtonColor: Colors.red,
                      confirmButtonName: "delete".translate(context: context),
                      cancleButtonName: "cancle".translate(context: context),
                      title: "deleteService".translate(context: context),
                      description: "deleteServiceDescription".translate(context: context),
                      onConfirmed: () {
                        //
                        if (Constant.isDemoModeEnable) {
                          UiUtils.showDemoModeWarning(context: context);
                          return;
                        }
                        //
                        //delete service from here
                        context.read<DeleteServiceCubit>().deleteService(
                          int.parse(service.id!),
                          onDelete: () {
                            Navigator.pop(context);
                          },
                        );
                      },
                      onCancled: () {});
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;

/*  Widget addServicesButton() {
    return FloatingActionButton(
      backgroundColor: ColorPrefs.darkGrayColor,
      elevation: 0.0,
      child: const Icon(
        Icons.add_rounded,
        size: 40,
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.createService);
      }, //open Add service Screen
    );
  } */
}
