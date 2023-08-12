import 'package:edemand_partner/utils/api.dart';

class SettingsRepository {
  //
  Future getSystemSettings({required bool isAnonymous}) async {
    try {
      //
      Map<String, dynamic> response = await Api.post(
          url: Api.getSettings, parameter: {}, useAuthToken: isAnonymous ? false : true);

      return response['data'];
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future updateFCM(String fcm) async {
    await Api.post(url: Api.updateFcm, parameter: {"fcm_id": fcm}, useAuthToken: true);
  }
}
