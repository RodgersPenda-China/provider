import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/cubits/fetchServiceCategoryCubit.dart';
import '../../../data/model/categoryModel.dart';
import '../../../data/model/service_filter_model.dart';
import '../../../utils/colorPrefs.dart';
import '../../../utils/uiUtils.dart';
import '../no_data_container.dart';

class FilterByBottomSheet extends StatefulWidget {
  final double minRange;
  final double maxRange;
  final double selectedMinRange;
  final double selectedMaxRange;
  final String? selectedRating;

  const FilterByBottomSheet(
      {Key? key,
      required this.minRange,
      required this.maxRange,
      required this.selectedMaxRange,
      required this.selectedMinRange,
      this.selectedRating})
      : super(key: key);

  @override
  State<FilterByBottomSheet> createState() => _FilterByBottomSheetState();
}

class _FilterByBottomSheetState extends State<FilterByBottomSheet> {
  late String selectedRating = widget.selectedRating ?? "All";
  late double startRange = widget.minRange;
  late double endRange = widget.maxRange;
  List<CategoryModel>? selectedCategories;
  late var filterPriceRange = RangeValues(widget.selectedMinRange, widget.selectedMaxRange);
  List ratingFilterValues = ["All", "1", "2", "3", "4", "5"];

  _getCategoryNames() {
    List<String?>? categoriesName = selectedCategories?.map((category) => category.name).toList();

    return categoriesName?.join(",");
  }

  Widget _getBottomSheetTitle() {
    return Center(
      child: Text(
        "filter".translate(context: context),
        style: TextStyle(
            color: Theme.of(context).colorScheme.headingFontColor,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.normal,
            fontSize: 24.0),
      ),
    );
  }

  Widget _getTitle(String title) {
    // Category
    return Text(title,
        style: TextStyle(
            color: Theme.of(context).colorScheme.blackColor,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 16.0),
        textAlign: TextAlign.left);
  }

