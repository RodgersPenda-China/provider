import 'package:edemand_partner/data/model/booking_model.dart';
import 'package:edemand_partner/data/model/data_output.dart';
import 'package:edemand_partner/data/model/time_slot_model.dart';
import 'package:edemand_partner/utils/api.dart';
import 'package:edemand_partner/utils/constant.dart';

class BookingsRepository {
  Future<DataOutput<BookingsModel>> fetchBooking({
    required int offset,
    required String? status,
  }) async {
    // Map<String, dynamic> parameters = {Api.page: pageNumber};

    Map<String, dynamic> response = await Api.post(url: Api.getBookings, parameter: {Api.limit: Constant.limit, Api.offset: offset, Api.status: status, "order": "DESC"}, useAuthToken: true);
    List<BookingsModel> modelList;
    if (response['data'].isEmpty) {
      modelList = [];
    } else {
      //creating model list from json
      modelList = (response['data']['data'] as List).map((element) {
        return BookingsModel.fromJson(element);
      }).toList();
    }

//adding model list and total count to data output class
    return DataOutput<BookingsModel>(
      total: int.parse(response['total'] ?? "0"),
      modelList: modelList,
    );
  }

  updateBookingStatus({required int orderId, required int customerId, required String status, String? date, String? time}) async {
    Map<String, dynamic> parameters = {"order_id": orderId, "customer_id": customerId, "status": status};
    if (date != null && time != null) {
      parameters['date'] = date;
      parameters['time'] = time;
    }

    await Api.post(url: Api.updateBookingStatus, parameter: parameters, useAuthToken: true);
  }

  Future<DataOutput<TimeSlotModel>> getAllTimeSlots(String date) async {
    try {
      Map<String, dynamic> response = await Api.post(
        url: Api.getAvailableSlots,
        parameter: {Api.date: date},
        useAuthToken: true,
      );

      List<TimeSlotModel> timeSlotList = (response['data']['all_slots'] as List).map((element) {
        return TimeSlotModel.fromMap(element);
      }).toList();
      // TimeSlotModel timeSlotModel = TimeSlotModel.fromJson(response['data']);

      return DataOutput<TimeSlotModel>(
          total: 0,
          modelList: timeSlotList,
          extraData: ExtraData(data: {
            "error": response['error'],
            "message": response['message'],
          }));
    } catch (e) {
      rethrow;
    }
  }
}
