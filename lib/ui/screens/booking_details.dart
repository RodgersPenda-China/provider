import 'package:edemand_partner/data/cubits/fetch_bookings_cubit.dart';
import 'package:edemand_partner/data/cubits/updateBookingStatusCubit.dart';
import 'package:edemand_partner/data/model/booking_model.dart';
import 'package:edemand_partner/ui/widgets/customContainer.dart';
import 'package:edemand_partner/ui/widgets/customRoundButton.dart';
import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/ui/widgets/formDropdownField.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/dialogs.dart';
import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/uiUtils.dart';
import '../widgets/bottomSheets/calender_bottom_sheet.dart';

class BookingDetails extends StatefulWidget {
  final BookingsModel bookingsModel;

  const BookingDetails({Key? key, required this.bookingsModel}) : super(key: key);

  @override
  BookingDetailsState createState() => BookingDetailsState();

  static Route<BookingDetails> route(RouteSettings routeSettings) {
    Map arguments = routeSettings.arguments as Map;
    return CupertinoPageRoute(
      builder: (_) => BookingDetails(
        bookingsModel: arguments['bookingsModel'],
      ), //pass Selected booking id from Previous screen
    );
  }
}

class BookingDetailsState extends State<BookingDetails> {
  // Map userData = Constant.bookingList[0]; //user data
  // Map bookingDetails = Constant.bookingDetails[0]; //pass selected model here

  ScrollController? scrollController = ScrollController();
  Map? currentStatusOfBooking;
  int totalServiceQuantity = 0;

  DateTime? selectedRescheduleDate;
  String? selectedRescheduleTime;
  List<Map<String, String>> filters = [];

  @override
  void initState() {
    scrollController!.addListener(() => setState(() {}));
    _getTotalQuantity();
    Future.delayed(Duration.zero, () {
      filters = [
        {
          'value': '1',
          'title': "awaiting".translate(context: context),
        },
        {
          'value': '2',
          'title': "confirmed".translate(context: context),
        },
        {'value': '3', 'title': "rescheduled".translate(context: context)},
        {
          'value': '4',
          'title': "completed".translate(context: context),
        },
        {
          'value': '5',
          'title': "cancelled".translate(context: context),
        },
      ];
    });
    _getTranslatedInitialStatus();
    super.initState();
  }

  _getTotalQuantity() {
    widget.bookingsModel.services?.forEach(
      (service) {
        totalServiceQuantity += int.parse(service.quantity!);
      },
    );
    setState(
      () {},
    );
  }

  _getTranslatedInitialStatus() {
    Future.delayed(Duration.zero, () {
      String? initialStatusValue = getStatusForApi
          .where((e) => e['title'] == widget.bookingsModel.status)
          .toList()[0]['value'];
      currentStatusOfBooking = filters.where((element) {
        return element['value'] == initialStatusValue;
      }).toList()[0];

      setState(() {});
    });
  }

// Don't translate this becouse we need to send this title in api;
  List<Map<String, String>> getStatusForApi = [
    {'value': '1', 'title': "awaiting"},
    {'value': '2', 'title': "confirmed"},
    {'value': '3', 'title': "rescheduled"},
    {'value': '4', 'title': "completed"},
    {'value': '5', 'title': "cancelled"},
  ];

  _onDropDownClick(filters) async {
    if (widget.bookingsModel.status != null) {
      currentStatusOfBooking =
          getStatusForApi.where((e) => e['title'] == widget.bookingsModel.status).toList()[0];
    }
    var selectedStatusOfBooking = await showDialog(
      context: context,
      builder: (context) {
        return CustomDialogs.showSelectDialoge(
          selectedValue: currentStatusOfBooking?['value'],
          itemList: [...filters],
        );
      },
    );
    if (selectedStatusOfBooking != null) {
      currentStatusOfBooking = selectedStatusOfBooking;

      if (selectedStatusOfBooking['value'] == "3") {
        Map? result = await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: true,
          builder: (context) => SizedBox(
            height: MediaQuery.of(context).size.height * 0.584,
            child:
                CalenderBottomSheet(advanceBookingDays: widget.bookingsModel.advanceBookingDays!),
          ),
        );

        selectedRescheduleDate = result?['selectedDate'];
        selectedRescheduleTime = result?['selectedTime'];

        if (selectedRescheduleDate == null || selectedRescheduleTime == null) {
          selectedStatusOfBooking = getStatusForApi[0];
          currentStatusOfBooking = getStatusForApi[0];
          setState(() {});
        }
      } else {
        ///reset the values if choose different one
        selectedRescheduleDate = null;
        selectedRescheduleTime = null;
      }
    }

