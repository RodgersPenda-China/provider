// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/cubits/addOrEditProvider.dart';
import 'package:edemand_partner/data/cubits/user_info_cubit.dart';
import 'package:edemand_partner/data/model/user_details_model.dart';
import 'package:edemand_partner/ui/widgets/checkBox.dart';
import 'package:edemand_partner/ui/widgets/customRoundButton.dart';
import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/ui/widgets/dashedRect.dart';
import 'package:edemand_partner/ui/widgets/formDropdownField.dart';
import 'package:edemand_partner/ui/widgets/pageNumberIndicator.dart';
import 'package:edemand_partner/ui/widgets/setDottedBorderWithHint.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/dialogs.dart';
import 'package:edemand_partner/utils/imagePicker.dart';
import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/validation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../utils/uiUtils.dart';

class RegistrationForm extends StatefulWidget {
  final bool isEditing;

  const RegistrationForm({Key? key, required this.isEditing}) : super(key: key);

  @override
  RegistrationFormState createState() => RegistrationFormState();

  static Route<RegistrationForm> route(RouteSettings routeSettings) {
    Map<String, dynamic> parameters = routeSettings.arguments as Map<String, dynamic>;

    return CupertinoPageRoute(
      builder: (_) => BlocProvider(
        create: (context) => EditProviderDetailsCubit(),
        child: RegistrationForm(
          isEditing: parameters["isEditing"],
        ),
      ),
    );
  }
}

class RegistrationFormState extends State<RegistrationForm> with ChangeNotifier {
  int totalForms = 5;

  int currentIndex = 1;

  final formKey1 = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final formKey3 = GlobalKey<FormState>();
  final formKey4 = GlobalKey<FormState>();
  final formKey5 = GlobalKey<FormState>();

  ScrollController scrollController = ScrollController();

  ///form1
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode userNmFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode mobNoFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();

  Map<String, dynamic> pickedLocalImages = {
    "nationalIdImage": "",
    "addressIdImage": "",
    "passportIdImage": "",
    "logoImage": "",
    "bannerImage": ""
  };

  ///form2
  TextEditingController cityController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController aboutCompanyController = TextEditingController();
  TextEditingController visitingChargesController = TextEditingController();
  TextEditingController advanceBookingDaysController = TextEditingController();
  TextEditingController numberOfMemberController = TextEditingController();

  FocusNode aboutCompanyFocus = FocusNode();
  FocusNode cityFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode latitudeFocus = FocusNode();
  FocusNode longitudeFocus = FocusNode();
  FocusNode companyNmFocus = FocusNode();
  FocusNode visitingChargeFocus = FocusNode();
  FocusNode advanceBookingDaysFocus = FocusNode();
  FocusNode numberOfMemberFocus = FocusNode();
  Map? selectCompanyType;
  Map companyType = {"0": "Individual", "1": "Organisation"};

  ///form3
  List<bool> isChecked = List<bool>.generate(7, (index) => false); //7 = daysOfWeek.length
  List<TimeOfDay> selectedStartTime = [];
  List<TimeOfDay> selectedEndTime = [];

  late List<String> daysOfWeek = [
    "sunLbl".translate(context: context),
    "monLbl".translate(context: context),
    "tueLbl".translate(context: context),
    "wedLbl".translate(context: context),
    "thuLbl".translate(context: context),
    "friLbl".translate(context: context),
    "satLbl".translate(context: context),
  ];

