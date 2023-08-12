import 'dart:io';

import 'package:dio/dio.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/errorFilter.dart';
import 'package:edemand_partner/utils/hive_keys.dart';
import 'package:hive/hive.dart';

class ApiException implements Exception {
  ApiException(this.errorMessage);

  dynamic errorMessage;

  @override
  String toString() {
    return ErrorFilter.check(errorMessage).error;
  }
}

class Api {
  //headers
  static Map<String, dynamic> headers() {
    String jwtToken = Hive.box(HiveKeys.userDetailsBox).get(HiveKeys.jwtToken);

    return {
      "Authorization": "Bearer $jwtToken",
    };
  }

//Api list
  static String loginApi = "${Constant.baseUrl}login";
  static String getBookings = "${Constant.baseUrl}get_orders";
  static String getServices = "${Constant.baseUrl}get_services";
  static String getServiceCategories = "${Constant.baseUrl}get_categories";
  static String getCategories = "${Constant.baseUrl}get_categories";
  static String getPromocodes = "${Constant.baseUrl}get_promocodes";
  static String managePromocode = "${Constant.baseUrl}manage_promocode";
  static String updateBookingStatus = "${Constant.baseUrl}update_order_status";
  static const String manageService = "${Constant.baseUrl}manage_service";
  static const String deleteService = "${Constant.baseUrl}delete_service";
  static String getServiceRatings = "${Constant.baseUrl}get_service_ratings";
  static String deletePromocode = "${Constant.baseUrl}delete_promocode";
  static String getAvailableSlots = "${Constant.baseUrl}get_available_slots";
  static String getStatistics = "${Constant.baseUrl}get_statistics";
  static String getSettings = "${Constant.baseUrl}get_settings";
  static String getWithdrawalRequest = "${Constant.baseUrl}get_withdrawal_request";
  static String sendWithdrawalRequest = "${Constant.baseUrl}send_withdrawal_request";
  static String getNotifications = "${Constant.baseUrl}get_notifications";
  static String updateFcm = "${Constant.baseUrl}update_fcm";
  static String deleteUserAccount = "${Constant.baseUrl}delete_provider_account";
  static String verifyUser = "${Constant.baseUrl}verify_user";
  static String registerProvider = "${Constant.baseUrl}register";
  static String changePassword = "${Constant.baseUrl}change-password";
  static String getTaxes = "${Constant.baseUrl}get_taxes";

//parameters
  static const String mobile = "mobile";
  static const String password = "password";
  static const String countryCode = "country_code";
  static const String oldPassword = "old";
  static const String newPassword = "new";
  static const String limit = "limit";
  static const String offset = "offset";
  static const String search = "search";
  static const String status = "status";
  static const String serviceId = "service_id";
  static const String date = "date";
  static const String promoId = "promo_id";

  //
  //register provider
  static const String companyName = 'companyName';
  static const String email = 'email';
  static const String username = 'username';
  static const String companyType = "type";
  static const String aboutProvider = "about_provider";
  static const String visitingCharge = "visiting_charges";
  static const String advanceBookingDays = "advance_booking_days";
  static const String noOfMember = "number_of_members";
  static const String currentLocation = "current_location";
  static const String city = "city";
  static const String latitude = "latitude";
  static const String longitude = "longitude";
  static const String address = "address";
  static const String taxName = "tax_name";
  static const String taxNumber = "tax_number";
  static const String accountNumber = "account_number";
  static const String accountName = "account_name";
  static const String bankCode = "bank_code";
  static const String swiftCode = "swift_code";
  static const String bankName = "bank_name";
  static const String confirmPassword = "password_confirm";
  static const String days = "days";

  ///post method for API calling
  static Future<Map<String, dynamic>> post({
    required String url,
    required Map<String, dynamic> parameter,
    required bool useAuthToken,
  }) async {
    try {
      print(url);
      final Dio dio = Dio();
      final FormData formData = FormData.fromMap(parameter, ListFormat.multiCompatible);

      final response = await dio.post(url,
          data: formData,
          options: useAuthToken
              ? Options(
                  contentType: "multipart/form-data",
                  headers: headers(),
                )
              : Options(
                  contentType: "multipart/form-data",
                ));

      return Map.from(response.data);
    } on FormatException catch (e, stackTrace) {
      throw ApiException(e.message);
    } on DioError catch (e, stackTrace) {
      if (e.response?.statusCode == 401) {
        throw ApiException("authenticationFailed");
      } else if (e.response?.statusCode == 500) {
        throw ApiException("internalServerError");
      }
      throw ApiException(e.error is SocketException ? "noInternetFound" : "somethingWentWrong");
    } on ApiException catch (e, stackTrace) {
      throw ApiException("somethingWentWrong");
    } catch (e, stackTrace) {
      throw ApiException("somethingWentWrong");
    }
  }

  static Future<Map<String, dynamic>> get({
    required String url,
    required bool useAuthToken,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      //
      print(url);
      final Dio dio = Dio();

      final response = await dio.get(url,
          queryParameters: queryParameters,
          options: useAuthToken ? Options(headers: headers()) : null);

      if (response.data['error'] == true) {
        throw ApiException(response.data['code'].toString());
      }

      return Map.from(response.data);
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        throw ApiException("authenticationFailed");
      } else if (e.response?.statusCode == 500) {
        throw ApiException("internalServerError");
      }
      throw ApiException(e.error is SocketException ? "noInternetFound" : "somethingWentWrong");
    } on ApiException {
      throw ApiException("somethingWentWrong");
    } catch (e) {
      throw ApiException("somethingWentWrong");
    }
  }
}
