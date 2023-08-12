import 'package:cached_network_image/cached_network_image.dart';
import 'package:edemand_partner/data/cubits/fetchTaxesCubit.dart';
import 'package:edemand_partner/data/cubits/fetch_services_Cubit.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/cubits/create_service_cubit.dart';
import '../../../data/cubits/fetchServiceCategoryCubit.dart';
import '../../../data/model/create_service_model.dart';
import '../../../data/model/service_model.dart';
import '../../../utils/colorPrefs.dart';
import '../../../utils/dialogs.dart';
import '../../../utils/imagePicker.dart';
import '../../../utils/responsiveSize.dart';
import '../../../utils/uiUtils.dart';
import '../../../utils/validation.dart';
import '../../widgets/customContainer.dart';
import '../../widgets/customRoundButton.dart';
import '../../widgets/customText.dart';
import '../../widgets/error_container.dart';
import '../../widgets/formDropdownField.dart';
import '../../widgets/no_data_container.dart';
import '../../widgets/pageNumberIndicator.dart';
import '../../widgets/setDottedBorderWithHint.dart';

class CreateService extends StatefulWidget {
  final ServiceModel? service;

  const CreateService({
    Key? key,
    this.service,
  }) : super(key: key);

  @override
  CreateServiceState createState() => CreateServiceState();

  static Route<CreateService> route(RouteSettings routeSettings) {
    Map? arguments = routeSettings.arguments as Map?;

    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => CreateServiceCubit(),
        child: CreateService(service: arguments?['service']),
      ),
    );
  }
}

class CreateServiceState extends State<CreateService> {
  int currIndex = 1;
  int totalForms = 2;

  //form 1
  bool isOnSiteAllowed = false;
  bool isPayLaterAllowed = false;
  bool isCancelAllowed = false;

  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();

  ScrollController scrollController = ScrollController();

  late TextEditingController serviceTitleController = TextEditingController(
    text: widget.service?.title,
  );
  late TextEditingController serviceTagController = TextEditingController();
  late TextEditingController serviceDescrController = TextEditingController(
    text: widget.service?.description,
  );

  // TextEditingController chooseCatController = TextEditingController();
  // TextEditingController chooseSubcatController = TextEditingController();
  late TextEditingController cancelBeforeController = TextEditingController(
    text: widget.service?.cancelableTill,
  );
  FocusNode serviceTitleFocus = FocusNode();
  FocusNode serviceTagFocus = FocusNode();
  FocusNode serviceDescrFocus = FocusNode();

  FocusNode cancelBeforeFocus = FocusNode();

  late int selectedCategory = 0; // Category = name of model instead of int
  String? selectedCategoryTitle;
  late int selectedTax = 0; // Tax = name of model instead of int
  String selectedTaxTitle = "";
  late int selectedSubCategory = 0; //Subcategory = name of model instead of int
  Map? selectedPriceType;

  //form 2
  final formKey2 = GlobalKey<FormState>();

  late TextEditingController priceController = TextEditingController(text: widget.service?.price);
  late TextEditingController discountPriceController =
      TextEditingController(text: widget.service?.discountedPrice);
  late TextEditingController memReqTaskController =
      TextEditingController(text: widget.service?.numberOfMembersRequired);
  late TextEditingController durationTaskController =
      TextEditingController(text: widget.service?.duration);
  late TextEditingController qtyAllowedTaskController =
      TextEditingController(text: widget.service?.maxQuantityAllowed);

  FocusNode priceFocus = FocusNode();
  FocusNode discountPriceFocus = FocusNode();
  FocusNode memReqTaskFocus = FocusNode();
  FocusNode durationTaskFocus = FocusNode();
  FocusNode qtyAllowedTaskFocus = FocusNode();

  List<String> tagsList = [];
  List<Map<String, dynamic>> finalTagList = [];
  PickImage imagePicker = PickImage();
  Map priceTypeFilter = {"0": "included", "1": "excluded"};

  void _chooseImaeg() {
    imagePicker.pick();
  }

  @override
  void initState() {
    super.initState();

    selectedCategory = int.parse((widget.service?.categoryId) ?? "0");
    selectedCategoryTitle = widget.service?.categoryName;

    selectedTax = int.parse((widget.service?.taxId) ?? "0");
    selectedTaxTitle = widget.service?.taxId == null
        ? ""
        : "${widget.service?.taxTitle} (${widget.service?.taxPercentage}%)";

    if (widget.service?.isCancelable != null) {
      isCancelAllowed = widget.service?.isCancelable == "0" ? false : true;
    }
    if (widget.service?.isPayLaterAllowed != null) {
      isPayLaterAllowed = widget.service?.isPayLaterAllowed == "0" ? false : true;
    }

    if (widget.service?.tags?.isEmpty ?? false) {
      tagsList = [];
    } else {
      tagsList = widget.service?.tags?.split(",") ?? [];
    }
  }

