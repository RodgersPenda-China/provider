import 'package:dio/dio.dart';
import 'package:edemand_partner/data/model/create_service_model.dart';
import 'package:edemand_partner/data/model/service_category_model.dart';
import 'package:edemand_partner/data/model/service_filter_model.dart';
import 'package:edemand_partner/data/model/service_model.dart';
import 'package:edemand_partner/data/model/taxModel.dart';
import 'package:edemand_partner/utils/api.dart';

import '../../utils/constant.dart';
import '../model/data_output.dart';
import '../model/ratings_model.dart';
import '../model/reviews_model.dart';

class ServiceRepository {
  //
  Future<DataOutput<ServiceModel>> fetchService(
      {required int offset, String? searchQuery, ServiceFilterDataModel? filter}) async {
    //pass filter data in parms

    Map<String, dynamic> parameters = {Api.offset: offset};

    if (searchQuery != null) {
      parameters[Api.search] = searchQuery;
      parameters.remove(Api.offset);
    }

    if (filter != null) {
      parameters.addAll(filter.toMap());
    }
    /*  if (parameters["max_budget"] == "1.0" && parameters["min_budget"] == "0.0") {
      parameters.remove("min_budget");
      parameters.remove("max_budget");
    }*/
    Map<String, dynamic> response = await Api.post(
      url: Api.getServices,
      parameter: parameters,
      useAuthToken: true,
    );

    List<ServiceModel> modelList = (response['data'] as List).map((element) {
      return ServiceModel.fromJson(element);
    }).toList();
    return DataOutput<ServiceModel>(
        extraData: ExtraData(data: {
          "max_price": response['max_price'],
          "min_price": response['min_price'],
          'min_discount_price': response["min_discount_price"],
          'max_discount_price': response["max_discount_price"],
        }),
        total: int.parse(
          response['total'] ?? "0",
        ),
        modelList: modelList);
  }

//
  Future<DataOutput<ServiceCategoryModel>> fetchCategories({required int offset}) async {
    Map<String, dynamic> parameters = {Api.limit: Constant.limit * 3, Api.offset: offset};
    Map<String, dynamic> response =
        await Api.post(url: Api.getServiceCategories, parameter: parameters, useAuthToken: true);

    List<ServiceCategoryModel> modelList = (response['data'] as List).map((element) {
      return ServiceCategoryModel.fromJson(element);
    }).toList();

    return DataOutput<ServiceCategoryModel>(
        total: int.parse(response['total'] ?? "0"), modelList: modelList);
  }

  //
  Future<Map<String, dynamic>> fetchTaxes() async {
    Map<String, dynamic> response =
        await Api.post(url: Api.getTaxes, parameter: {}, useAuthToken: true);

    List<Taxes> taxesList = (response['data'] as List).map((element) {
      return Taxes.fromJson(element);
    }).toList();

    return {"taxesDataList": taxesList, "error": response['error'], "message": response['message']};
  }

//
  Future<ServiceModel> createService(CreateServiceModel dataModel) async {
    Map<String, dynamic> parameters = dataModel.toJson();
    if (parameters['image'] != null) {
      parameters['image'] = await MultipartFile.fromFile(parameters['image'].path);
    }

    Map<String, dynamic> response =
        await Api.post(url: Api.manageService, parameter: parameters, useAuthToken: true);
    print("aPI is ${Api.manageService}\n response is ${response}");
    return ServiceModel.fromJson(response['data'][0]);
  }

  Future<void> deleteService({required int id}) async {
    await Api.post(url: Api.deleteService, parameter: {Api.serviceId: id}, useAuthToken: true);
  }

  fetchReviews(int serviceId, {required int offset}) async {
    Map<String, dynamic> response = await Api.post(
        url: Api.getServiceRatings,
        parameter: {Api.serviceId: serviceId, Api.offset: offset, Api.limit: Constant.limit},
        useAuthToken: true);

    List<ReviewsModel> modelList =
        (response['data'] as List).map((element) => ReviewsModel.fromJson(element)).toList();

    return DataOutput<ReviewsModel>(
      total: int.parse(
        response['total'] ?? "0",
      ),
      modelList: modelList,
      extraData: ExtraData<RatingsModel>(
        data: RatingsModel.fromJson(response['ratings'][0]),
      ),
    );
  }
}
