import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../data/cubits/time_slots_cubit.dart';
import '../../../utils/uiUtils.dart';
import '../error_container.dart';

class CalenderBottomSheet extends StatefulWidget {
  final String advanceBookingDays;

  const CalenderBottomSheet({Key? key, required this.advanceBookingDays}) : super(key: key);

  @override
  State<CalenderBottomSheet> createState() => _CalenderBottomSheetState();
}

class _CalenderBottomSheetState extends State<CalenderBottomSheet> with TickerProviderStateMixin {
  PageController _pageController = PageController();
  List<String> listOfMonth = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

  List<String> listOfYear = ["2022", "2023", "2024", "2025", "2026", "2027", "2028", "2029", "2030"];
  String? selectedMonth;
  String? selectedYear;
  late DateTime focusDate, selectedDate;
  String? selectedTime;
  int? selectedTimeSlotIndex;

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<Offset> calenderAnimation = Tween<Offset>(
    begin: const Offset(0.0, 0.0),
    end: const Offset(-1, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  late final Animation<Offset> timeSlotAnimation = Tween<Offset>(
    begin: const Offset(1.0, 0.0),
    end: const Offset(0, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
  ));

  TextStyle _getDayHeadingStyle() {
    return const TextStyle(color: Color(0xff343f53), fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 22.0);
  }

  void fetchTimeSlots() {
    context.read<TimeSlotCubit>().getTimeslotDetails(selectedDate: selectedDate);
  }

  @override
  void initState() {
    focusDate = DateTime.now();
    selectedDate = DateTime.now();
    selectedMonth = listOfMonth[DateTime.now().month - 1];
    selectedYear = listOfYear[0];

    Future.delayed(Duration.zero).then((value) {
      fetchTimeSlots();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop({'selectedDate': selectedDate, 'selectedTime': selectedTime});
        return true;
      },
      child: StatefulBuilder(builder: (context, setStater) {
        return SizedBox(
          child: Stack(
            children: [
              SlideTransition(
                position: calenderAnimation,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _getSelectDateHeadingWithMonthAndYear(),
                                //   _getSelectDateHeading(),
                                _getCalender(setStater),

                                _getSelectedDateContainer(),
                              ],
                            ),
                          ),
                        ),
                        _getCloseAndTimeSlotNavigateButton()
                      ],
                    ),
                  ),
                ),
              ),
              SlideTransition(
                position: timeSlotAnimation,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getSelectTimeSlotHeadingWithDate(),
                      Expanded(
                        child: BlocConsumer<TimeSlotCubit, TimeSlotState>(
                          listener: (context, state) {
                            if (state is TimeSlotFetchSuccess) {
                              if (state.isError) {
                                UiUtils.showMessage(context, state.message, MessageType.warning);
                              }
                            }
                            if (state is TimeSlotFetchFailure) {
                              UiUtils.showMessage(context, state.errorMessage, MessageType.warning);
                            }
                          },
                          builder: (context, state) {
                            //timeslot background color
                            Color disabledTimeSlotColor = Theme.of(context).colorScheme.lightGreyColor;
                            Color selectedTimeSlotColor = Theme.of(context).colorScheme.headingFontColor;
                            Color defaultTimeSlotColor = Theme.of(context).colorScheme.secondaryColor;

                            //timeslot text color
                            Color disabledTimeSlotTextColor = Theme.of(context).colorScheme.blackColor;
                            Color selectedTimeSlotTextColor = Theme.of(context).colorScheme.secondaryColor;
                            Color defaultTimeSlotTextColor = Theme.of(context).colorScheme.blackColor;

                            if (state is TimeSlotFetchSuccess) {
                              return state.isError
                                  ? Center(
                                      child: Text(state.message),
                                    )
                                  : GridView.builder(
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
                                      itemCount: state.slotsData.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1, crossAxisSpacing: 10, mainAxisSpacing: 20, mainAxisExtent: 35),
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (state.slotsData[index].isAvailable == 0) {
                                              return;
                                            }
                                            selectedTime = state.slotsData[index].time;
                                            selectedTimeSlotIndex = index;
                                            setState(() {});
                                          },
                                          child: Container(
                                              width: 150,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: state.slotsData[index].isAvailable == 0
                                                    ? disabledTimeSlotColor
                                                    : selectedTimeSlotIndex == index
                                                        ? selectedTimeSlotColor
                                                        : defaultTimeSlotColor,
                                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  state.slotsData[index].time,
                                                  style: TextStyle(
                                                    color: state.slotsData[index].isAvailable == 0
                                                        ? disabledTimeSlotTextColor
                                                        : selectedTimeSlotIndex == index
                                                            ? selectedTimeSlotTextColor
                                                            : defaultTimeSlotTextColor,
                                                  ),
                                                ),
                                              )),
                                        );
                                      });
                            }
                            if (state is TimeSlotFetchFailure) {
                              return Center(child: ErrorContainer(showRetryButton: false, errorMessage: state.errorMessage.toString()));
                              // return ErrorContainer(
                              //     onTapRetry: () {
                              //       fetchTimeSlots();
                              //     },
                              //     errorMessage: UiUtils.getTranslatedLabel(
                              //         context, "somethingWentWrong"));
                            }
                            return Center(
                              child: Text("loading".translate(context: context)),
                            );
                          },
                        ),
                      ),
                      _getSelectedCustomTimeSlotContainer(),
                      _getBackAndContinueNavigateButton()
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