  @override
  void didChangeDependencies() {
    if (widget.service?.taxType == "included") {
      selectedPriceType = {'title': "taxIncluded".translate(context: context), 'value': '0'};
    } else {
      selectedPriceType = {'title': "taxExcluded".translate(context: context), 'value': '1'};
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (tagsList.isNotEmpty) {
      finalTagList = List.generate(
        tagsList.length,
        (index) {
          return {
            "id": index,
            "text": tagsList[index],
          };
        },
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        title: CustomText(
          titleText: widget.service?.id != null
              ? "editServiceLabel".translate(context: context)
              : "createServiceTxtLbl".translate(context: context),
          fontColor: Theme.of(context).colorScheme.blackColor,
        ),
        leading: UiUtils.setBackArrow(context),
        actions: <Widget>[PageNumberIndicator(currentIndex: currIndex, total: totalForms)],
      ),
      bottomNavigationBar: bottomNavigation(),
      body: screenBuilder(currIndex),
    );
  }

  Widget screenBuilder(int currentPage) {
    Widget currentForm = form1(); //default form1
    switch (currIndex) {
      case 2:
        currentForm = form2();
        break;
      default:
        currentForm = form1();
        break;
    }
    return SingleChildScrollView(
      clipBehavior: Clip.none,
      padding: const EdgeInsets.all(15),
      controller: scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: currentForm,
    );
  }

  Widget form1() {
    return Form(
        key: formKey1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UiUtils.setTitleAndTFF(
              context,
              titleText: "serviceTitleLbl".translate(context: context),
              controller: serviceTitleController,
              currNode: serviceTitleFocus,
              backgroundColor: Theme.of(context).colorScheme.secondaryColor,
              validator: (value) {
                return Validator.nullCheck(value);
              },
              nextFocus: serviceTagFocus,
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "serviceTagLbl".translate(context: context),
              controller: serviceTagController,
              currNode: serviceTagFocus,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-z0-9]'))],
              backgroundColor: Theme.of(context).colorScheme.secondaryColor,
              forceUnfocus: false,
              bottomPadding: finalTagList.isEmpty ? 15 : 0,
              onSubmit: () {
                if (serviceTagController.text.isNotEmpty) {
                  tagsList.add(serviceTagController.text);
                }
                serviceTagController.text = "";
                setState(() {});
              },
              callback: () {},
            ),
            Wrap(
              children: finalTagList.map(
                (item) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(2, 2, 2, 0),
                    child: Chip(
                      label: Text(item['text']),
                      onDeleted: () {
                        if (tagsList.isEmpty) {
                          tagsList.clear();
                          finalTagList.clear();
                          setState(() {});
                          return;
                        }
                        tagsList.removeAt(item['id']);
                        if (tagsList.isEmpty) {
                          finalTagList.clear();
                        }
                        setState(() {});
                      },
                      labelStyle: TextStyle(color: Theme.of(context).colorScheme.blackColor),
                      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Theme.of(context).colorScheme.blackColor)),
                    ),
                  );
                },
              ).toList(),
            ),
            if (tagsList.isNotEmpty) const SizedBox(height: 10),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "serviceDescrLbl".translate(context: context),
              controller: serviceDescrController,
              expands: true,
              minLines: 5,
              currNode: serviceDescrFocus,
              validator: (value) {
                return Validator.nullCheck(value);
              },
              backgroundColor: Theme.of(
                context,
              ).colorScheme.secondaryColor,
              textInputType: TextInputType.multiline,
            ),
            _selectDropdown(
              title: selectedCategoryTitle ?? "selectCategoryLbl".translate(context: context),
              onSelect: () {
                selectCategoryBottomSheet();
              },
              validator: (value) {
                if (selectedCategoryTitle == null) {
                  return "pleaseChooseCategory".translate(context: context);
                }
                return null;
              },
            ),
            SizedBox(
              height: 10.rh(context),
            ),
            setTitleAndSwitch(
                titleText: "payLaterAllowedLbl".translate(context: context),
                isAllowed: isPayLaterAllowed),
            SizedBox(
              height: 10.rh(context),
            ),
            setTitleAndSwitch(
                titleText: "isCancelableLbl".translate(context: context),
                isAllowed: isCancelAllowed),
            if (isCancelAllowed) ...[
              const SizedBox(height: 10),
              UiUtils.setTitleAndTFF(context,
                  titleText: "cancelableBeforeLbl".translate(context: context),
                  controller: cancelBeforeController,
                  currNode: cancelBeforeFocus,
                  textInputType: TextInputType.number,
                  hintText: '30', validator: (value) {
                return Validator.nullCheck(value);
              },
                  backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                  prefix: minutesPrefixWidget())
            ]
          ],
        ));
  }

  Widget _selectDropdown({
    required String title,
    VoidCallback? onSelect,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      readOnly: true,
      validator: validator,
      onTap: onSelect,
      style: TextStyle(
        fontSize: 12,
        color: Theme.of(context).colorScheme.blackColor,
      ),
      controller: TextEditingController(
        text: title,
      ),
      decoration: InputDecoration(
        errorStyle: const TextStyle(fontSize: 12),
        fillColor: Theme.of(context).colorScheme.secondaryColor,
        filled: true,
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Theme.of(context).colorScheme.headingFontColor,
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.headingFontColor),
            borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.headingFontColor),
            borderRadius: BorderRadius.circular(12)),
        border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).colorScheme.blackColor),
            borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget form2() {
    return BlocConsumer<CreateServiceCubit, CreateServiceCubitState>(
      listener: (context, state) {
        if (state is CreateServiceFailure) {
          UiUtils.showMessage(context, state.errorMessage, MessageType.error);
        }

        if (state is CreateServiceSuccess) {
          UiUtils.showMessage(
              context,
              widget.service?.id != null
                  ? "serviceEditedSuccessfully".translate(context: context)
                  : "succesCreatedService".translate(context: context),
              MessageType.success, onMessageClosed: () {
            Navigator.pop(context);
            context.read<FetchServicesCubit>().fetchServices();
          });
        }
      },
      builder: (context, state) {
        return Form(
            key: formKey2,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomText(
                    titleText: "serviceImgLbl".translate(context: context),
                    fontColor: Theme.of(context).colorScheme.blackColor,
                  ),
                  imagePicker.ListenImageChange(
                    (context, image) {
                      if (image == null) {
                        if (widget.service?.imageOfTheService != null) {
                          return Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: GestureDetector(
                              onTap: _chooseImaeg,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: 200.rh(context),
                                child: CachedNetworkImage(
                                    imageUrl: widget.service!.imageOfTheService!),
                              ),
                            ),
                          );
                        }
                        return Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: InkWell(
                            onTap: _chooseImaeg,
                            child: SetDottedBorderWithHint(
                                height: 100,
                                width: MediaQuery.of(context).size.width - 35,
                                radius: 7,
                                str: "chooseImgLbl".translate(context: context),
                                strPrefix: ''),
                          ),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: GestureDetector(
                          onTap: _chooseImaeg,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: 200.rh(context),
                              child: Image.file(image)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  buildDropDown(context,
                      title: "priceType".translate(context: context),
                      initialValue: (widget.service?.taxType?.firstUpperCase()) ??
                          "select".translate(context: context), onTap: () {
                    selectTaxOption();
                  }, value: selectedPriceType?['title']),
                  const SizedBox(height: 15),
                  _selectDropdown(
                    title: selectedTaxTitle == ""
                        ? "selectTax".translate(context: context)
                        : selectedTaxTitle,
                    onSelect: () {
                      selectTaxesBottomSheet();
                    },
                    validator: (value) {
                      if (selectedTaxTitle == null) {
                        return "pleaseSelectTax".translate(context: context);
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  setPriceAndDicountedPrice(),
                  UiUtils.setTitleAndTFF(context,
                      titleText: "membersForTaskLbl".translate(context: context),
                      controller: memReqTaskController,
                      currNode: memReqTaskFocus,
                      nextFocus: durationTaskFocus, validator: (value) {
                    return Validator.nullCheck(value);
                  },
                      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                      textInputType: TextInputType.number),
                  UiUtils.setTitleAndTFF(context,
                      titleText: "durationForTaskLbl".translate(context: context),
                      controller: durationTaskController,
                      currNode: durationTaskFocus,
                      nextFocus: qtyAllowedTaskFocus,
                      hintText: '120', validator: (value) {
                    return Validator.nullCheck(value);
                  },
                      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                      prefix: minutesPrefixWidget(),
                      textInputType: TextInputType.number),
                  UiUtils.setTitleAndTFF(context,
                      titleText: "maxQtyAllowedLbl".translate(context: context),
                      controller: qtyAllowedTaskController,
                      currNode: qtyAllowedTaskFocus,
                      backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                      validator: (value) {
                    return Validator.nullCheck(value);
                  }, textInputType: TextInputType.number),
                ]));
      },
    );
  }

  Widget buildDropDown(BuildContext context,
      {required String title,
      required VoidCallback onTap,
      required String initialValue,
      String? value}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
            fontColor: Theme.of(context).colorScheme.blackColor,
            titleText: title,
            fontWeight: FontWeight.w400,
            fontSize: 16.0),
        SizedBox(
          height: 10.rh(context),
        ),
        CustomFormDropdown(
          onTap: () {
            onTap.call();
          },
          initialTitle: initialValue,
          selectedValue: value,
          validator: (p0) {
            return Validator.nullCheck(p0);
          },
        ),
      ],
    );
  }

  Widget setPriceAndDicountedPrice() {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
            child: UiUtils.setTitleAndTFF(context,
                titleText: "priceLbl".translate(context: context),
                controller: priceController,
                backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                currNode: priceFocus,
                prefix: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 15, end: 15),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            titleText: Constant.systemCurrency ?? "",
                            fontSize: 15.0,
                            fontColor: Theme.of(context).colorScheme.blackColor,
                          ),
                          VerticalDivider(
                            color: Theme.of(context).colorScheme.blackColor.withAlpha(150),
                            thickness: 1,
                          ),
                        ],
                      ),
                    )),
                nextFocus: discountPriceFocus, validator: (value) {
          return Validator.nullCheck(value);
        }, textInputType: TextInputType.number)),
        const SizedBox(width: 20),
        Flexible(
            child: UiUtils.setTitleAndTFF(context,
                titleText: "discountPriceLbl".translate(context: context),
                controller: discountPriceController,
                currNode: discountPriceFocus,
                prefix: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 15, end: 15),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                            titleText: Constant.systemCurrency ?? "",
                            fontSize: 15.0,
                            fontColor: Theme.of(context).colorScheme.blackColor,
                          ),
                          VerticalDivider(
                            color: Theme.of(context).colorScheme.blackColor.withAlpha(150),
                            thickness: 1,
                          ),
                        ],
                      ),
                    )), validator: (value) {
          if (num.parse(value!) > num.parse(priceController.text)) {
            return "discountBiger".translate(context: context);
          } else if (num.parse(value) == num.parse(priceController.text)) {
            return "discountPriceCanNotBeEqualToPrice".translate(context: context);
          }

          return Validator.nullCheck(value);
        },
                backgroundColor: Theme.of(context).colorScheme.secondaryColor,
                textInputType: TextInputType.number)),
      ],
    );
  }

  Widget minutesPrefixWidget() {
    return Padding(
        padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomText(
                titleText: "minutesLbl".translate(context: context),
                fontSize: 15.0,
                fontColor: Theme.of(context).colorScheme.blackColor,
              ),
              VerticalDivider(
                color: Theme.of(context).colorScheme.blackColor.withAlpha(150),
                thickness: 1,
              ),
            ],
          ),
        ));
  }