  Widget _showSelectedCategory() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // All categories
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.80,
          child: Text(
              selectedCategories == null
                  ? "allCategories".translate(context: context)
                  : _getCategoryNames(),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.lightGreyColor,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.left),
        ),
        // Edit
        InkWell(
          onTap: () async {
            selectedCategories = await showModalBottomSheet(
              context: context,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              builder: (context) {
                return CategoryBottomSheet(
                  initialySelected: selectedCategories,
                );
              },
            );
            setState(() {});
          },
          child: Text("edit".translate(context: context),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.headingFontColor,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0,
                  decoration: TextDecoration.underline),
              textAlign: TextAlign.right),
        )
      ],
    );
  }

  Widget _getBudgetFilterLableAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getTitle("budget".translate(context: context)),
        Text(
            "${UiUtils.getPriceFormat(context, double.parse(filterPriceRange.start.toStringAsFixed(2)))}-${UiUtils.getPriceFormat(context, double.parse(filterPriceRange.end.toStringAsFixed(2)))}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.headingFontColor,
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.normal,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.right)
      ],
    );
  }

  Widget _getBudgetFilterRangeSlider() {
    return RangeSlider(
        activeColor: Theme.of(context).colorScheme.headingFontColor,
        inactiveColor: Theme.of(context).colorScheme.headingFontColor.withOpacity(0.4),
        values: filterPriceRange,
        max: widget.maxRange,
        min: widget.minRange,
        onChanged: (newValue) {
          filterPriceRange = newValue;

          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryColor,
                  borderRadius: const BorderRadiusDirectional.only(
                      topEnd: Radius.circular(20), topStart: Radius.circular(20))),
              child: _getBottomSheetTitle(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      _getTitle("category".translate(context: context)),
                      const Spacer(),
                      if (selectedCategories != null) ...[
                        GestureDetector(
                          onTap: () {
                            //reset
                            selectedCategories = null;
                            setState(() {});
                          },
                          child: Text(
                            "clear".translate(context: context),
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Theme.of(context).colorScheme.headingFontColor,
                                fontSize: 12),
                          ),
                        )
                      ]
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _showSelectedCategory(),
                  const SizedBox(
                    height: 5,
                  ),

                  if (widget.maxRange > 1) ...{
                    Divider(color: Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.4)),
                    const SizedBox(
                      height: 5,
                    ),
                    _getBudgetFilterLableAndPrice(),
                    const SizedBox(
                      height: 5,
                    ),
                    _getBudgetFilterRangeSlider(),
                  },
                  const SizedBox(
                    height: 5,
                  ),
                  Divider(color: Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.4)),

                  // _showCurrentLocationContainer(),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _getTitle("rating".translate(context: context)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: _getRatingFilterValues(),
        ),
        const Spacer(),
        _showCloseAndApplyButton(),
      ],
    );
  }

  Widget _getRatingFilterValues() {
    return Container(
      padding: const EdgeInsetsDirectional.only(top: 15.0),
      height: 45,
      width: double.infinity,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: List.generate(
            ratingFilterValues.length,
            (index) => GestureDetector(
                  onTap: () {
                    selectedRating = ratingFilterValues[index];
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsetsDirectional.only(
                      end: 15.0,
                    ),
                    width: 70,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(7)),
                        color: ratingFilterValues[index] == selectedRating
                            ? Theme.of(context).colorScheme.headingFontColor
                            : null,
                        border: Border.all(
                            color: ratingFilterValues[index] == selectedRating
                                ? Theme.of(context).colorScheme.headingFontColor
                                : Theme.of(context).colorScheme.blackColor.withOpacity(0.4),
                            width: 1)),
                    child: Center(
                      child: Text("★ ${ratingFilterValues[index]}",
                          style: TextStyle(
                              color: ratingFilterValues[index] == selectedRating
                                  ? Theme.of(context).colorScheme.primaryColor
                                  : null,
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.normal,
                              fontSize: 14.0),
                          textAlign: TextAlign.center),
                    ),
                  ),
                )),
      ),
    );
  }

  Widget _showCloseAndApplyButton() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                height: 44,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryColor),
                child: Center(
                  child: Text(
                    "close".translate(context: context),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              ServiceFilterDataModel? filterModel;
              if (selectedCategories?.length == 1) {
                filterModel = ServiceFilterDataModel(
                    rating: selectedRating,
                    categoryId: selectedCategories?[0].id.toString(),
                    maxBudget: (filterPriceRange.end).toString(),
                    minBudget: filterPriceRange.start.toString());
              } else if (selectedCategories?.isNotEmpty ?? false) {
                if (selectedCategories!.length > 1) {
                  String categoryIDs = selectedCategories!.map((e) => e.id).toList().join(",");
                  filterModel = ServiceFilterDataModel(
                      rating: selectedRating,
                      caetgoryIds: categoryIDs,
                      maxBudget: (filterPriceRange.end).toString(),
                      minBudget: filterPriceRange.start.toString());
                }
              } else {
                filterModel = ServiceFilterDataModel(
                    rating: selectedRating.toLowerCase() == "all" ? null : selectedRating,
                    maxBudget: (filterPriceRange.end).toString(),
                    minBudget: filterPriceRange.start.toString());
              }

              Navigator.pop(context, filterModel);
            },
            child: Container(
                height: 44,
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                      color: Color(0x1c343f53),
                      offset: Offset(0, -3),
                      blurRadius: 10,
                      spreadRadius: 0)
                ], color: Theme.of(context).colorScheme.headingFontColor),
                child: // Apply Filter
                    Center(
                  child: Text(
                    "applyfilter".translate(context: context),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryColor,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                )),
          ),
        )
      ],
    );
  }
}

class CategoryBottomSheet extends StatefulWidget {
  final List<CategoryModel>? initialySelected;

  const CategoryBottomSheet({Key? key, this.initialySelected}) : super(key: key);

  @override
  State<CategoryBottomSheet> createState() => _CategoryBottomSheetState();
}

class _CategoryBottomSheetState extends State<CategoryBottomSheet> {
  late List<CategoryModel> selectedCategory = widget.initialySelected ?? [];
  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(_pageScrollListen);