    setState(() {});
  }

  @override
  void didChangeDependencies() {
    //  _getTranslatedInitialStatus();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return (context.read<UpdateBookingStatusCubit>().state is! UpdateBookingStatusInProgress);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.secondaryColor,
          elevation: 0,
          leading: UiUtils.setBackArrow(context,
              canGoBack: context.watch<UpdateBookingStatusCubit>().state
                  is! UpdateBookingStatusInProgress),
          actions: [onMapsBtn()],
        ),

        body: mainWidget(), //mainWidget(),

        bottomNavigationBar: bottombarWidget(),
      ),
    );
  }

  Widget onMapsBtn() {
    return Padding(
        padding: const EdgeInsets.all(15), //only(right: 10),
        child: ElevatedButton(
          onPressed: () async {
            try {
              await launchUrl(
                Uri.parse(
                    "https://www.google.com/maps/search/?api=1&query=${widget.bookingsModel.latitude},${widget.bookingsModel.longitude}"),

                /* Uri.parse(
                    "google.navigation:q=${widget.bookingsModel.latitude},${widget.bookingsModel.longitude}&mode=d"),*/
                mode: LaunchMode.externalApplication,
              );
            } catch (e) {
              UiUtils.showMessage(
                  context, "somethingWentWrong".translate(context: context), MessageType.error);
            }

            //open location on Maps//
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                RoundedRectangleBorder(
                  side:
                      BorderSide(width: 1.0, color: Theme.of(context).colorScheme.headingFontColor),
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).colorScheme.headingFontColor)),
          child: CustomText(
            titleText: "onMapsLbl".translate(context: context),
            fontSize: 14,
            fontColor: Theme.of(context).colorScheme.secondaryColor,
          ),
        ));
  }

  Widget bottombarWidget() {
    return BlocConsumer<UpdateBookingStatusCubit, UpdateBookingStatusState>(
      listener: (context, state) {
        if (state is UpdateBookingStatusFailure) {
          UiUtils.showMessage(context, state.errorMessage.toString(), MessageType.error);
        }
        if (state is UpdateBookingStatusSuccess) {
          context
              .read<FetchBookingsCubit>()
              .updateBookingStatusInCubit(state.orderId.toString(), state.status);

          UiUtils.showMessage(
              context, "updatedSuccessfully".translate(context: context), MessageType.success);
        }
      },
      builder: (context, state) {
        Widget? child;
        if (state is UpdateBookingStatusInProgress) {
          child = CircularProgressIndicator(
            color: Theme.of(context).colorScheme.secondaryColor,
          );
        }
        return Container(
          color: Theme.of(context).colorScheme.primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              height: (selectedRescheduleDate == null || selectedRescheduleTime == null) ? 50 : 120,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selectedRescheduleDate != null && selectedRescheduleTime != null) ...[
                    Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondaryColor,
                          boxShadow: const [BoxShadow(blurRadius: 2.5, spreadRadius: 0)]),
                      height: 70,
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "selectedDate".translate(context: context),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(selectedRescheduleDate.toString().split(" ")[0])
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "selectedTime".translate(context: context),
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Text(selectedRescheduleTime ?? "")
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ],
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 8,
                          child: CustomFormDropdown(
                              initialTitle:
                                  currentStatusOfBooking?['title'].toString().firstUpperCase() ??
                                      widget.bookingsModel.status.toString().firstUpperCase(),
                              selectedValue: currentStatusOfBooking?['title'],
                              onTap: () {
                                _onDropDownClick(filters);
                              }),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(
                          flex: 3,
                          child: CustomRoundedButton(
                            showBorder: false,
                            buttonTitle: "update".translate(context: context),
                            backgroundColor: Theme.of(context).colorScheme.headingFontColor,
                            widthPercentage: 1,
                            height: 50.rh(context),
                            textSize: 14,
                            child: child,
                            onTap: () {
                              Map<String, String>? bookingStatus;
                              List<Map<String, String>> selectedBookingStatus =
                                  getStatusForApi.where(
                                (Map<String, String> element) {
                                  return element['value'] == currentStatusOfBooking?['value'];
                                },
                              ).toList();

                              if (selectedBookingStatus.isNotEmpty) {
                                bookingStatus = selectedBookingStatus[0];
                              }

                              context.read<UpdateBookingStatusCubit>().updateBookingStatus(
                                  orderId: int.parse(widget.bookingsModel.id!),
                                  customerId: int.parse(widget.bookingsModel.customerId!),
                                  status: bookingStatus?['title'] ?? widget.bookingsModel.status!,
                                  date: selectedRescheduleDate.toString().split(" ")[0],
                                  time: selectedRescheduleTime);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget mainWidget() {
    return SingleChildScrollView(
        clipBehavior: Clip.none,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10), //vertical: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            customPersonDetailsCard(),
            const SizedBox(height: 15.0),
            customerContactWidget(),
            const SizedBox(height: 15.0),
            bookingDetailsWidget(),
            const SizedBox(height: 15.0),
            serviceDetailsWidget(),
            const SizedBox(height: 15.0),
            notesWidget(),
            pricingWidget()
          ],
        ));
  }

  Padding customPersonDetailsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      //const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SizedBox(
          // padding: const EdgeInsets.only(bottom: 30),
          width: MediaQuery.of(context).size.width - 16,
          height: MediaQuery.of(context).size.height * 0.18,
          // padding: const EdgeInsets.symmetric(horizontal: 15),
          //margin: const EdgeInsets.only(top: 30), //according to top image
          child: bookingInfoWidget()),
    );
  }

  Widget bookingInfoWidget() {
    return CustomContainer(
      cornerRadius: 15,
      //height: MediaQuery.of(context).size.height * 0.18,
      bgColor: Theme.of(context).colorScheme.secondaryColor,
      padding: const EdgeInsets.all(15),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  setIconAndTitle(
                    imgName: 'user',
                    txtVal: widget.bookingsModel.customer ?? "",
                  ),
                  setIconAndTitle(
                      imgName: 'adrs',
                      txtVal: widget.bookingsModel.address!,
                      width: 210.rw(context)),
                  setIconAndTitle(
                      imgName: 'b_calender',
                      txtVal: widget.bookingsModel.dateOfService!,
                      width: 210.rw(context)),
                  setIconAndTitle(
                    imgName: 'b_clock',
                    txtVal:
                        "${widget.bookingsModel.startingTime!},${widget.bookingsModel.endingTime!}",
                  ),
                ],
              ),
            ),
            Center(
                child: CircleAvatar(
                    radius: 40,
                    // borderRadius: BorderRadius.circular(9),
                    child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: UiUtils.setNetworkImage(
                          widget.bookingsModel.profileImage!,
                        )))),
          ]),
    );
  }

  Widget setIconAndTitle({required String imgName, required String txtVal, double? width}) {
    return Row(
      // crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        UiUtils.setSVGImage(imgName, imgColor: Theme.of(context).colorScheme.blackColor),
        const SizedBox(
          width: 8,
        ),
        SizedBox(
          width: width,
          child: CustomText(
            titleText: txtVal,
            fontWeight: FontWeight.w400,
            fontSize: 14,
            maxLines: 2,
            fontColor: Theme.of(context).colorScheme.blackColor,
          ),
        )
      ],
    );
  }

  Widget customerContactWidget() {
    return CustomContainer(
        height: MediaQuery.of(context).size.height * 0.10,
        cornerRadius: 15,
        width: MediaQuery.of(context).size.width,
        bgColor: Theme.of(context).colorScheme.secondaryColor,
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  titleText: "customerContactLbl".translate(context: context),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontColor: Theme.of(context).colorScheme.blackColor,
                ),
                CustomText(
                  titleText: widget.bookingsModel.customerNo!,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontColor: Theme.of(context).colorScheme.blackColor,
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                await launchUrl(Uri.parse("tel:${widget.bookingsModel.customerNo!}"));
              },
              child: CustomContainer(
                  cornerRadius: 7,
                  height: 36,
                  width: 40,
                  padding: const EdgeInsets.all(5),
                  bgColor: Theme.of(context).colorScheme.primaryColor.withAlpha(150),
                  child: Center(
                    child: UiUtils.setSVGImage(
                      'mobile',
                      imgColor: Theme.of(context).colorScheme.blackColor,
                    ),
                  )),
            )
          ],
        ));
  }

  Widget bookingDetailsWidget() {
    return CustomContainer(
      bgColor: Theme.of(context).colorScheme.secondaryColor,
      cornerRadius: 15,
      padding: const EdgeInsets.all(10),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          setKeyValueRow(
            key: "bookingDetailsLbl".translate(context: context),
            value: widget.bookingsModel.id!,
          ),
          UiUtils.setDivider(
            context: context,
          ),
          setKeyValueRow(
              key: "statusLbl".translate(context: context),
              value: widget.bookingsModel.status!,
              titleFontWeight: FontWeight.w500,
              valueFontWeight: FontWeight.w500),
          UiUtils.setDivider(
            context: context,
          ),
          setKeyValueRow(
              key: "paymentMethodLbl".translate(context: context),
              value: widget.bookingsModel.paymentMethod!,
              titleFontWeight: FontWeight.w500,
              valueFontWeight: FontWeight.w500),
        ],
      ),
    );
  }

  Widget setKeyValueRow({
    required String key,
    required String value,
    double? titleFontSize,
    FontWeight? valueFontWeight,
    FontWeight? titleFontWeight,
    double? valueFontSize,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          fontColor: Theme.of(context).colorScheme.blackColor,
          titleText: key,
          fontSize: titleFontSize ?? 14,
          fontWeight: titleFontWeight ?? FontWeight.w700,
        ),
        (key != "bookingDetailsLbl".translate(context: context))
            ? CustomContainer(
                cornerRadius: 4,
                padding: const EdgeInsets.all(5),
                bgColor: Theme.of(context).colorScheme.secondaryColor,
                child: CustomText(
                  fontColor: Theme.of(context).colorScheme.blackColor,
                  titleText: value,
                  fontSize: valueFontSize ?? 13,
                  fontWeight: valueFontWeight ?? FontWeight.w700,
                ))
            : CustomText(
                titleText: value.formatId(),
                fontSize: 13,
                fontWeight: valueFontWeight ?? FontWeight.w700,
                fontColor: Theme.of(context).colorScheme.blackColor,
              ),
      ],
    );
  }

  Widget serviceDetailsWidget() {
    //get services from Different model instead of static mentioned here
    return CustomContainer(
      bgColor: Theme.of(context).colorScheme.secondaryColor,
      cornerRadius: 15,
      padding: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            setServiceRowValues(
                title: "serviceDetailsLbl".translate(context: context), quantity: '', price: ''),
            UiUtils.setDivider(context: context),
            for (var service in widget.bookingsModel.services!) ...[
              setServiceRowValues(
                  title: service.serviceTitle!,
                  quantity: service.quantity!,
                  price: service.priceWithTax!),
              UiUtils.setDivider(context: context),
            ],
            setServiceRowValues(
                title: "totalPriceLbl".translate(context: context),
                quantity: totalServiceQuantity.toString(),
                isTitleBold: true,
                price: widget.bookingsModel.total!),
          ],
        ),
      ),
    );
  }

  Widget setServiceRowValues(
      {required String title,
      required String quantity,
      required String price,
      bool? isTitleBold,
      FontWeight? priceFontWeight}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 3,
          child: CustomText(
            titleText: title,
            fontSize: 14,
            fontWeight: (isTitleBold ?? false)
                ? FontWeight.bold
                : ((title != "serviceDetailsLbl".translate(context: context))
                    ? FontWeight.w400
                    : FontWeight.w700),
            fontColor: Theme.of(context).colorScheme.blackColor,
          ),
        ),
        (quantity != '')
            ? Expanded(
                flex: 2,
                child: CustomText(
                  textAlign: TextAlign.end,
                  titleText: (title == "totalPriceLbl".translate(context: context) ||
                          title == "totalServicePriceLbl".translate(context: context))
                      ? "${"totalQtyLbl".translate(context: context)} $quantity"
                      : (title == "gstLbl".translate(context: context) ||
                              title == "taxLbl".translate(context: context))
                          ? quantity.formatPercentage()
                          : (title == "couponDiscLbl".translate(context: context))
                              ? "${quantity.formatPercentage()} ${"offLbl".translate(context: context)}"
                              : "${"qtyLbl".translate(context: context)} $quantity",
                  fontSize: 14,
                  fontColor: Theme.of(context).colorScheme.lightGreyColor,
                ),
              )
            : const SizedBox.shrink(),
        (price != '')
            ? Expanded(
                flex: 1,
                child: CustomText(
                  textAlign: TextAlign.end,
                  titleText: UiUtils.getPriceFormat(context, double.parse(price)),
                  fontSize: (title == "totalPriceLbl".translate(context: context)) ? 14 : 14,
                  fontWeight: priceFontWeight ?? FontWeight.w500,
                  fontColor: Theme.of(context).colorScheme.blackColor,
                ),
              )
            : const SizedBox.shrink()
      ],
    );
  }

  Widget notesWidget() {
    if (widget.bookingsModel.remarks == "") {
      return Container();
    }
    return CustomContainer(
        height: MediaQuery.of(context).size.height * 0.13,
        cornerRadius: 15,
        bgColor: Theme.of(context).colorScheme.secondaryColor,
        padding: const EdgeInsets.all(10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              titleText: "notesLbl".translate(context: context),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              fontColor: Theme.of(context).colorScheme.blackColor,
            ),
            UiUtils.setDivider(context: context),
            Expanded(
              child: CustomText(
                titleText: widget.bookingsModel.remarks!,
                fontSize: 14,
                maxLines: 2,
                fontWeight: FontWeight.w400,
                fontColor: Theme.of(context).colorScheme.blackColor,
              ),
            )
          ],
        ));
  }

  Widget pricingWidget() {
    return CustomContainer(
      bgColor: Theme.of(context).colorScheme.secondaryColor,
      cornerRadius: 15,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            titleText: "pricingLbl".translate(context: context),
            fontSize: 14,
            fontWeight: FontWeight.bold,
            fontColor: Theme.of(context).colorScheme.blackColor,
          ),
          // setServiceRowValues(
          //     title:,
          //     quantity: '',
          //     price: ''),
          UiUtils.setDivider(context: context),
          setServiceRowValues(
              title: "totalServicePriceLbl".translate(context: context),
              quantity: totalServiceQuantity.toString(),
              price: widget.bookingsModel.total!),
          if (widget.bookingsModel.promoDiscount != "0") ...[
            UiUtils.setDivider(context: context),
            setServiceRowValues(
                title: "couponDiscLbl".translate(context: context),
                quantity:
                    widget.bookingsModel.promoCode == "" ? "--" : widget.bookingsModel.promoCode!,
                price: widget.bookingsModel.promoDiscount!),
          ],

          UiUtils.setDivider(context: context),
          /* setServiceRowValues(
              title: "taxLbl".translate(context: context),
              quantity: "",
              */ /*widget.bookingsModel.taxPercentage!*/ /*
              price: widget.bookingsModel.taxAmount!),*/
          // UiUtils.setDivider(context: context),
          setServiceRowValues(
              title: "visitingCharge".translate(context: context),
              quantity: "",
              price: widget.bookingsModel.visitingCharges!),
          UiUtils.setDivider(context: context),
          setServiceRowValues(
              title: "totalAmtLbl".translate(context: context),
              quantity: '',
              isTitleBold: true,
              price: widget.bookingsModel.finalTotal!),
        ],
      ),
    );
  }
}
