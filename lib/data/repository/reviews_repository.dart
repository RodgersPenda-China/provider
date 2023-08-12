import 'package:edemand_partner/data/model/ratings_model.dart';
import 'package:edemand_partner/data/model/reviews_model.dart';
import 'package:edemand_partner/utils/api.dart';
import 'package:edemand_partner/utils/constant.dart';

import '../model/data_output.dart';

class ReviewsRepository {
  Future<DataOutput<ReviewsModel>> fetchReviews({
    required int offset,
  }) async {
    Map<String, dynamic> response = await Api.post(
        url: Api.getServiceRatings,
        parameter: {Api.offset: offset, Api.limit: Constant.limit},
        useAuthToken: true);

    List<ReviewsModel> modelList = (response['data'] as List)
        .map((element) => ReviewsModel.fromJson(element))
        .toList();

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