  late List<String> daysInWeek = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday'
  ];

  ///form4
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankCodeController = TextEditingController();
  TextEditingController accountNameController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController taxNameController = TextEditingController();
  TextEditingController taxNumberController = TextEditingController();
  TextEditingController swiftCodeController = TextEditingController();

  FocusNode bankNameFocus = FocusNode();
  FocusNode bankCodeFocus = FocusNode();
  FocusNode bankAccountNumberFocus = FocusNode();
  FocusNode accountNameFocus = FocusNode();
  FocusNode accountNumberFocus = FocusNode();
  FocusNode taxNameFocus = FocusNode();
  FocusNode taxNumberFocus = FocusNode();
  FocusNode swiftCodeFocus = FocusNode();

  PickImage pickLogoImage = PickImage();
  PickImage pickBannerImage = PickImage();
  PickImage pickAddressProofImage = PickImage();
  PickImage pickPassportImage = PickImage();
  PickImage pickNationalIdImage = PickImage();

  ProviderDetails? providerData;
  bool? isIndividualType;

  @override
  void initState() {
    super.initState();

    initializeData();
  }

  initializeData() {
    Future.delayed(Duration.zero).then((value) {
      //
      providerData = context.read<UserInfoCubit>().providerDetails;
      //
      userNameController.text = providerData?.user?.username ?? "";
      emailController.text = providerData?.user?.email ?? "";
      mobileNumberController.text =
          "${providerData?.user?.countryCode ?? ""} ${providerData?.user?.phone ?? ""}";
      companyNameController.text = providerData?.providerInformation?.companyName ?? "";
      aboutCompanyController.text = providerData?.providerInformation?.about ?? "";
      //
      bankNameController.text = providerData?.bankInformation?.bankName ?? "";
      bankCodeController.text = providerData?.bankInformation?.bankCode ?? "";
      accountNameController.text = providerData?.bankInformation?.accountName ?? "";
      accountNumberController.text = providerData?.bankInformation?.accountNumber ?? "";
      taxNameController.text = providerData?.bankInformation?.taxName ?? "";
      taxNumberController.text = providerData?.bankInformation?.taxNumber ?? "";
      swiftCodeController.text = providerData?.bankInformation?.swiftCode ?? "";
      //
      cityController.text = providerData?.locationInformation?.city ?? "";
      addressController.text = providerData?.locationInformation?.address ?? "";
      latitudeController.text = providerData?.locationInformation?.latitude ?? "";
      longitudeController.text = providerData?.locationInformation?.longitude ?? "";
      companyNameController.text = providerData?.providerInformation?.companyName ?? "";
      aboutCompanyController.text = providerData?.providerInformation?.about ?? "";
      visitingChargesController.text = (providerData?.providerInformation?.visitingCharges ?? "");
      advanceBookingDaysController.text =
          providerData?.providerInformation?.advanceBookingDays ?? "";
      numberOfMemberController.text = providerData?.providerInformation?.numberOfMembers ?? "";
      selectCompanyType = providerData?.providerInformation?.type == "1"
          ? {"title": "Individual", "value": "0"}
          : {"title": "Organisation", "value": "1"};
      isIndividualType = providerData?.providerInformation?.type == "1";
      //add elements in TimeOfDay List
      for (int i = 0; i < daysInWeek.length; i++) {
        //assign Default time @ start
        var startTime = (providerData?.workingDays?[i].startTime ?? "09:00:00").split(':');
        var endTime = (providerData?.workingDays?[i].endTime ?? "18:00:00").split(':');

        int startTimeHour = int.parse(startTime[0]);
        int startTimeMinute = int.parse(startTime[1]);
        selectedStartTime.insert(i, TimeOfDay(hour: startTimeHour, minute: startTimeMinute));
        //
        int endTimeHour = int.parse(endTime[0]);
        int endTimeMinute = int.parse(endTime[1]);
        selectedEndTime.insert(i, TimeOfDay(hour: endTimeHour, minute: endTimeMinute));
        isChecked[i] = providerData?.workingDays?[i].isOpen == 1;
      }
    });
    setState(() {});
  }

  @override
  void dispose() {
    userNameController.dispose();
    emailController.dispose();
    mobileNumberController.dispose();
    companyNameController.dispose();
    visitingChargesController.dispose();
    advanceBookingDaysController.dispose();
    numberOfMemberController.dispose();
    aboutCompanyController.dispose();
    cityController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    addressController.dispose();
    bankNameController.dispose();
    bankCodeController.dispose();
    accountNameController.dispose();
    accountNumberController.dispose();
    taxNumberController.dispose();
    taxNameController.dispose();
    swiftCodeController.dispose();
    pickedLocalImages.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            if (currentIndex > 1) {
              currentIndex--;
              pickedLocalImages = pickedLocalImages;
              setState(() {});
              return false;
            }
            return true;
          },
          child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.primaryColor,
              appBar: AppBar(
                elevation: 0,
                title: CustomText(
                    titleText: widget.isEditing
                        ? "editDetails".translate(context: context)
                        : "completeKYCDetails".translate(context: context),
                    fontColor: Theme.of(context).colorScheme.headingFontColor),
                leading: widget.isEditing
                    ? UiUtils.setBackArrow(context, onTap: () {
                        if (currentIndex > 1) {
                          currentIndex--;
                          pickedLocalImages = pickedLocalImages;
                          setState(() {});
                          return;
                        }
                        Navigator.pop(context);
                      })
                    : null,
                backgroundColor: Theme.of(context).colorScheme.primaryColor,
                actions: <Widget>[
                  PageNumberIndicator(currentIndex: currentIndex, total: totalForms)
                ],
              ),
              bottomNavigationBar: bottomNavigation(currentIndex: currentIndex),
              body: screenBuilder(currentIndex)),
        ),
      ),
    );
  }

  bottomNavigation({required int currentIndex}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (currentIndex > 1)
          Expanded(child: nextPrevBtnWidget(isNext: false, currentIndex: currentIndex)),
        const SizedBox(width: 5),
        Expanded(child: nextPrevBtnWidget(isNext: true, currentIndex: currentIndex)),
      ]),
    );
  }

  nextPrevBtnWidget({required bool isNext, required int currentIndex}) {
    return BlocConsumer<EditProviderDetailsCubit, EditProviderDetailsState>(
      listener: (context, state) async {
        if (state is EditProviderDetailsSuccess) {
          UiUtils.showMessage(context, "detailsUpdatedSuccessfully".translate(context: context),
              MessageType.success);
          //

          //
          if (widget.isEditing) {
            context.read<UserInfoCubit>().setUserInfo(state.providerDetails);
            Future.delayed(const Duration(seconds: 1)).then((value) {
              Navigator.pop(context);
            });
          } else {
            // await AuthRepository().logout(context);
//
            Future.delayed(const Duration(seconds: 1)).then((value) {
              Navigator.pushReplacementNamed(context, Routes.registrationSuccess, arguments: {
                "title": "detailsSubmitted".translate(context: context),
                "message":
                    "detailsHasBeenSubmittedWaitForAdminApproval".translate(context: context),
              });
            });
          }
        } else if (state is EditProviderDetailsFailure) {
          UiUtils.showMessage(
              context, state.errorMessage.translate(context: context), MessageType.error);
        }
      },
      builder: (context, state) {
        Widget? child;
        if (state is EditProviderDetailsInProgress) {
          child = CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondaryColor,
          );
        } else if (state is EditProviderDetailsSuccess || state is EditProviderDetailsFailure) {
          child = null;
        }
        return CustomRoundedButton(
          widthPercentage: isNext ? 1 : 0.5,
          backgroundColor: isNext
              ? Theme.of(context).colorScheme.headingFontColor
              : Theme.of(context).colorScheme.primaryColor,
          buttonTitle: isNext && currentIndex >= totalForms
              ? "submitBtnLbl".translate(context: context)
              : isNext
                  ? "nxtBtnLbl".translate(context: context)
                  : "prevBtnLbl".translate(context: context),
          showBorder: isNext ? false : true,
          borderColor: Theme.of(context).colorScheme.headingFontColor,
          titleColor: isNext
              ? Theme.of(context).colorScheme.secondaryColor
              : Theme.of(context).colorScheme.headingFontColor,
          onTap: () => state is EditProviderDetailsInProgress
              ? () {}
              : onNextPrevBtnClick(isNext: isNext, currentPage: currentIndex),
          child: isNext && currentIndex >= totalForms ? child : null,
        );
      },
    );
  }

  onNextPrevBtnClick({required bool isNext, required int currentPage}) async {
    if (isNext) {
      var form = formKey1.currentState; //default value
      switch (currentPage) {
        case 2:
          form = formKey2.currentState;
          break;
        case 3:
          form = formKey3.currentState;
          break;
        case 4:
          form = formKey4.currentState;
          break;
        case 5:
          form = formKey5.currentState;
          break;
        default:
          form = formKey1.currentState;
          break;
      }
      if (form == null) return;
      form.save();
      if (form.validate()) {
        if (currentPage < totalForms) {
          currentIndex++;
          scrollController.jumpTo(0); //reset Scrolling on Form change
          pickedLocalImages = pickedLocalImages;
          setState(() {});
        } else {
          List<WorkingDay> workingDays = [];
          for (int i = 0; i < daysInWeek.length; i++) {
            //
            workingDays.add(WorkingDay(
                isOpen: isChecked[i] ? 1 : 0,
                endTime:
                    "${selectedEndTime[i].hour.toString().padLeft(2, "0")}:${selectedEndTime[i].minute.toString().padLeft(2, "0")}:00",
                startTime:
                    "${selectedStartTime[i].hour.toString().padLeft(2, "0")}:${selectedStartTime[i].minute.toString().padLeft(2, "0")}:00",
                day: daysInWeek[i].toString()));
          }

          ProviderDetails editProviderDetails = ProviderDetails(
            user: User(
              id: providerData?.user?.id,
              username: userNameController.text.trim().toString(),
              email: emailController.text.trim().toString(),
              phone: providerData?.user?.phone,
              countryCode: providerData?.user?.countryCode,
              company: companyNameController.text.trim().toString(),
              image: pickedLocalImages['logoImage'],
            ),
            providerInformation: ProviderInformation(
              type: selectCompanyType?["value"],
              companyName: companyNameController.text.trim().toString(),
              visitingCharges: visitingChargesController.text.trim().toString(),
              advanceBookingDays: advanceBookingDaysController.text.trim().toString(),
              about: aboutCompanyController.text.trim().toString(),
              numberOfMembers: numberOfMemberController.text.trim().toString(),
              banner: pickedLocalImages['bannerImage'],
              nationalId: pickedLocalImages['nationalIdImage'],
              passport: pickedLocalImages['passportIdImage'],
              addressId: pickedLocalImages['addressIdImage'],
            ),
            bankInformation: BankInformation(
              accountName: accountNameController.text.trim().toString(),
              accountNumber: accountNumberController.text.trim().toString(),
              bankCode: bankCodeController.text.trim().toString(),
              bankName: bankNameController.text.trim().toString(),
              taxName: taxNameController.text.trim().toString(),
              taxNumber: taxNumberController.text.trim().toString(),
              swiftCode: swiftCodeController.text.trim().toString(),
            ),
            locationInformation: LocationInformation(
              longitude: longitudeController.text.trim().toString(),
              latitude: latitudeController.text.trim().toString(),
              address: addressController.text.trim().toString(),
              city: cityController.text.trim().toString(),
            ),
            workingDays: workingDays,
          );
          //
          context
              .read<EditProviderDetailsCubit>()
              .editProviderDetails(providerDetails: editProviderDetails);
        }
      }
    } else if (currentPage > 1) {
      currentIndex--;
      pickedLocalImages = pickedLocalImages;
      setState(() {});
    }
  }

  Widget screenBuilder(int currentPage) {
    Widget currentForm = form1(); //default form1
    switch (currentPage) {
      case 2:
        currentForm = form2();
        break;
      case 3:
        currentForm = form3();
        break;
      case 4:
        currentForm = form4();
        break;
      case 5:
        currentForm = form5();
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
            CustomText(
                titleText: "personalDetails".translate(context: context),
                fontColor: Theme.of(context).colorScheme.blackColor),
            UiUtils.setDivider(context: context),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "userNmLbl".translate(context: context),
              controller: userNameController,
              currNode: userNmFocus,
              nextFocus: emailFocus,
              validator: (cityValue) => Validator.nullCheck(cityValue),
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "emailLbl".translate(context: context),
              controller: emailController,
              currNode: emailFocus,
              nextFocus: mobNoFocus,
              textInputType: TextInputType.emailAddress,
              validator: (cityValue) => Validator.nullCheck(cityValue),
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "mobNoLbl".translate(context: context),
              controller: mobileNumberController,
              currNode: mobNoFocus,
              textInputType: TextInputType.phone,
              isReadOnly: true,
              validator: (cityValue) => Validator.nullCheck(cityValue),
            ),
            /*UiUtils.setTitleAndTFF(context, titleText: UiUtils.getTranslatedLabel(context, "passwordLbl"), controller: passwordController, currNode: passwordFocus, nextFocus: confirmPasswordFocus, isPswd: true),
            UiUtils.setTitleAndTFF(context,
                titleText: UiUtils.getTranslatedLabel(context, "confirmPasswordLbl"), controller: confirmPasswordController, currNode: confirmPasswordFocus, nextFocus: companyNmFocus, isPswd: true),*/

            const SizedBox(
              height: 12,
            ),
            CustomText(
              titleText: "idProofLbl".translate(context: context),
              fontColor: Theme.of(context).colorScheme.blackColor,
            ),
            UiUtils.setDivider(context: context),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                idImageWidget(
                    imageController: pickNationalIdImage,
                    titleTxt: "nationalIdLbl".translate(context: context),
                    imageHintText: "chooseFileLbl".translate(context: context),
                    imageType: "nationalIdImage",
                    oldImage: context
                            .read<UserInfoCubit>()
                            .providerDetails
                            .providerInformation
                            ?.nationalId ??
                        ""),
                idImageWidget(
                    imageController: pickAddressProofImage,
                    titleTxt: "addressLabel".translate(context: context),
                    imageHintText: "chooseFileLbl".translate(context: context),
                    imageType: "addressIdImage",
                    oldImage: context
                            .read<UserInfoCubit>()
                            .providerDetails
                            .providerInformation
                            ?.addressId ??
                        ""),
                idImageWidget(
                    imageController: pickPassportImage,
                    titleTxt: "passportLbl".translate(context: context),
                    imageHintText: "chooseFileLbl".translate(context: context),
                    imageType: "passportIdImage",
                    oldImage: context
                            .read<UserInfoCubit>()
                            .providerDetails
                            .providerInformation
                            ?.passport ??
                        ""),
              ]),
            ),
          ],
        ));
  }

  Widget form2() {
    return Form(
        key: formKey2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                titleText: "companyDetails".translate(context: context),
                fontColor: Theme.of(context).colorScheme.blackColor),
            UiUtils.setDivider(context: context),
            UiUtils.setTitleAndTFF(context,
                titleText: "compNmLbl".translate(context: context),
                controller: companyNameController,
                currNode: companyNmFocus,
                nextFocus: visitingChargeFocus,
                validator: (cityValue) => Validator.nullCheck(cityValue),
                textInputType: TextInputType.text),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "visitingCharge".translate(context: context),
              controller: visitingChargesController,
              currNode: visitingChargeFocus,
              nextFocus: companyNmFocus,
              validator: (cityValue) => Validator.nullCheck(cityValue),
              textInputType: TextInputType.number,
              allowOnlySingleDecimalPoint: true,
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
            ),
            UiUtils.setTitleAndTFF(context,
                titleText: "advanceBookingDay".translate(context: context),
                controller: advanceBookingDaysController,
                currNode: advanceBookingDaysFocus,
                nextFocus: numberOfMemberFocus,
                validator: (cityValue) => Validator.nullCheck(cityValue),
                textInputType: TextInputType.number),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "aboutCompany".translate(context: context),
              controller: aboutCompanyController,
              currNode: aboutCompanyFocus,
              minLines: 3,
              expands: true,
              textInputType: TextInputType.multiline,
              validator: (cityValue) => Validator.nullCheck(cityValue),
            ),
            buildDropDown(
              context,
              title: "selectType".translate(context: context),
              initialValue: selectCompanyType?['title'] ?? "selectType".translate(context: context),
              value: companyType[selectCompanyType]?["value"],
              onTap: () {
                selectCompanyTypes();
              },
            ),
            const SizedBox(
              height: 16,
            ),
            UiUtils.setTitleAndTFF(context,
                titleText: "numberOfMember".translate(context: context),
                controller: numberOfMemberController,
                currNode: numberOfMemberFocus,
                nextFocus: aboutCompanyFocus,
                validator: (cityValue) => Validator.nullCheck(cityValue),
                isReadOnly: isIndividualType ?? false,
                textInputType: TextInputType.number),
            const SizedBox(
              height: 7,
            ),
            CustomText(
                titleText: "logoLbl".translate(context: context),
                fontColor: Theme.of(context).colorScheme.blackColor),
            const SizedBox(
              height: 7,
            ),
            imagePicker(
                imageController: pickLogoImage,
                oldImage: providerData?.user?.image ?? "",
                hintLabel:
                    "${"addLbl".translate(context: context)} ${"logoLbl".translate(context: context)}",
                imageType: "logoImage"),
            const SizedBox(
              height: 12,
            ),
            CustomText(
                titleText: "bannerImgLbl".translate(context: context),
                fontColor: Theme.of(context).colorScheme.blackColor),
            const SizedBox(
              height: 7,
            ),
            imagePicker(
                imageController: pickBannerImage,
                oldImage: providerData?.providerInformation?.banner ?? "",
                hintLabel:
                    "${"addLbl".translate(context: context)} ${"bannerImgLbl".translate(context: context)}",
                imageType: "bannerImage"),
            const SizedBox(
              height: 12,
            ),
          ],
        ));
  }

  Widget form3() {
    return Form(
      key: formKey3,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                titleText: "locationInformation".translate(context: context),
                fontColor: Theme.of(context).colorScheme.blackColor),
            UiUtils.setDivider(context: context),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "cityLbl".translate(context: context),
              controller: cityController,
              currNode: cityFocus,
              nextFocus: latitudeFocus,
              validator: (cityValue) => Validator.nullCheck(cityValue),
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "latitudeLbl".translate(context: context),
              controller: latitudeController,
              currNode: latitudeFocus,
              nextFocus: longitudeFocus,
              textInputType: TextInputType.number,
              validator: (latitudeLabel) => Validator.nullCheck(latitudeLabel),
              allowOnlySingleDecimalPoint: true,
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "longitudeLbl".translate(context: context),
              controller: longitudeController,
              currNode: longitudeFocus,
              nextFocus: addressFocus,
              textInputType: TextInputType.number,
              validator: (longitudeLabel) => Validator.nullCheck(longitudeLabel),
              allowOnlySingleDecimalPoint: true,
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "addressLbl".translate(context: context),
              controller: addressController,
              currNode: addressFocus,
              textInputType: TextInputType.multiline,
              expands: true,
              minLines: 3,
              validator: (addressValue) => Validator.nullCheck(addressValue),
            ),
          ],
        ),
      ),
    );
  }

  Widget form4() {
    return Form(
        key: formKey4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                titleText: "workingDaysLbl".translate(context: context),
                fontColor: Theme.of(context).colorScheme.blackColor),
            UiUtils.setDivider(context: context),
            ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: daysOfWeek.length,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      setRow(titleTxt: daysOfWeek[index], indexVal: index),
                      (isChecked[index]) ? setTimerPickerRow(index) : const SizedBox.shrink(),
                    ],
                  );
                }),
          ],
        ));
  }

  Widget form5() {
    return Form(
        key: formKey5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
                titleText: "bankDetailsLbl".translate(context: context),
                fontColor: Theme.of(context).colorScheme.blackColor),
            UiUtils.setDivider(context: context),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "bankNmLbl".translate(context: context),
              controller: bankNameController,
              currNode: bankNameFocus,
              nextFocus: bankCodeFocus,
              validator: (cityValue) => Validator.nullCheck(cityValue),
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "bankCodeLbl".translate(context: context),
              controller: bankCodeController,
              currNode: bankCodeFocus,
              nextFocus: accountNameFocus,
              validator: (cityValue) => Validator.nullCheck(cityValue),
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "accountName".translate(context: context),
              controller: accountNameController,
              currNode: accountNameFocus,
              nextFocus: accountNumberFocus,
              textInputType: TextInputType.text,
              validator: (mobileNumber) => Validator.nullCheck(mobileNumber),
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "accNumLbl".translate(context: context),
              controller: accountNumberController,
              currNode: accountNumberFocus,
              nextFocus: taxNameFocus,
              textInputType: TextInputType.phone,
              validator: (cityValue) => Validator.nullCheck(cityValue),
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "taxName".translate(context: context),
              controller: taxNameController,
              currNode: taxNameFocus,
              nextFocus: taxNumberFocus,
              textInputType: TextInputType.text,
              validator: (mobileNumber) => Validator.nullCheck(mobileNumber),
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "taxNumber".translate(context: context),
              controller: taxNumberController,
              currNode: taxNumberFocus,
              nextFocus: swiftCodeFocus,
              validator: (cityValue) => Validator.nullCheck(cityValue),
              textInputType: const TextInputType.numberWithOptions(decimal: true),
            ),
            UiUtils.setTitleAndTFF(
              context,
              titleText: "swiftCode".translate(context: context),
              controller: swiftCodeController,
              currNode: swiftCodeFocus,
              validator: (cityValue) => Validator.nullCheck(cityValue),
            ),
          ],
        ));
  }

  Widget setRow({required String titleTxt, required int indexVal}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: CustomText(
                titleText: titleTxt, fontColor: Theme.of(context).colorScheme.blackColor),
          ),
          // CustomText(titleText: "openLbl".translate(context: context)),
          const Spacer(),
          SizedBox(
            height: 24,
            width: 24,
            child: CheckBox(
              isChecked: isChecked,
              indexVal: indexVal,
              onChanged: (checked) {
                setState(
                  () {
                    pickedLocalImages = pickedLocalImages;
                    isChecked[indexVal] = checked!;
                    // show/hide timePicker
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget setTimerPickerRow(int indexVal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomRoundedButton(
          backgroundColor: Colors.transparent,
          widthPercentage: 0.3,
          // format time as AM/PM
          buttonTitle: DateFormat.jm().format(DateTime.parse(
              "2020-07-20T${selectedStartTime[indexVal].hour.toString().padLeft(2, "0")}:${selectedStartTime[indexVal].minute.toString().padLeft(2, "0")}:00")),
          showBorder: true,
          borderColor: Theme.of(context).colorScheme.headingFontColor,
          height: 43,
          textSize: 16,
          titleColor: Theme.of(context).colorScheme.blackColor,
          onTap: () {
            _selectTime(
                selectedTime: selectedStartTime[indexVal],
                indexVal: indexVal,
                isTimePickerForStarTime: true);
          },
        ),
        CustomText(
            titleText: "toLbl".translate(context: context),
            fontColor: Theme.of(context).colorScheme.lightGreyColor,
            fontWeight: FontWeight.w400,
            fontSize: 16.0),
        CustomRoundedButton(
          backgroundColor: Colors.transparent,
          widthPercentage: 0.3,
          buttonTitle:
              "${DateFormat.jm().format(DateTime.parse("2020-07-20T${selectedEndTime[indexVal].hour.toString().padLeft(2, "0")}:${selectedEndTime[indexVal].minute.toString().padLeft(2, "0")}:00"))} ",
          showBorder: true,
          borderColor: Theme.of(context).colorScheme.headingFontColor,
          height: 43,
          textSize: 16,
          titleColor: Theme.of(context).colorScheme.blackColor,
          onTap: () {
            _selectTime(
                selectedTime: selectedEndTime[indexVal],
                indexVal: indexVal,
                isTimePickerForStarTime: false);
          },
        ),
      ],
    );
  }

  _selectTime(
      {required TimeOfDay selectedTime,
      required int indexVal,
      required bool isTimePickerForStarTime}) async {
    try {
      final TimeOfDay? timeOfDay = await showTimePicker(
          context: context,
          initialTime: selectedTime, //TimeOfDay.now(),
          builder: (context, child) {
            return MediaQuery(
                data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                //To use 12 hours
                child: child!);
          });
      //

      if (isTimePickerForStarTime) {
        //
        bool isStartTimeBeforeOfEndTime = (timeOfDay!.hour <=
                (selectedEndTime[indexVal].hour == 00 ? 24 : selectedEndTime[indexVal].hour) &&
            timeOfDay.minute <= selectedEndTime[indexVal].minute);
        //
        if (isStartTimeBeforeOfEndTime) {
          selectedStartTime[indexVal] = timeOfDay;
        } else {
          UiUtils.showMessage(
              context,
              "companyStartTimeCanNotBeAfterOfEndTime".translate(context: context),
              MessageType.warning);
        }
      } else {
        //
        bool isEndTimeAfterOfStartTime = (timeOfDay!.hour >=
                (selectedStartTime[indexVal].hour == 00 ? 24 : selectedStartTime[indexVal].hour) &&
            timeOfDay.minute >= selectedStartTime[indexVal].minute);
        //
        if (isEndTimeAfterOfStartTime) {
          selectedEndTime[indexVal] = timeOfDay;
        } else {
          UiUtils.showMessage(
              context,
              "companyEndTimeCanNotBeBeforeOfStartTime".translate(context: context),
              MessageType.warning);
        }
      }
    } catch (_) {
      //UiUtils.showMessage(context, e.toString(), MessageType.error);
    }

    setState(() {
      pickedLocalImages = pickedLocalImages;
    });
  }

  Widget idImageWidget(
      {required String titleTxt,
      required String imageHintText,
      required PickImage imageController,
      required String imageType,
      required String oldImage}) {
    return Column(
      children: [
        CustomText(
          titleText: titleTxt,
        ),
        const SizedBox(height: 5),
        imagePicker(
            imageType: imageType,
            imageController: imageController,
            oldImage: oldImage,
            hintLabel: imageHintText,
            width: 100),
      ],
    );
  }

  imagePicker(
      {required PickImage imageController,
      required String oldImage,
      required String hintLabel,
      required String imageType,
      double? width}) {
    return imageController.ListenImageChange(
      (context, image) {
        if (image == null) {
          if (pickedLocalImages[imageType] != "") {
            return GestureDetector(
              onTap: () {
                showCameraAndGalleryOption(imageController: imageController, title: hintLabel);
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox(
                      height: 200,
                      width: width ?? MediaQuery.of(context).size.width,
                      child: Image.file(
                        File(pickedLocalImages[imageType]!),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: 210,
                      width: (width ?? MediaQuery.of(context).size.width - 5) + 5,
                      child: DashedRect(
                        color: Theme.of(context).colorScheme.headingFontColor,
                        strokeWidth: 2.0,
                        gap: 4.0,
                      )),
                ],
              ),
            );
          }
          if (oldImage.isNotEmpty) {
            return GestureDetector(
              onTap: () {
                showCameraAndGalleryOption(imageController: imageController, title: hintLabel);
              },
              child: Stack(
                children: [
                  SizedBox(
                      height: 210,
                      width: width ?? MediaQuery.of(context).size.width,
                      child: DashedRect(
                        color: Theme.of(context).colorScheme.headingFontColor,
                        strokeWidth: 2.0,
                        gap: 4.0,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: SizedBox(
                      height: 200,
                      width: (width ?? MediaQuery.of(context).size.width) - 5.0,
                      child: CachedNetworkImage(imageUrl: oldImage),
                    ),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: InkWell(
              onTap: () {
                showCameraAndGalleryOption(imageController: imageController, title: hintLabel);
              },
              child: SetDottedBorderWithHint(
                height: 100,
                width: width ?? MediaQuery.of(context).size.width - 35,
                radius: 7,
                str: hintLabel,
                strPrefix: '',
                borderColor: Theme.of(context).colorScheme.headingFontColor,
              ),
            ),
          );
        }
        //
        pickedLocalImages[imageType] = image?.path;
        //
        return GestureDetector(
          onTap: () {
            showCameraAndGalleryOption(imageController: imageController, title: hintLabel);
          },
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
                child: SizedBox(
                  height: 200,
                  width: width ?? MediaQuery.of(context).size.width,
                  child: Image.file(
                    File(image.path),
                  ),
                ),
              ),
              SizedBox(
                  height: 210,
                  width: (width ?? MediaQuery.of(context).size.width - 5) + 5,
                  child: DashedRect(
                    color: Theme.of(context).colorScheme.headingFontColor,
                    strokeWidth: 2.0,
                    gap: 4.0,
                  )),
            ],
          ),
        );
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

  showCameraAndGalleryOption({required PickImage imageController, required String title}) {
    return UiUtils.showBottomSheet(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        context: context,
        child: Wrap(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    color: Theme.of(context).colorScheme.secondaryColor,
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      title,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.headingFontColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    )),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.lightGreyColor,
                                )),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  imageController.pick(source: ImageSource.camera);
                                },
                                icon: Icon(
                                  Icons.camera_alt_outlined,
                                  size: 50,
                                  color: Theme.of(context).colorScheme.headingFontColor,
                                )),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "camera".translate(context: context),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.lightGreyColor,
                                )),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                                imageController.pick(source: ImageSource.gallery);
                              },
                              icon: Icon(
                                Icons.image_outlined,
                                size: 50,
                                color: Theme.of(context).colorScheme.headingFontColor,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            "gallery".translate(context: context),
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Future<void> selectCompanyTypes() async {
    Map? result = await showDialog<Map>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CustomDialogs.showSelectDialoge(
            selectedValue: selectCompanyType?['value'],
            itemList: <Map>[
              {'title': "Individual".translate(context: context), 'value': '0'},
              {'title': "Organisation".translate(context: context), 'value': '1'}
            ]);
      },
    );
    selectCompanyType = result;

    if (result?["title"] == "Individual") {
      numberOfMemberController.text = "1";
      isIndividualType = true;
    } else {
      isIndividualType = false;
    }
    setState(() {
      pickedLocalImages = pickedLocalImages;
    });
  }
}
