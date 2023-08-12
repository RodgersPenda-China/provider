import 'package:edemand_partner/utils/responsiveSize.dart';
import 'package:edemand_partner/utils/stringExtension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cubits/fetch_notifications_cubit.dart';
import '../../utils/colorPrefs.dart';
import '../widgets/customShimmerContainer.dart';
import '../widgets/error_container.dart';
import '../widgets/no_data_container.dart';
import '../widgets/shimmerLoadingContainer.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  static Route route(RouteSettings routeSettings) {
    return CupertinoPageRoute(builder: (_) {
      return const NotificationScreen();
    });
  }

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  void fetchNotifications() {
    context.read<NotificationsCubit>().fetchNotifications();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) {
      fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryColor,
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsInProgress) {
            return ShimmerLoadingContainer(
                child: ListView(
              children: List.generate(
                  5,
                  (index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomShimmerContainer(
                          borderRadius: 16,
                          width: MediaQuery.of(context).size.width,
                          height: 92.rh(context),
                        ),
                      )).toList(),
            ));
          }
          if (state is NotificationFetchFailure) {
            return Center(
                child: ErrorContainer(
                    onTapRetry: () {
                      fetchNotifications();
                    },
                    errorMessage: state.toString()));
          }
          if (state is NotificationFetchSuccess) {
            if (state.notifications.isEmpty) {
              return NoDataContainer(titleKey: "noDataFound".translate(context: context));
            }

            return ListView.builder(
                itemCount: state.notifications.length,
                itemBuilder: (context, int i) {
                  return Container();
                  //  BlocProvider(
                  //   create: (context) => DeleteNotificationCubit(),
                  //   child: CustomSlidableTileContainer(
                  //       showBorder: state.notifications[i].isRead == '1'
                  //           ? true
                  //           : false,
                  //       imageURL: state.notifications[i].image,
                  //       title: state.notifications[i].title,
                  //       subTitle: state.notifications[i].message,
                  //       durationTitle: state.notifications[i].duration,
                  //       tileBackgroundColor:
                  //           state.notifications[i].isRead == '1'
                  //               ? Theme.of(context).colorScheme.primaryColor
                  //               : Theme.of(context)
                  //                   .colorScheme
                  //                   .secondaryColor,
                  //       slidableChild: BlocConsumer<DeleteNotificationCubit,
                  //               DeleteNotificationsState>(
                  //           listener: (context, removeNotificationState) {
                  //         if (removeNotificationState
                  //             is DeleteNotificationSuccess) {
                  //           UiUtils.showMessage(
                  //               context,
                  //               UiUtils.getTranslatedLabel(context,
                  //                   'notificationDeletedSuccessfully'),
                  //               MessageType.success);
                  //           context
                  //               .read<NotificationsCubit>()
                  //               .removeNotificationFromList(
                  //                   removeNotificationState.notificationId);
                  //         }
                  //       }, builder: (context, removeNotificationState) {
                  //         if (removeNotificationState
                  //             is DeleteNotificationInProgress) {
                  //           if (state.notifications[i].id ==
                  //               removeNotificationState.notificationId) {
                  //             return Center(
                  //               child: Container(
                  //                 color: Colors.transparent,
                  //                 child: Row(
                  //                   mainAxisAlignment:
                  //                       MainAxisAlignment.center,
                  //                   children: const [
                  //                     SizedBox(
                  //                       height: 20,
                  //                       width: 20,
                  //                       child: CircularProgressIndicator(
                  //                           color: Colors.white,
                  //                           strokeWidth: 2.0),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ),
                  //             );
                  //           }
                  //         }

                  //         return SlidableAction(
                  //           backgroundColor: Colors.transparent,
                  //           autoClose: false,
                  //           onPressed: (BuildContext context) {
                  //             context
                  //                 .read<DeleteNotificationCubit>()
                  //                 .deleteNotification(
                  //                     state.notifications[i].id);
                  //           },
                  //           icon: Icons.delete,
                  //           label: UiUtils.getTranslatedLabel(
                  //               context, "delete"),
                  //           borderRadius: BorderRadius.circular(16),
                  //         );
                  //       })),
                  // );
                });
          }
          return Container();
        },
      ),
    );
  }
}
