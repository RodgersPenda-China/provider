import 'package:edemand_partner/data/cubits/fetch_bookings_cubit.dart';
import 'package:edemand_partner/data/model/booking_model.dart';
import 'package:edemand_partner/ui/widgets/customContainer.dart';
import 'package:edemand_partner/ui/widgets/customShimmerContainer.dart';
import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/ui/widgets/shadowButton.dart';
import 'package:edemand_partner/ui/widgets/shimmerLoadingContainer.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/routes.dart';
import '../widgets/error_container.dart';
import '../widgets/no_data_container.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> with AutomaticKeepAliveClientMixin {
  int currFilter = 0;

//test  only
  DateTime currDate = DateTime.now(); //remove
  TimeOfDay currTime = TimeOfDay.now(); //remove

  List<Map> filters = []; //set  model  from  API  Response

  @override
  void didChangeDependencies() {
    filters = [
      {'id': '0', 'fName': "all".translate(context: context)},
      {'id': '1', 'fName': "awaiting".translate(context: context)},
      {'id': '2', 'fName': "confirmed".translate(context: context)},
      {'id': '3', 'fName': "rescheduled".translate(context: context)},
      {'id': '4', 'fName': "completed".translate(context: context)},
      {'id': '5', 'fName': "cancelled".translate(context: context)},
    ];
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    filters = [
      {'id': '0', 'fName': "all".translate(context: context)},
      {'id': '1', 'fName': "awaiting".translate(context: context)},
      {'id': '2', 'fName': "confirmed".translate(context: context)},
      {'id': '3', 'fName': "rescheduled".translate(context: context)},
      {'id': '4', 'fName': "completed".translate(context: context)},
      {'id': '5', 'fName': "cancelled".translate(context: context)},
    ];
    return DefaultTabController(
      length: filters.length,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: UiUtils.getSystemUiOverlayStyle(context: context),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.primaryColor,
              flexibleSpace: _buildTabBar(context),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryColor,
            body: const TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                BookingsTabContent(
                  status: null,
                ),
                BookingsTabContent(
                  status: "awaiting",
                ),
                BookingsTabContent(
                  status: "confirmed",
                ),
                BookingsTabContent(
                  status: "rescheduled",
                ),
                BookingsTabContent(
                  status: "completed",
                ),
                BookingsTabContent(
                  status: "cancelled",
                )
              ],
            )),
      ),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      isScrollable: true,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      labelColor: Theme.of(context).colorScheme.primaryColor,
      unselectedLabelColor: Theme.of(context).colorScheme.blackColor,
      indicator: ShapeDecoration(
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          color: Theme.of(context).colorScheme.accentColor,
          shadows: [
            BoxShadow(
                blurRadius: 1,
                color: Theme.of(context).colorScheme.blackColor.withOpacity(0.3),
                offset: const Offset(0, 1))
          ]),
      tabs: filters.map((e) => Tab(text: e['fName'])).toList(),
    );
  }

  Widget filtersListView() {
    return SizedBox(
      height: 60.rh(context),
      child: ListView.separated(
          clipBehavior: Clip.none,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.all(5.0),
              child: ShadowButton(
                  height: 43.rh(context),
                  width: MediaQuery.of(context).size.width * 0.45,
                  backgroundColor: (index == currFilter)
                      ? Theme.of(context).colorScheme.headingFontColor
                      : Theme.of(context).colorScheme.blackColor,
                  fontColor: (index == currFilter)
                      ? Theme.of(context).colorScheme.secondaryColor
                      : Theme.of(context).colorScheme.headingFontColor,
                  text: filters[index]['fName'],
                  shadowOFF: (index == currFilter) ? false : true,
                  onPressed: () {
                    setState(() {
                      currFilter = index;
                      //also  reload  List  values  below  with  selected  Filter
                    });
                  }),
            );
          },
          separatorBuilder: ((context, index) => const SizedBox(
                width: 5,
              )),
          scrollDirection: Axis.horizontal,
          itemCount: filters.length),
    );
  }

  Widget setUserImageWithStatus({required String imageUrl, required String status}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
            child: CircleAvatar(
                radius: 30,
                //  backgroundColor:  ColorPrefs.blueColor,
                child: ClipOval(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: UiUtils.setNetworkImage(imageUrl)))),
        const SizedBox(height: 8),
        setStatus(status),
      ],
    );
  }

  Widget setIconAndText({required String iconName, required String txtVal}) {
    return Row(
      //  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
      children: [
        UiUtils.setSVGImage(iconName),
        const SizedBox(width: 2),
        CustomText(
          fontColor: Theme.of(context).colorScheme.blackColor,

          titleText: txtVal,
          //'formatted  date',
          fontSize: 12,
          textAlign: TextAlign.start,
          fontWeight: FontWeight.w400,
        )
      ],
    );
  }

  Widget setStatus(String status) {
    var statusVal = '';
    return Container(
      decoration: BoxDecoration(
          color: setStatusColor(int.parse(statusVal)), borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CustomText(
          titleText: status, //set  from  API  Response
          fontSize: 12,
          fontWeight: FontWeight.bold,
          fontColor: setStatusColor(int.parse(statusVal)).withOpacity(1.0),
          //change  fontColor  as  required  -  currently  set  as  per  Design
        ),
      ),
    );
  }

  ///Set  color  according  to  status  -  confirmed,rescheduled,cancelled,etc..
  Color setStatusColor(int statusVal) {
    Color stColor = ColorPrefs.greenColor;
    switch (statusVal) {
      case 2: //Rescheduled
        stColor = Theme.of(context).colorScheme.accentColor.withOpacity(0.5);
        break;
      case 3: //Cancelled
        stColor = ColorPrefs.redColor.withOpacity(0.5);
        break;
      default: //Confirmed
        stColor = ColorPrefs.greenColor.withOpacity(0.5);
        break;
    }
    return stColor;
  }

  @override
  bool get wantKeepAlive => true;
}

