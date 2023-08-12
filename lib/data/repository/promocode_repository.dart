import 'package:dio/dio.dart';
import 'package:edemand_partner/data/model/create_promocode_model.dart';
import 'package:edemand_partner/data/model/data_output.dart';
import 'package:edemand_partner/data/model/promocode_model.dart';
import 'package:edemand_partner/utils/api.dart';
import 'package:edemand_partner/utils/constant.dart';

class PromocodeRepository {
  Future<DataOutput<PromocodeModel>> fetchPromocodes({
    required int offset,
  }) async {
    Map<String, dynamic> response = await Api.post(
        url: Api.getPromocodes,
        parameter: {Api.limit: Constant.limit, Api.offset: offset},
        useAuthToken: true);
    List<PromocodeModel> promocodeList =
        (response['data'] as List).map((value) {
      return PromocodeModel.fromJson(value);
    }).toList();

    return DataOutput<PromocodeModel>(
        total: int.parse(response['total'] ?? "0" ?? "0"),
        modelList: promocodeList);
  }

  Future createPromocode(
    CreatePromocodeModel model,
  ) async {
    Map<String, dynamic> parameters = model.toJson();
    if (parameters['image'] != null) {
      parameters['image'] =
          await MultipartFile.fromFile(parameters['image'].path);
    }
    Map<String, dynamic> response = await Api.post(
      url: Api.managePromocode,
      parameter: parameters,
      useAuthToken: true,
    );
    return response['data'];
  }

  Future<void> deletePromocode(int id) async {
    await Api.post(
      url: Api.deletePromocode,
      parameter: {"promo_id": id},
      useAuthToken: true,
    );
  }
}