//category list modal bottom Sheet
  selectCategoryBottomSheet() {
    return UiUtils.showBottomSheet(
        context: context,
        enableDrag: true,
        child: BlocBuilder<FetchServiceCategoryCubit, FetchServiceCategoryState>(
          builder: (context, state) {
            if (state is FetchServiceCategoryFailure) {
              return Center(
                  child: ErrorContainer(
                      showRetryButton: false,
                      onTapRetry: () {},
                      errorMessage: state.errorMessage.toString()));
            }
            if (state is FetchServiceCategorySuccess) {
              if (state.serviceCategories.isEmpty) {
                return NoDataContainer(titleKey: "noDataFound".translate(context: context));
              }
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                  minHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      child: Text(
                        "chooseCategory".translate(context: context),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.headingFontColor,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      //clipBehavior: Clip.none,
                      child: Column(
                          children: List.generate(
                        state.serviceCategories.length,
                        (index) => listWidget(
                            title: state.serviceCategories[index].name!.toUpperCase(),
                            isSelected: selectedCategory ==
                                int.parse(state.serviceCategories[index].id ?? "0"),
                            onTap: () {
                              selectedCategory = int.parse(state.serviceCategories[index]
                                  .id!); //pass complete Category model instead of id

                              selectedCategoryTitle = state.serviceCategories[index].name;
                              setState(() {});

                              Navigator.of(context).pop();
                            }),
                      )),
                    )),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.headingFontColor,
              ),
            );
          },
        ));
  }

