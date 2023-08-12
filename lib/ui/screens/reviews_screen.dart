import 'package:cached_network_image/cached_network_image.dart';
import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/cubits/fetchReviewsCubit.dart';
import 'package:edemand_partner/data/model/reviews_model.dart';
import 'package:edemand_partner/ui/widgets/ProgressBar.dart';
import 'package:edemand_partner/ui/widgets/customShimmerContainer.dart';
import 'package:edemand_partner/ui/widgets/customTweenAnimation.dart';
import 'package:edemand_partner/ui/widgets/shimmerLoadingContainer.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/uiUtils.dart';
import '../widgets/RatingBar.dart';
import '../widgets/customContainer.dart';
import '../widgets/customIconButton.dart';
import '../widgets/customText.dart';
import '../widgets/error_container.dart';
import '../widgets/no_data_container.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({Key? key}) : super(key: key);

  @override
  ReviewsScreenState createState() => ReviewsScreenState();
}

class ReviewsScreenState extends State<ReviewsScreen> with AutomaticKeepAliveClientMixin {
  late final ScrollController _pageScrollController = ScrollController()
    ..addListener(pageScrollListen);

  // double progress = 0.5;
  double twoStarVal = 20;
  double avg = 0;

  @override
  void initState() {
    context.read<FetchReviewsCubit>().fetchReviews();

    super.initState();
  }

  void pageScrollListen() {
    if (_pageScrollController.isEndReached()) {
      if (context.read<FetchReviewsCubit>().hasMoreReviews()) {
        context.read<FetchReviewsCubit>().fetchMoreReviews();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: UiUtils.getSystemUiOverlayStyle(context: context),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primaryColor,
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<FetchReviewsCubit>().fetchReviews();
          },
          child: SingleChildScrollView(
            controller: _pageScrollController,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            clipBehavior: Clip.none,
            physics: const AlwaysScrollableScrollPhysics(),
            child: BlocBuilder<FetchReviewsCubit, FetchReviewsState>(
              builder: (context, state) {
                if (state is FetchReviewsSuccess) {}
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ratingsSummary(state),
                    buildWidget(state),
                    const SizedBox(
                      height: 5,
                    ),
                    if (state is FetchReviewsSuccess) ...[
                      if (state.isLoadingMoreReviews)
                        CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.headingFontColor,
                        )
                    ]
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget ratingsSummary(FetchReviewsState state) {
    if (state is FetchReviewsInProgress) {
      return const ShimmerLoadingContainer(
          child: CustomShimmerContainer(
        height: 125,
      ));
    }

    if (state is FetchReviewsSuccess) {
      double fiveStarPersontage = ((double.parse(state.ratings.rating5!) /
          double.parse(state.ratings.totalRatings!) *
          100));
      double fourStarPersontage = ((double.parse(state.ratings.rating4!) /
          double.parse(state.ratings.totalRatings!) *
          100));
      double threeStarPersontage = ((double.parse(state.ratings.rating3!) /
          double.parse(state.ratings.totalRatings!) *
          100));
      double twoStarPersontage = ((double.parse(state.ratings.rating2!) /
          double.parse(state.ratings.totalRatings!) *
          100));
      double oneStarPersontage = ((double.parse(state.ratings.rating1!) /
          double.parse(state.ratings.totalRatings!) *
          100));
      if (state.reviews.isEmpty) {
        return NoDataContainer(titleKey: "noDataFound".translate(context: context));
      }
      return CustomContainer(
        height: 125.rh(context),
        cornerRadius: 10,
        bgColor: Theme.of(context).colorScheme.headingFontColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            totalReviews(state),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                setLinearProgressIndicator(semanticLbl: '5star', progressVal: fiveStarPersontage),
                //Prefix of semanticLbl is used for caption before ProgressIndicator
                setLinearProgressIndicator(semanticLbl: '4star', progressVal: fourStarPersontage),
                setLinearProgressIndicator(semanticLbl: '3star', progressVal: threeStarPersontage),
                setLinearProgressIndicator(semanticLbl: '2star', progressVal: twoStarPersontage),
                setLinearProgressIndicator(
                  semanticLbl: '1star',
                  progressVal: oneStarPersontage,
                ),
              ],
            )
          ],
        ),
      );
    }
    return Container();
  }

  Widget totalReviews(FetchReviewsSuccess state) {
    return SizedBox(
      height: 80,
      width: 140,
      child: Column(
        children: [
          CustomText(
            titleText: state.ratings.averageRating.toString(),
            fontSize: 26,
            fontColor: Theme.of(context).colorScheme.secondaryColor,
          ),
          SizedBox(
            // color: ColorPrefs.whiteColor,
            child: RatingBar.readOnly(
              initialRating: double.parse(state.ratings.averageRating!),
              //2.5,
              isHalfAllowed: true,
              halfFilledIcon: Icons.star_half,
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              filledColor: ColorPrefs.starRatingColor,
              halfFilledColor: ColorPrefs.starRatingColor,
              emptyColor: ColorPrefs.starRatingColor,
              onRatingChanged: (double rating) {},
            ),
          ),
          CustomText(
            titleText:
                '${"totalReviewsLbl".translate(context: context)} (${state.ratings.totalRatings})',
            fontSize: 10,
            fontColor: Theme.of(context).colorScheme.secondaryColor,
          )
        ],
      ),
    );
  }