//
  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() {
        selectedTime = "${time.hour}:${time.minute}:00";
        selectedTimeSlotIndex = null;
      });
    }
  }

  //
  Widget _getSelectedCustomTimeSlotContainer() {
    return Container(
      margin: const EdgeInsetsDirectional.only(bottom: 5),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 65,
      decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(13)), color: Theme.of(context).colorScheme.secondaryColor),
      child: Center(
        child: GestureDetector(
          onTap: () {
            displayTimePicker(context);
          },
          child: Text(
            selectedTime != null ? "$selectedTime" : "checkOnCustomTime".translate(context: context),
            style: TextStyle(color: Theme.of(context).colorScheme.headingFontColor, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget _getSelectDateHeading() {
    return Text("selectDate".translate(context: context),
        style: TextStyle(
          color: Theme.of(context).colorScheme.headingFontColor,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.normal,
          fontSize: 20.0,
        ),
        textAlign: TextAlign.start);
  }

  Widget _getSelectTimeSlotHeadingWithDate() {
    String monthName = listOfMonth[selectedDate.month - 1];
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 15, start: 15, end: 15),
      child: Row(
        children: [
          Text("selectTimeSlot".translate(context: context),
              style: const TextStyle(color: Color(0xff343f53), fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 20.0), textAlign: TextAlign.center),
          const Spacer(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(7)), border: Border.all(color: const Color(0xff838383), width: 1)),
            height: 30,
            width: 110,
            child: Center(child: Text('${selectedDate.day}-$monthName-${selectedDate.year}')),
          ),
        ],
      ),
    );
  }

  Widget _getSelectDateHeadingWithMonthAndYear() {
    return Row(
      children: [
        Text("selectDate".translate(context: context),
            style: TextStyle(color: Theme.of(context).colorScheme.headingFontColor, fontWeight: FontWeight.w500, fontStyle: FontStyle.normal, fontSize: 20.0), textAlign: TextAlign.center),
        const Spacer(),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(7)), border: Border.all(color: const Color(0xff838383), width: 1)),
              height: 30,
              width: 70,
              child: Center(child: Text('$selectedMonth')),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(borderRadius: const BorderRadius.all(Radius.circular(7)), border: Border.all(color: const Color(0xff838383), width: 1)),
              height: 30,
              width: 70,
              child: Center(child: Text('$selectedYear')),
            ),
            //
            //dropdown to select month and year
            //
            /* Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                  border: Border.all(color: const Color(0xff838383), width: 1)),
              height: 30,
              width: 70,
              child: DropdownButtonFormField(
                iconSize: 18,
                menuMaxHeight: 300,
                isDense: true,
                alignment: Alignment.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                value: selectedMonth,
                onChanged: (newValue) {
                  int index = listOfMonth.indexOf(newValue.toString()) + 1;
                  setState(() {
                    String newIndex = index.toString().padLeft(2, "0");
                    focusDate = DateTime.parse(
                        "$selectedYear-$newIndex-01 00:00:00.000Z");
                    selectedMonth = newValue.toString();
                  });

                },
                items: List.generate(
                    listOfMonth.length,
                    (index) => DropdownMenuItem(
                          alignment: Alignment.center,
                          value: listOfMonth[index],
                          child: Text(
                            listOfMonth[index],
                            style: const TextStyle(fontSize: textFontSizeOf12),
                          ),
                        )),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(7)),
                  border: Border.all(color: const Color(0xff838383), width: 1)),
              height: 30,
              width: 70,
              child: DropdownButtonFormField(
                iconSize: 18,
                menuMaxHeight: 300,
                isDense: true,
                alignment: Alignment.center,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                value: selectedYear,
                onChanged: (newSelectedYear) {
                  int indexOfSelectedMonth =
                      listOfMonth.indexOf(selectedMonth!) + 1;

                  String newIndex =
                      indexOfSelectedMonth.toString().padLeft(2, "0");
                  setState(() {
                    focusDate = DateTime.parse(
                        "${newSelectedYear.toString()}-$newIndex-01 00:00:00.000Z");
                    selectedYear = newSelectedYear.toString();
                  });
                },
                items: List.generate(
                    listOfYear.length,
                    (index) => DropdownMenuItem(
                          alignment: Alignment.center,
                          value: listOfYear[index],
                          child: Text(
                            listOfYear[index],
                            style: const TextStyle(fontSize: textFontSizeOf12),
                          ),
                        )),
              ),
            ),*/
          ],
        )
      ],
    );
  }

  Widget _getCalender(StateSetter setStater) {
    return Flexible(
      flex: 1,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: TableCalendar(
          onCalendarCreated: (pageController) {
            _pageController = pageController;
          },
          headerVisible: false,
          currentDay: selectedDate,
          onPageChanged: (date) {
            //
            //add 0, if month is 1,2,3...9, to make it as 01,02...09 digit
            String newIndex = (date.month).toString().padLeft(2, "0");

            selectedYear = date.year.toString();
            selectedMonth = listOfMonth[date.month - 1];
            //we are adding first date of month as focusDate
            focusDate = DateTime.parse("${selectedYear.toString()}-$newIndex-01 00:00:00.000Z");
            //
            //If focus date is before of current date then we will add current date as focus date
            if (focusDate.isBefore(DateTime.now())) {
              focusDate = DateTime.now();
            }
            setState(() {});
          },
          onDaySelected: (date, date1) {
            //  focusDate = DateTime.parse(date.toString());
            selectedDate = DateTime.parse(date.toString());
            setStater(() {});
            fetchTimeSlots();
          },
          pageAnimationEnabled: true,
          firstDay: DateTime.now(),
          lastDay: DateTime.now().add(Duration(days: int.parse(widget.advanceBookingDays))),
          focusedDay: focusDate,
          daysOfWeekHeight: 50,
          daysOfWeekStyle: DaysOfWeekStyle(
            dowTextFormatter: (date, locale) => DateFormat.E(locale).format(date)[0],
            weekendStyle: _getDayHeadingStyle(),
            weekdayStyle: _getDayHeadingStyle(),
          ),
        ),
      ),
    );
  }

  Widget _getSelectedDateContainer() {
    String monthName = listOfMonth[selectedDate.month - 1];
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: 50,
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(13)), color: Color(0xfff2f1f6)),
      child: Center(
        child: Text(
          "${selectedDate.day}-$monthName-${selectedDate.year}",
          style: const TextStyle(color: Color(0xff343f53), fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 18),
        ),
      ),
    );
  }

  _getCloseAndTimeSlotNavigateButton() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop({'selectedDate': selectedDate, 'selectedTime': selectedTime});
            },
            child: Container(
                height: 44,
                decoration:
                    BoxDecoration(boxShadow: const [BoxShadow(color: Color(0x1c343f53), offset: Offset(0, -3), blurRadius: 10, spreadRadius: 0)], color: Theme.of(context).colorScheme.secondaryColor),
                child: Center(
                  child: Text(
                    "close".translate(context: context),
                    style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 14.0),
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              _controller.forward();
            },
            child: Container(
                height: 44,
                decoration: BoxDecoration(
                  boxShadow: const [BoxShadow(color: Color(0x1c343f53), offset: Offset(0, -3), blurRadius: 10, spreadRadius: 0)],
                  color: Theme.of(context).colorScheme.headingFontColor,
                ),
                child: // Apply Filter
                    Center(
                  child: Text(
                    "selectTimeSlot".translate(context: context),
                    style: TextStyle(color: Theme.of(context).colorScheme.secondaryColor, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 14.0),
                  ),
                )),
          ),
        )
      ],
    );
  }

  _getBackAndContinueNavigateButton() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              _controller.reverse();
            },
            child: Container(
                height: 44,
                decoration:
                    BoxDecoration(boxShadow: const [BoxShadow(color: Color(0x1c343f53), offset: Offset(0, -3), blurRadius: 10, spreadRadius: 0)], color: Theme.of(context).colorScheme.secondaryColor),
                child: Center(
                  child: Text(
                    "back".translate(context: context),
                    style: TextStyle(color: Theme.of(context).colorScheme.blackColor, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 14.0),
                  ),
                )),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop({'selectedDate': selectedDate, 'selectedTime': selectedTime});
            },
            child: Container(
                height: 44,
                decoration: BoxDecoration(
                    boxShadow: const [BoxShadow(color: Color(0x1c343f53), offset: Offset(0, -3), blurRadius: 10, spreadRadius: 0)], color: Theme.of(context).colorScheme.headingFontColor),
                child: Center(
                  child: Text(
                    "continue".translate(context: context),
                    style: TextStyle(color: Theme.of(context).colorScheme.secondaryColor, fontWeight: FontWeight.w700, fontStyle: FontStyle.normal, fontSize: 14.0),
                  ),
                )),
          ),
        )
      ],
    );
  }
}
