import 'package:edemand_partner/data/model/categoryModel.dart';
import 'package:edemand_partner/utils/api.dart';

import '../model/data_output.dart';

class CategoriesRepository {
  Future<DataOutput<CategoryModel>> fetchCategories(
      {required int offset}) async {
    Map<String, dynamic> response = await Api.post(
        url: Api.getCategories, parameter: {}, useAuthToken: true);

    List<CategoryModel> result = (response['data'] as List).map((element) {
      return CategoryModel.fromJson(element);
    }).toList();

    return DataOutput<CategoryModel>(
        total: int.parse(response['total'] ?? "0"), modelList: result);
  }
}