  Widget setLinearProgressIndicator({
    double height = 10,
    double width = 150,
    Color? bgColor,
    Animation<Color?>? valueColor = const AlwaysStoppedAnimation<Color>(ColorPrefs.greenColor),
    required double progressVal,
    required String semanticLbl,
  }) {
    return Wrap(
      spacing: 5,
      children: [
        CustomText(
          titleText: semanticLbl.substring(0, 1),
          fontColor: Theme.of(context).colorScheme.secondaryColor,
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
        SizedBox(
          height: height,
          width: width,
          child: CustomTweenAnimation(
              curve: Curves.fastLinearToSlowEaseIn,
              beginValue: 0,
              endValue: progressVal.isNaN ? 0 : progressVal,
              durationInSeconds: 1,
              builder: (context, value, child) => ProgressBar(
                    max: 100,
                    current: value.isNaN ? 0 : value,
                  )),
        ),
      ],
    );
  }

  Widget buildWidget(FetchReviewsState state) {
    if (state is FetchReviewsInProgress) {
      return ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          padding: const EdgeInsetsDirectional.only(top: 20),
          itemCount: 8,
          physics: const NeverScrollableScrollPhysics(),
          clipBehavior: Clip.none,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ShimmerLoadingContainer(
                  child: CustomShimmerContainer(
                height: 128.rh(context),
              )),
            );
          });
    }

    if (state is FetchReviewsFailure) {
      return Center(
          child: ErrorContainer(
              onTapRetry: () {
                context.read<FetchReviewsCubit>().fetchReviews();
              },
              errorMessage: state.errorMessage.toString()));
    }

    if (state is FetchReviewsSuccess) {
      return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsetsDirectional.only(top: 20),
        itemCount: state.reviews.length,
        physics: const NeverScrollableScrollPhysics(),
        clipBehavior: Clip.none,
        itemBuilder: (context, index) {
          ReviewsModel review = state.reviews[index];
          bool hasReviewText = state.reviews[index].comment?.isNotEmpty ?? false;
          return CustomContainer(
              padding: const EdgeInsetsDirectional.only(start: 10, end: 10, top: 8, bottom: 5),
              cornerRadius: 10,
              bgColor: Theme.of(context).colorScheme.secondaryColor,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      titleText: review.service_name!.firstUpperCase(),
                      fontSize: 14.0,
                      fontColor: Theme.of(context).colorScheme.accentColor,
                    ),
                  ),
                  UiUtils.setDivider(context: context, height: 1),
                  setDetailsRow(model: review, hasReviewText: hasReviewText),
                  if (review.images!.isNotEmpty)
                    SizedBox(height: 65, child: setReviewImages(reviewDetails: review)),
                ],
              ));
        },
        separatorBuilder: ((context, index) => const SizedBox(
              height: 10,
            )),
      );
    }
    return Container();
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

  Widget setDetailsRow({required ReviewsModel model, required bool hasReviewText}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              radius: 30,
              // backgroundColor: ColorPrefs.blueColor,
              child: ClipOval(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: UiUtils.setNetworkImage(model.profileImage!))),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  titleText: model.userName!,
                  fontSize: 14.rf(context),
                  fontWeight: FontWeight.normal,
                  fontColor: Theme.of(context).colorScheme.blackColor,
                ),
                if (hasReviewText) ...[
                  const SizedBox(height: 5),
                  CustomText(
                    titleText: model.comment!,
                    fontSize: 12.rf(context),
                    maxLines: 2,
                    fontColor: Theme.of(context).colorScheme.lightGreyColor,
                  ),
                  const SizedBox(height: 5),
                ] else ...[
                  const SizedBox(height: 10),
                ],
                CustomText(
                  titleText: model.ratedOn!,
                  fontSize: 10.rf(context),
                  fontColor: Theme.of(context).colorScheme.lightGreyColor,
                ),
              ],
            ),
          ),
          //Ratings
          SizedBox(
            height: 20,
            width: 50,
            child: CustomIconButton(
              onPressed: () {},
              imgName: 'star',
              titleText: model.rating!,
              fontSize: 10.0,
              borderRadius: 5,
              titleColor: Theme.of(context).colorScheme.secondaryColor,
              bgColor: Theme.of(context).colorScheme.headingFontColor,
              textDirection: TextDirection.rtl,
            ),
          ),
        ]);
  }

  @override
  bool get wantKeepAlive => true;
}
