import 'package:cached_network_image/cached_network_image.dart';
import 'package:edemand_partner/data/model/reviews_model.dart';
import 'package:edemand_partner/ui/widgets/starRating.dart';
import 'package:edemand_partner/utils/colorPrefs.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:edemand_partner/utils/uiUtils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatefulWidget {
  final ReviewsModel reviewDetails;
  final int startFrom;

  const ImagePreview({Key? key, required this.reviewDetails, required this.startFrom})
      : super(key: key);

  @override
  State<ImagePreview> createState() => _ImagePreviewState();

  static Route route(RouteSettings settings) {
    Map arguments = settings.arguments as Map;
    return CupertinoPageRoute(builder: ((context) {
      return ImagePreview(
          reviewDetails: arguments['reviewDetails'], startFrom: arguments['startFrom']);
    }));
  }
}

class _ImagePreviewState extends State<ImagePreview> with TickerProviderStateMixin {
  //
  ValueNotifier<bool> isShowData = ValueNotifier(true);

//
  late final AnimationController animationController =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
  late final Animation<double> opacityAnimation = Tween<double>(
    begin: 1,
    end: 0,
  ).animate(CurvedAnimation(
    parent: animationController,
    curve: Curves.linear,
  ));

  //
  late final PageController _pageController = PageController(initialPage: widget.startFrom);

  @override
  void dispose() {
    isShowData.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: widget.reviewDetails.images!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    isShowData.value = !isShowData.value;

                    if (isShowData.value) {
                      animationController.forward();
                    } else {
                      animationController.reverse();
                    }
                  },
                  child: CachedNetworkImage(imageUrl: widget.reviewDetails.images![index]),
                );
              },
            ),
            PositionedDirectional(
              start: 5,
              top: 10,
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) => Opacity(
                    opacity: opacityAnimation.value,
                    child: Container(
                        height: 35,
                        width: 35,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondaryColor.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Center(
                              child: UiUtils.setSVGImage("backArrow", height: 25, width: 25),
                            )))),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: AnimatedBuilder(
                animation: animationController,
                builder: (context, child) => Opacity(
                  opacity: opacityAnimation.value,
                  child: Container(
                    constraints:
                        BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.3),
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).colorScheme.blackColor.withOpacity(0.35),
                            offset: const Offset(0, 0.75),
                            spreadRadius: 5,
                            blurRadius: 25)
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        CircleAvatar(
                          minRadius: 15,
                          maxRadius: 20,
                          child:
                              CachedNetworkImage(imageUrl: widget.reviewDetails.profileImage ?? ""),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        SingleChildScrollView(
                          clipBehavior: Clip.none,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                widget.reviewDetails.comment ?? "",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondaryColor,
                                    fontSize: 14),
                              ),
                              StarRating(
                                  rating: double.parse(widget.reviewDetails.rating!),
                                  onRatingChanged: (rating) => rating),
                              Text(
                                "${widget.reviewDetails.userName ?? ""}, ${widget.reviewDetails.ratedOn!.convertToAgo(context: context)}",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.secondaryColor,
                                    fontSize: 12),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
