import 'package:cached_network_image/cached_network_image.dart';
import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/model/reviews_model.dart';
import 'package:edemand_partner/data/model/service_model.dart';
import 'package:edemand_partner/ui/widgets/customContainer.dart';
import 'package:edemand_partner/ui/widgets/customIconButton.dart';
import 'package:edemand_partner/ui/widgets/customShimmerContainer.dart';
import 'package:edemand_partner/ui/widgets/customText.dart';
import 'package:edemand_partner/ui/widgets/shimmerLoadingContainer.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/cubits/fetchServiceReviewsCubit.dart';
import '../../../utils/uiUtils.dart';
import '../../widgets/RatingBar.dart';

class ServiceDetails extends StatefulWidget {
  final ServiceModel service;
  const ServiceDetails({
    Key? key,
    required this.service,
  }) : super(key: key);

  @override
  ServiceDetailsState createState() => ServiceDetailsState();
  static Route<ServiceDetails> route(RouteSettings routeSettings) {
    Map arguments = routeSettings.arguments as Map;

    return CupertinoPageRoute(
      builder: (_) => ServiceDetails(
        service: arguments['serviceModel'],
      ), //pass Selected category id from Previous screen
    );
  }
}

class ServiceDetailsState extends State<ServiceDetails> {
  Map<String, String> allowNotAllowFilter = {"0": "Not Allowed", "1": "Allowed"};
  @override
  void initState() {
    context.read<FetchServiceReviewsCubit>().fetchReviews(int.parse(widget.service.id!));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        elevation: 0,
        title: CustomText(
          titleText: "serviceDetailsLbl".translate(context: context),
          fontSize: 20,
          fontWeight: FontWeight.w700,
          fontColor: Theme.of(context).colorScheme.blackColor,
        ),
        leading: UiUtils.setBackArrow(
          context,
        ),
      ),
      body: mainWidget(),
    );
  }

  Widget mainWidget() {
    return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        physics: const AlwaysScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            summaryWidget(),
            const SizedBox(height: 15.0),
            descriptionWidget(),
            const SizedBox(height: 15.0),
            durationWidget(),
            const SizedBox(height: 15.0),
            serviceDetailsWidget(),
            const SizedBox(height: 15.0),
            setRatingsAndReviews()
          ],
        ));
  }

  Widget summaryWidget() {
    return CustomContainer(
      cornerRadius: 15,
      height: 127.rh(context),
      bgColor: Theme.of(context).colorScheme.secondaryColor,
      padding: const EdgeInsets.all(10),
      child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: UiUtils.setNetworkImage(widget.service.imageOfTheService!,
                        ww: 70, hh: 90))),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    titleText: widget.service.title!.firstUpperCase(),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    fontColor: Theme.of(context).colorScheme.blackColor,
                  ),
                  setStars(double.parse(widget.service.rating!), atCenter: Alignment.centerLeft),
                  CustomText(
                    titleText:
                        "${"reviewsTab".translate(context: context)} (${widget.service.numberOfRatings})",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontColor: Theme.of(context).colorScheme.blackColor,
                  ),
                  if (widget.service.discountedPrice != "0") ...[
                    Row(
                      children: [
                        CustomText(
                          titleText: "discountPriceLbl".translate(context: context),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          fontColor: Theme.of(context).colorScheme.blackColor,
                        ),
                        CustomText(
                          titleText: UiUtils.getPriceFormat(
                              context, double.parse(widget.service.discountedPrice!)),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          fontColor: Theme.of(context).colorScheme.blackColor,
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                  Row(
                    children: [
                      CustomText(
                        titleText: "totalPriceLbl".translate(context: context),
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        fontColor: Theme.of(context).colorScheme.blackColor,
                      ),
                      CustomText(
                        titleText:
                            UiUtils.getPriceFormat(context, double.parse(widget.service.price!)),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontColor: Theme.of(context).colorScheme.blackColor,
                      )
                    ],
                  ),
                ],
              ),
            )
          ]),
    );
  }

  Widget setStars(double ratings, {required Alignment atCenter}) {
    return RatingBar.readOnly(
      initialRating: ratings, //add value from Category Modal
      isHalfAllowed: true,
      halfFilledIcon: Icons.star_half,
      filledIcon: Icons.star_rounded,
      emptyIcon: Icons.star_border_rounded,
      filledColor: ColorPrefs.starRatingColor,
      halfFilledColor: ColorPrefs.starRatingColor,
      emptyColor: Theme.of(context).colorScheme.lightGreyColor,
      aligns: atCenter, //Alignment.center,
      onRatingChanged: (double rating) {},
    );
  }

  Widget descriptionWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).colorScheme.secondaryColor,
      ),
      constraints: const BoxConstraints(minHeight: 100, maxHeight: double.infinity),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            titleText: "descriptionLbl".translate(context: context),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontColor: Theme.of(context).colorScheme.blackColor,
          ),
          Divider(color: Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.4)),
          CustomText(
            titleText: widget.service.description!,
            fontSize: 14,
            maxLines: 4,
            fontWeight: FontWeight.w400,
            fontColor: Theme.of(context).colorScheme.blackColor,
          )
        ],
      ),
    );
  }

  Widget durationWidget() {
    return CustomContainer(
        height: MediaQuery.of(context).size.height * 0.12,
        cornerRadius: 15,
        bgColor: Theme.of(context).colorScheme.secondaryColor,
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              titleText: "durationLbl".translate(context: context),
              fontSize: 19,
              fontWeight: FontWeight.w700,
              fontColor: Theme.of(context).colorScheme.blackColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  titleText: "durationDescrLbl".translate(context: context),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontColor: Theme.of(context).colorScheme.blackColor,
                ),
                CustomText(
                  titleText: "${widget.service.duration!} ${"minutes".translate(context: context)}",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  fontColor: Theme.of(context).colorScheme.blackColor,
                ),
              ],
            )
          ],
        ));
  }

  Widget serviceDetailsWidget() {
    return CustomContainer(
      height: MediaQuery.of(context).size.height * 0.29,
      bgColor: Theme.of(context).colorScheme.secondaryColor,
      cornerRadius: 15,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            titleText: "serviceDetailsLbl".translate(context: context),
            fontWeight: FontWeight.w700,
            fontColor: Theme.of(context).colorScheme.blackColor,
            fontSize: 18,
          ),
          setKeyValueRow(
              key: "statusLbl".translate(context: context), value: widget.service.status!),
          setKeyValueRow(
              key: "cancelableBeforeLbl".translate(context: context),
              value: "${widget.service.cancelableTill!} ${"minutes".translate(context: context)}"),
          setKeyValueRow(
              key: "isCancelableLbl".translate(context: context),
              value: allowNotAllowFilter[widget.service.isCancelable!]!),
          setKeyValueRow(
              key: "isPayLaterAllowed".translate(context: context),
              value: allowNotAllowFilter[widget.service.isPayLaterAllowed!]!),
          setKeyValueRow(
              key: "taxTypeLbl".translate(context: context),
              value: widget.service.taxType!.firstUpperCase()),
        ],
      ),
    );
  }

  Widget setKeyValueRow({required String key, required String value}) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          titleText: key,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontColor: Theme.of(context).colorScheme.blackColor,
        ),
        CustomText(
          titleText: value,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontColor: Theme.of(context).colorScheme.blackColor,
        ),
      ],
    );
  }

  Widget setRatingsAndReviews() {
    return BlocBuilder<FetchServiceReviewsCubit, FetchServiceReviewsState>(
      builder: (context, state) {
        if (state is FetchServiceReviewsInProgress) {
          return const ShimmerLoadingContainer(
              child: CustomShimmerContainer(
            height: 100,
          ));
        }

        if (state is FetchServiceReviewsFailure) {
          return Container();
        }

        if (state is FetchServiceReviewsSuccess) {
          if (state.reviews.isEmpty) {
            return Container();
          }
          return CustomContainer(
            bgColor: Theme.of(context).colorScheme.secondaryColor,
            cornerRadius: 15,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  titleText: "reviewsRatingsLbl".translate(context: context),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontColor: Theme.of(context).colorScheme.blackColor,
                ),
                Divider(color: Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.4)),
                ratingsWidget(state),
                Divider(color: Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.4)),
                ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    // padding: const EdgeInsets.only(top: 5, bottom: 5),
                    physics: const NeverScrollableScrollPhysics(),
                    clipBehavior: Clip.none,
                    itemBuilder: (context, index) {
                      ReviewsModel rating = state.reviews[index];
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start, //spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                // backgroundColor: ColorPrefs.blueColor,
                                child: ClipOval(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: UiUtils.setNetworkImage(rating.profileImage!),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: CustomText(
                                              fontColor: Theme.of(context).colorScheme.blackColor,
                                              titleText: rating.userName!),
                                        ),
                                        SizedBox(
                                          height: 20,
                                          width: 45,
                                          child: CustomIconButton(
                                            borderRadius: 5,
                                            imgName: 'star',
                                            titleText: rating.rating!,
                                            fontSize: 10,
                                            titleColor:
                                                Theme.of(context).colorScheme.secondaryColor,
                                            bgColor: Theme.of(context).colorScheme.headingFontColor,
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    CustomText(
                                      titleText: rating.ratedOn!,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10,
                                      fontColor: Theme.of(context).colorScheme.lightGreyColor,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    CustomText(
                                      titleText: rating.comment!,
                                      maxLines: 2,
                                      fontSize: 12,
                                      fontColor: Theme.of(context).colorScheme.lightGreyColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          if (rating.images!.isNotEmpty)
                            SizedBox(height: 65, child: setReviewImages(reviewDetails: rating)),
                        ],
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: Theme.of(context).colorScheme.lightGreyColor.withOpacity(0.4),
                      );
                    },
                    itemCount: state.reviews.length),
              ],
            ),
          );
        }

        return Container();
      },
    );
  }

  Widget setReviewImages({required ReviewsModel reviewDetails}) {
    return ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      children: List.generate(
          reviewDetails.images!.length,
          (index) => InkWell(
                onTap: () => Navigator.pushNamed(context, Routes.imagePreviewScreen,
                    arguments: {"reviewDetails": reviewDetails, "startFrom": index}),
                child: Container(
                  height: 55,
                  width: 55,
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: reviewDetails.images![index],
                  ),
                ),
              )),
    );
  }

  Widget ratingsWidget(FetchServiceReviewsSuccess state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(titleText: state.ratings.averageRating.toString()),
        setStars(double.parse(state.ratings.averageRating!), atCenter: Alignment.center),
        CustomText(
          titleText: "${"reviewsTab".translate(context: context)} (${state.ratings.totalRatings})",
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontColor: Theme.of(context).colorScheme.blackColor,
        ),
      ],
    );
  }
}