  _pageScrollListen() {
    if (_pageScrollController.isEndReached()) {
      if (context.read<FetchServiceCategoryCubit>().hasMoreData()) {
        context.read<FetchServiceCategoryCubit>().fetchMoreCategories();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .77,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryColor,
                borderRadius: const BorderRadiusDirectional.only(
                    topEnd: Radius.circular(20), topStart: Radius.circular(20))),
            child: Center(
              child: Text("category".translate(context: context),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.blackColor,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 24.0),
                  textAlign: TextAlign.center),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              //clipBehavior: Clip.none,
              child: BlocBuilder<FetchServiceCategoryCubit, FetchServiceCategoryState>(
                builder: (context, state) {
                  if (state is FetchServiceCategoryInProgress) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.headingFontColor,
                      ),
                    );
                  }

                  if (state is FetchServiceCategorySuccess) {
                    if (state.serviceCategories.isEmpty) {
                      return NoDataContainer(titleKey: "noDataFound".translate(context: context));
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.serviceCategories.length,
                            itemBuilder: (context, int i) {
                              return recursiveExpansionList(
                                state.serviceCategories[i].toJson(),
                              );
                            }),
                        if (state.isLoadingMoreServicesCategory)
                          CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.headingFontColor,
                          )
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
          _showCloseAndApplyButton(),
        ],
      ),
    );
  }

  Widget _showCloseAndApplyButton() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                height: 44,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.secondaryColor),
                child: Center(
                  child: Text(
                    "close".translate(context: context),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.blackColor,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.pop(context, selectedCategory);
            },
            child: Container(
                height: 44,
                decoration: BoxDecoration(boxShadow: const [
                  BoxShadow(
                      color: Color(0x1c343f53),
                      offset: Offset(0, -3),
                      blurRadius: 10,
                      spreadRadius: 0)
                ], color: Theme.of(context).colorScheme.headingFontColor),
                child: // Apply Filter
                    Center(
                  child: Text(
                    "apply".translate(context: context),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondaryColor,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 14.0),
                  ),
                )),
          ),
        )
      ],
    );
  }

  Widget recursiveExpansionList(Map map) {
    List subList = [];
    subList = map["subCategory"] ?? [];
    bool contains = selectedCategory
        .where(((element) {
          return element.id == map['id'];
        }))
        .toSet()
        .isNotEmpty;
    if (subList.isNotEmpty) {
      if (map["level"] == 0) {
        return ExpansionTile(
          title: Text(
            map['name'],
          ),
          children: subList.map((e) => recursiveExpansionList(e)).toList(),
        );
      } else {
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 15.0),
          child: ExpansionTile(
            title: Text(map['name']),
            children: subList.map((e) => recursiveExpansionList(e)).toList(),
          ),
        );
      }
    } else {
      if (map["level"] == 0) {
        return ListTile(
          title: Text(map['name']),
          leading: Checkbox(
              value: contains,
              fillColor: MaterialStateProperty.all(Theme.of(context).colorScheme.headingFontColor),
              onChanged: (bool? val) {
                CategoryModel categoryModel = CategoryModel(
                  id: map['id'],
                  name: map['name'],
                );
                if (contains) {
                  selectedCategory.removeWhere((e) => e.id == map['id']);
                } else {
                  selectedCategory.add(categoryModel);
                }

                setState(() {});
              }),
        );
      } else {
        return Padding(
          padding: const EdgeInsetsDirectional.only(start: 15.0),
          child: ListTile(
            onTap: () {
              CategoryModel categoryModel = CategoryModel(
                id: map['id'],
                name: map['name'],
              );
              if (contains) {
                selectedCategory.removeWhere((e) => e.id == map['id']);
              } else {
                selectedCategory.add(categoryModel);
              }

              setState(() {});
            },
            title: Text(map['name']),
            leading: Checkbox(
                fillColor:
                    MaterialStateProperty.all(Theme.of(context).colorScheme.headingFontColor),
                value: contains,
                onChanged: (val) {
                  CategoryModel categoryModel = CategoryModel(
                    id: map['id'],
                    name: map['name'],
                  );
                  if (contains) {
                    selectedCategory.removeWhere((e) => e.id == map['id']);
                  } else {
                    selectedCategory.add(categoryModel);
                  }

                  setState(() {});
                }),
          ),
        );
      }
    }
  }
}
