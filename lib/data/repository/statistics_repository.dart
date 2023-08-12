import 'package:edemand_partner/data/model/statistics_model.dart';
import 'package:edemand_partner/utils/api.dart';

class StatisticsRepository {
  Future<StatisticsModel> fetchStatistics() async {
    Map<String, dynamic> response = await Api.post(
        url: Api.getStatistics, parameter: {}, useAuthToken: true);

    return StatisticsModel.fromJson(response['data']);
  }
}
