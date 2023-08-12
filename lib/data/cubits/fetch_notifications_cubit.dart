import 'package:edemand_partner/data/repository/notifications_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/notification_model.dart';

abstract class NotificationsState {}

class NotificationsInitial extends NotificationsState {}

class NotificationsInProgress extends NotificationsState {}

class NotificationFetchSuccess extends NotificationsState {
  final List<NotificationModel> notifications;

  NotificationFetchSuccess({required this.notifications});
}

class NotificationFetchFailure extends NotificationsState {}

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository notificationsRepository = NotificationsRepository();

  NotificationsCubit() : super(NotificationsInitial());

  //
  void fetchNotifications() async {
    try {
      emit(NotificationsInProgress());
      var notifications = await notificationsRepository.getNotifications(isAuthTokenRequired: true);
      emit(NotificationFetchSuccess(notifications: notifications));
    } catch (error) {
      emit(NotificationFetchFailure());
    }
  }

  void removeNotificationFromList(dynamic id) {
    if (state is NotificationFetchSuccess) {
      List notificationList = (state as NotificationFetchSuccess).notifications;
      notificationList.removeWhere(((element) => element.id == id));
      List<NotificationModel> list = List.from(notificationList);
      emit(NotificationFetchSuccess(notifications: list));
    }
  }
}
