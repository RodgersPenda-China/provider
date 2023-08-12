import '../../utils/api.dart';
import '../model/notification_model.dart';

class NotificationsRepository {
  Future<List<NotificationModel>> getNotifications(
      {required bool isAuthTokenRequired}) async {
    try {
      Map<String, dynamic> parameters = {Api.limit: "100", Api.offset: "0"};

      final Map<String, dynamic> response = await Api.post(
          url: Api.getNotifications, parameter: parameters, useAuthToken: true);
      List<dynamic> data = response["data"];

      return data.map((value) => NotificationModel.fromMap(value)).toList();
    } catch (error) {
      throw ApiException(error.toString());
    }
  }

  // Future<Map<String, dynamic>> deleteNotification(
  //     {required String id, required bool isAuthTokenRequired}) async {
  //   try {
  //     Map<String, dynamic> parameters = {
  //       Api.notificationId: id,
  //       Api.deleteNotification: 1,
  //     };
  //     Map<String, dynamic> response = await Api.post(
  //         url: Api.manageNotification,
  //         parameter: parameters,
  //         useAuthToken: isAuthTokenRequired);

  //     return {'error': response['error'], 'message': response['message']};
  //   } catch (error) {
  //     throw ApiException(error.toString());
  //   }
  // }

  // Future<Map<String, dynamic>> markNotificationAsRead(
  //     {required String id, required bool isAuthTokenRequired}) async {
  //   try {
  //     Map<String, dynamic> parameters = {
  //       Api.notificationId: id,
  //       Api.isReadedNotification: 1,
  //     };
  //     Map<String, dynamic> response = await Api.post(
  //         url: Api.manageNotification,
  //         parameter: parameters,
  //         useAuthToken: isAuthTokenRequired);

  //     return {'error': response['error'], 'message': response['message']};
  //   } catch (error) {
  //     throw ApiException(error.toString());
  //   }
  // }
}