//taxes modal bottom Sheet
  selectTaxesBottomSheet() {
    return UiUtils.showBottomSheet(
        context: context,
        enableDrag: true,
        child: BlocBuilder<FetchTaxesCubit, FetchTaxesState>(
          builder: (context, state) {
            if (state is FetchTaxesFailure) {
              return Center(
                  child: ErrorContainer(
                      showRetryButton: false,
                      onTapRetry: () {},
                      errorMessage: state.errorMessage.toString()));
            }
            if (state is FetchTaxesSuccess) {
              if (state.taxes.isEmpty) {
                return NoDataContainer(titleKey: "noDataFound".translate(context: context));
              }

              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.75,
                  minHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      child: Text(
                        "chooseTaxes".translate(context: context),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.headingFontColor,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                          children: List.generate(
                        state.taxes.length,
                        (index) {
                          return listWidget(
                              title:
                                  "${state.taxes[index].title!.toUpperCase()} (${state.taxes[index].percentage}%)",
                              isSelected: selectedTax == int.parse(state.taxes[index].id ?? "0"),
                              onTap: () {
                                selectedTax = int.parse(state
                                    .taxes[index].id!); //pass complete Category model instead of id
                                selectedTaxTitle =
                                    "${state.taxes[index].title} (${state.taxes[index].percentage}%)";
                                setState(() {});
                                Navigator.of(context).pop();
                              });
                        },
                      )),
                    )),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.headingFontColor,
              ),
            );
          },
        ));
  }

  Future<void> selectTaxOption() async {
    Map? result = await showDialog<Map>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialogs.showSelectDialoge(
            selectedValue: selectedPriceType?['value'],
            itemList: <Map>[
              {'title': "taxIncluded".translate(context: context), 'value': '0'},
              {'title': "taxExcluded".translate(context: context), 'value': '1'}
            ]);
      },
    );
    selectedPriceType = result;
    setState(() {});
  }

  listWidget({required String title, VoidCallback? onTap, required bool isSelected}) {
    return ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: Text(title,
            style: TextStyle(
                color: Theme.of(context).colorScheme.blackColor,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.5)),
        onTap: onTap,
        trailing: //remove int.parse while using model
            Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.headingFontColor : null,
            border: Border.all(color: Theme.of(context).colorScheme.lightGreyColor),
            shape: BoxShape.circle,
          ),
          child: isSelected
              ? Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.secondaryColor,
                )
              : const SizedBox(
                  height: 25,
                  width: 25,
                ),
        ));
  }

  Widget setTitleForDropDown({
    required VoidCallback onTap,
    required String titleTxt,
    required String hintText,
    required Color bgClr,
    required Color txtClr,
    required Color arrowColor,
  }) {
    return InkWell(
      //open bottomsheet
      onTap: onTap,
      child: dropDownTextLblWithFrwdArrow(
          titleTxt: titleTxt,
          hintText: hintText,
          txtClr: txtClr,
          arrowColor: arrowColor,
          bgClr: bgClr),
    );
  }

  Widget dropDownTextLblWithFrwdArrow(
      {required String titleTxt,
      required String hintText,
      required Color bgClr,
      required Color txtClr,
      required Color arrowColor}) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(bottom: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
              fontColor: Theme.of(context).colorScheme.blackColor,
              titleText: titleTxt,
              fontWeight: FontWeight.w400,
              fontSize: 18.0),
          const SizedBox(height: 8),
          CustomContainer(
            height: MediaQuery.of(context).size.height * 0.07,
            cornerRadius: 10,
            bgColor: Theme.of(context).colorScheme.secondaryColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Text(
                    hintText,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Theme.of(context).colorScheme.blackColor,
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 10),
                  child: Icon(Icons.keyboard_arrow_down_rounded, color: arrowColor),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget setTitleAndSwitch({
    required String titleText,
    required bool isAllowed,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CustomText(
              titleText: titleText,
              fontWeight: FontWeight.w400,
              fontColor: Theme.of(context).colorScheme.blackColor,
              fontSize: 16.0),
        ),
        CupertinoSwitch(
            value: isAllowed,
            onChanged: (val) {
              // isAllowed = !isAllowed; //val;
              if (titleText == "payLaterAllowedLbl".translate(context: context)) {
                isPayLaterAllowed = val;
              } else if (titleText == "isCancelableLbl".translate(context: context)) {
                isCancelAllowed = val;
              }

              setState(() {});
            })
      ],
    );
  }

  bottomNavigation() {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (currIndex > 1) Expanded(child: nextPrevBtnWidget(false)),
          const SizedBox(width: 5),
          Expanded(child: nextButton()),
        ]),
      ),
    );
  }

  nextButton() {
    Widget? child;
    if (context.watch<CreateServiceCubit>().state is CreateServiceInProgress) {
      child = CircularProgressIndicator(
        color: Theme.of(context).colorScheme.primaryColor,
      );
    }

    return CustomRoundedButton(
      textSize: 15,
      widthPercentage: 1,
      backgroundColor: Theme.of(context).colorScheme.headingFontColor,
      buttonTitle: currIndex == 1
          ? "nxtBtnLbl".translate(context: context)
          : widget.service?.id != null
              ? "editServiceBtnLbl".translate(context: context)
              : "addServiceBtnLbl".translate(context: context),
      showBorder: false,
      onTap: () {
        UiUtils.removeFocus();
        onNextPrevBtnClick(true);
      },
      child: child,
    );
  }

  nextPrevBtnWidget(bool isNext) {
    return CustomRoundedButton(
      showBorder: true,
      borderColor: isNext ? Colors.transparent : Theme.of(context).colorScheme.headingFontColor,
      radius: 8,
      textSize: 15,
      buttonTitle: isNext && currIndex >= totalForms
          ? "addServiceBtnLbl".translate(context: context)
          : isNext
              ? "nxtBtnLbl".translate(context: context)
              : "prevBtnLbl".translate(context: context),
      titleColor: isNext
          ? Theme.of(context).colorScheme.secondaryColor
          : Theme.of(context).colorScheme.blackColor,
      backgroundColor: isNext
          ? Theme.of(context).colorScheme.headingFontColor
          : Theme.of(context).colorScheme.primaryColor,
      widthPercentage: isNext ? 1 : 0.5,
      onTap: () {
        onNextPrevBtnClick(isNext);
      },
    );
  }

  onNextPrevBtnClick(bool isNext) async {
    if (isNext) {
      var form = formKey1.currentState; //default value
      switch (currIndex) {
        case 2:
          form = formKey2.currentState;
          break;
        default:
          form = formKey1.currentState;
          break;
      }
      if (form == null) return;

      form.save();

      if (form.validate()) {
        if (currIndex < totalForms) {
          currIndex++;
          scrollController.jumpTo(0);
          setState(() {});
        } else {
          String tagString = "";
          if (finalTagList.isNotEmpty) {
            for (var element in finalTagList) {
              tagString += "${element['text']},";
            }
            //remove last ,
            tagString = tagString.substring(0, tagString.length - 1);
          } else {
            UiUtils.showMessage(context, "pleaseAddTags", MessageType.error);
            return;
          }

          ///if serviceId is available then it will update existing service otherwise it will add
          CreateServiceModel createServiceModel = CreateServiceModel(
              serviceId: widget.service?.id,
              title: serviceTitleController.text,
              description: serviceDescrController.text,
              price: priceController.text,
              members: memReqTaskController.text,
              maxQty: qtyAllowedTaskController.text,
              duration: int.parse(
                durationTaskController.text,
              ),
              cancelableTill: cancelBeforeController.text,
              iscancelable: isCancelAllowed == false ? 0 : 1,
              is_pay_later_allowed: isPayLaterAllowed == false ? 0 : 1,
              discounted_price: int.parse(
                discountPriceController.text,
              ),
              image: imagePicker.pickedFile,
              categories: selectedCategory.toString(),
              tax_type: priceTypeFilter[selectedPriceType?['value']],
              tags: tagString,
              taxId: selectedTax.toString());

          if (imagePicker.pickedFile != null || widget.service?.imageOfTheService != null) {
            //
            if (Constant.isDemoModeEnable) {
              UiUtils.showDemoModeWarning(context: context);
              return;
            }
            //

            context.read<CreateServiceCubit>().createService(
                  createServiceModel,
                );
          } else {
            FocusScope.of(context).unfocus();
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("imageRequired".translate(context: context)),
                  content: Text("pleaseSelectImage".translate(context: context)),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("ok".translate(context: context)))
                  ],
                );
              },
            );
          }
        }
      }
    } else if (currIndex > 1) {
      currIndex--;
      setState(() {});
    }
  }
}
