import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cubits/fetchCategoriesCubit.dart';
import '../../data/model/categoryModel.dart';
import '../../utils/colorPrefs.dart';
import '../../utils/responsiveSize.dart';
import '../../utils/uiUtils.dart';
import '../widgets/customContainer.dart';
import '../widgets/customShimmerContainer.dart';
import '../widgets/customText.dart';
import '../widgets/error_container.dart';
import '../widgets/no_data_container.dart';
import '../widgets/shimmerLoadingContainer.dart';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  CategoriesState createState() => CategoriesState();
  static Route<Categories> route(RouteSettings routeSettings) {
    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => FetchCategoriesCubit(),
        child: const Categories(),
      ),
    );
  }
}

class CategoriesState extends State<Categories> {
  DateTime currDate = DateTime.now();
  TimeOfDay currTime = TimeOfDay.now();
  late final ScrollController _pageScrollcontroller = ScrollController()
    ..addListener(_pageScrollListen);
  late Map categoryStatus = {
    "0": "deActive".translate(context: context),
    "1": "active".translate(context: context),
  };

  _pageScrollListen() {
    if (_pageScrollcontroller.isEndReached()) {
      if (context.read<FetchCategoriesCubit>().hasMoreCategories()) {
        context.read<FetchCategoriesCubit>().fetchMoreCategories();
      }
    }
  }

  @override
  void initState() {
    context.read<FetchCategoriesCubit>().fetchCategories();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    categoryStatus = {
      "0": "deActive".translate(context: context),
      "1": "active".translate(context: context),
    };
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        title: CustomText(
          titleText: "categoriesLbl".translate(context: context),
          fontColor: Theme.of(context).colorScheme.blackColor,
        ),
        leading: UiUtils.setBackArrow(context),
      ),
      body: mainWidget(),
    );
  }

  Widget mainWidget() {
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      physics: const AlwaysScrollableScrollPhysics(),
      child: BlocBuilder<FetchCategoriesCubit, FetchCategoriesState>(
        builder: (context, state) {
          if (state is FetchCategoriesInProgress) {
            return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: 8,
                physics: const NeverScrollableScrollPhysics(),
                clipBehavior: Clip.none,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ShimmerLoadingContainer(
                        child: CustomShimmerContainer(
                      height: MediaQuery.of(context).size.height * 0.19,
                    )),
                  );
                });
          }
          if (state is FetchCategoriesFailure) {
            return Center(
                child: ErrorContainer(
                    onTapRetry: () {
                      context.read<FetchCategoriesCubit>().fetchCategories();
                    },
                    errorMessage: state.errorMessage.toString()));
          }

          if (state is FetchCategoriesSuccess) {
            if (state.categories.isEmpty) {
              return NoDataContainer(titleKey: "noDataFound".translate(context: context));
            }
            return Column(
              children: [
                ListView.separated(
                  controller: _pageScrollcontroller,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemCount: state.categories.length,
                  physics: const NeverScrollableScrollPhysics(),
                  clipBehavior: Clip.none,
                  itemBuilder: (context, index) {
                    CategoryModel categorie = state.categories[index];
                    return GestureDetector(
                      onTap: () {},
                      child: CustomContainer(
                          height: 115.rh(context),
                          padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                          bgColor: Theme.of(context).colorScheme.secondaryColor,
                          cornerRadius: 10,
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            SizedBox(
                                width: 83.rw(context),
                                child: setImage(image: categorie.categoryImage!)),
                            const SizedBox(width: 9),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, //.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CustomText(
                                      titleText: categorie.name!,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontColor: Theme.of(context).colorScheme.blackColor,
                                    ),
                                    setCommissionAndStatus(
                                      lhs: "adminCommLbl".translate(context: context),
                                      rhs: categorie.adminCommission!,
                                    ),
                                    setCommissionAndStatus(
                                      lhs: "statusLbl".translate(context: context),
                                      rhs: categoryStatus[categorie.status],
                                    ),
                                    Container()
                                  ],
                                ),
                              ),
                            )
                          ])),
                    );
                  },
                  separatorBuilder: ((context, index) => SizedBox(
                        height: 10.rh(context),
                      )),
                ),
                if ((state).isLoadingMoreCategories)
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.headingFontColor,
                  )
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget setImage({required String image}) {
    return Center(
        child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: UiUtils.setNetworkImage(image, ww: 90, hh: 110)));
  }

  Widget setCommissionAndStatus({required String lhs, required String rhs}) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            titleText: lhs,
            fontSize: 13,
            fontWeight: FontWeight.w400,
            fontColor: Theme.of(context).colorScheme.blackColor,
          ),
          CustomText(
            titleText:
                (lhs == "adminCommLbl".translate(context: context)) ? rhs.formatPercentage() : rhs,
            fontWeight: (lhs == "adminCommLbl".translate(context: context))
                ? FontWeight.w700
                : FontWeight.w400,
            fontSize: 13,
            fontColor: Theme.of(context).colorScheme.blackColor,
          )
        ],
      ),
    );
  }

  Widget setDateTime({required String date, required String time}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        setIconAndText(
          iconName: 'b_clock', //'b_calendar',
          txtVal: date,
        ), // use categoryList[index]['date']
        const SizedBox(width: 10),
        setIconAndText(iconName: 'b_clock', txtVal: time), //use categoryList[index]['time']
      ],
    );
  }

  Widget setIconAndText({required String iconName, required String txtVal}) {
    return Row(
      children: [
        UiUtils.setSVGImage(iconName),
        const SizedBox(width: 2),
        CustomText(
          titleText: txtVal, //'formatted date',
          fontSize: 12,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w400,
          fontColor: Theme.of(context).colorScheme.blackColor,
        )
      ],
    );
  }
}