class BookingsTabContent extends StatefulWidget {
  final String? status;

  const BookingsTabContent({super.key, this.status});

  @override
  State<BookingsTabContent> createState() => _BookingsTabContentState();
}

class _BookingsTabContentState extends State<BookingsTabContent> {
  late final ScrollController _pageScrollcontroller = ScrollController()
    ..addListener(pageScrollListen);

  pageScrollListen() {
    if (_pageScrollcontroller.isEndReached()) {
      if (context.read<FetchBookingsCubit>().hasMoreData()) {
        context.read<FetchBookingsCubit>().fetchMoreBookings(widget.status);
      }
    }
  }

  @override
  void initState() {
    context.read<FetchBookingsCubit>().fetchBookings(widget.status);
    super.initState();
  }

  Widget setUserImageWithStatus({required String imageUrl, required String status}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
            child: CircleAvatar(
                radius: 30,
                //  backgroundColor:  ColorPrefs.blueColor,
                child: ClipOval(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: UiUtils.setNetworkImage(
                      imageUrl,
                    )))),
        const SizedBox(height: 10),
        setStatus(status),
      ],
    );
  }

  Color setStatusColor(String statusVal) {
    Color stColor = ColorPrefs.greenColor;

    switch (statusVal) {
      case "rescheduled": //Rescheduled
        stColor = Theme.of(context).colorScheme.accentColor.withOpacity(0.5);
        break;
      case "rejected":

      case "cancelled": //Cancelled
        stColor = ColorPrefs.redColor.withOpacity(0.5);
        break;

      case "awaiting":
        stColor = const Color.fromARGB(255, 54, 209, 244).withOpacity(0.5);
        break;

      default: //Confirmed
        stColor = ColorPrefs.greenColor.withOpacity(0.5);
        break;
    }
    return stColor;
  }

  Widget setStatus(String status) {
    var statusVal = status;
    return Container(
      width: 85,
      decoration: BoxDecoration(
          color: setStatusColor(statusVal).withOpacity(0.3),
          borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CustomText(
          titleText: status.firstUpperCase(),
          //set  from  API  Response
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontColor: setStatusColor((statusVal)).withOpacity(1.0),
          textAlign: TextAlign.center,
          //change  fontColor  as  required  -  currently  set  as  per  Design
        ),
      ),
    );
  }

  Widget setDateTimeAndMoney({required BookingsModel bookingsModel}) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          children: [
            setIconAndText(
                iconName: 'b_clock', //'b_calendar',
                txtVal: bookingsModel.dateOfService ?? ""), //  use  bookingList[index]['date']
            const Text(","),
            setIconAndText(iconName: '', txtVal: bookingsModel.startingTime!),
            const Text("-"),
            Expanded(
              child: CustomText(
                titleText: bookingsModel.endingTime!,
                fontSize: 12,
                maxLines: 1,
                fontColor: Theme.of(context).colorScheme.blackColor,
              ),
            )
          ],
        ), //use  bookingList[index]['time']

        const SizedBox(width: 6),

        setIconAndText(
            iconName: 'b_money',
            isBold: true,
            txtVal:
                UiUtils.getPriceFormat(context, double.parse(bookingsModel.finalTotal.toString()))),
      ],
    );
  }

  Widget setIconAndText({required String iconName, required String txtVal, bool? isBold}) {
    return Row(
      //  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
      children: [
        if (iconName != "") ...{
          UiUtils.setSVGImage(iconName),
        },
        const SizedBox(width: 2),
        CustomText(
          fontColor: Theme.of(context).colorScheme.blackColor,
          titleText: txtVal,
          //'formatted  date',
          fontSize: 12,
          textAlign: TextAlign.start,
          fontWeight: (isBold ?? false) ? FontWeight.bold : FontWeight.w400,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<FetchBookingsCubit>().fetchBookings(widget.status);
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          controller: _pageScrollcontroller,
          physics: const BouncingScrollPhysics(),
          child: BlocBuilder<FetchBookingsCubit, FetchBookingsState>(
            builder: (context, state) {
              if (state is FetchBookingsInProgress) {
                return RefreshIndicator(
                  onRefresh: () async {
                    //  context
                    //          .read<FetchBookingsCubit>()
                    //          .fetchBookings(widget.status);
                  },
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsetsDirectional.all(16),
                    itemCount: 8,
                    physics: const NeverScrollableScrollPhysics(),
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
                );
              }

              if (state is FetchBookingsFailure) {
                return Center(
                    child: ErrorContainer(
                        onTapRetry: () {
                          context.read<FetchBookingsCubit>().fetchBookings(widget.status);
                        },
                        errorMessage: state.errorMessage.toString()));
              }
              if (state is FetchBookingsSuccess) {
                if (state.bookings.isEmpty) {
                  return NoDataContainer(titleKey: "noDataFound".translate(context: context));
                }

                return Column(
                  children: [
                    ListView.separated(
                      addAutomaticKeepAlives: false,
                      addRepaintBoundaries: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      itemCount: state.bookings.length,
                      physics: const NeverScrollableScrollPhysics(),
                      clipBehavior: Clip.none,
                      itemBuilder: (context, index) {
                        BookingsModel bookingModel = state.bookings[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.bookingDetails,
                                arguments: {"bookingsModel": bookingModel});
                            //  UiUtils.pushtoNextScreen(Routes.bookingDetails,
                            //  context);  //pass  current  Index  as  an  argument  here
                          },
                          child: CustomContainer(
                              height: 120,
                              padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
                              cornerRadius: 10,
                              bgColor: Theme.of(context).colorScheme.secondaryColor,
                              child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //crossAxisAlignment:  WrapCrossAlignment.center,
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: setUserImageWithStatus(
                                            imageUrl: bookingModel.profileImage ?? "",
                                            status: bookingModel.status ?? "")),
                                    //image  url  from  API  Response
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          CustomText(
                                            titleText: bookingModel.customer ?? "",
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                            fontColor: Theme.of(context).colorScheme.blackColor,
                                          ),
                                          CustomText(
                                            titleText: bookingModel.address ?? "",
                                            fontSize: 14,
                                            maxLines: 2,
                                            fontColor: Theme.of(context).colorScheme.blackColor,
                                          ),
                                          setDateTimeAndMoney(bookingsModel: bookingModel)
                                        ],
                                      ),
                                    )
                                  ])),
                        );
                      },
                      separatorBuilder: ((context, index) => SizedBox(
                            height: 10.rh(context),
                          )),
                    ),
                    if ((state).isLoadingMoreBookings)
                      CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.headingFontColor,
                      )
                  ],
                );
                //,);//Flexible
              }

              return Container();
            },
          ),
        ),
      ),
    );
  }
}
