// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edemand_partner/data/model/systemSettingModel.dart';
import 'package:edemand_partner/data/repository/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FetchSystemSettingsState {}

class FetchSystemSettingsInitial extends FetchSystemSettingsState {}

class FetchSystemSettingsInProgress extends FetchSystemSettingsState {}

class FetchSystemSettingsSuccess extends FetchSystemSettingsState {
  final String termsAndConditions;
  final String privacyPolicy;
  final String aboutUs;
  final String contactUs;
  final String availableAmount;
  final GeneralSettings generalSettings;

  FetchSystemSettingsSuccess(
      {required this.termsAndConditions, required this.privacyPolicy, required this.aboutUs, required this.contactUs, required this.availableAmount, required this.generalSettings});

  FetchSystemSettingsSuccess copyWith({String? termsAndConditions, String? privacyPolicy, String? aboutUs, String? contactUs, String? availableAmount, GeneralSettings? generalSettings}) {
    return FetchSystemSettingsSuccess(
      generalSettings: generalSettings ?? this.generalSettings,
      termsAndConditions: termsAndConditions ?? this.termsAndConditions,
      privacyPolicy: privacyPolicy ?? this.privacyPolicy,
      aboutUs: aboutUs ?? this.aboutUs,
      contactUs: contactUs ?? this.contactUs,
      availableAmount: availableAmount ?? this.availableAmount,
    );
  }
}

class FetchSystemSettingsFailure extends FetchSystemSettingsState {
  final String errorMessage;

  FetchSystemSettingsFailure(this.errorMessage);
}

class FetchSystemSettingsCubit extends Cubit<FetchSystemSettingsState> {
  FetchSystemSettingsCubit() : super(FetchSystemSettingsInitial());
  final SettingsRepository _settingsRepository = SettingsRepository();

  getSettings({required bool isAnonymous}) async {
    try {
      emit(FetchSystemSettingsInProgress());
      var result = await _settingsRepository.getSystemSettings(isAnonymous: isAnonymous);

      //

      emit(
        FetchSystemSettingsSuccess(
          generalSettings: GeneralSettings.fromJson(result['general_settings']),
          privacyPolicy: result['privacy_policy']['privacy_policy'],
          aboutUs: result['about_us']['about_us'],
          availableAmount: result['balance'] ?? "",
          termsAndConditions: result['terms_conditions']['terms_conditions'],
          contactUs: result['contact_us']['contact_us'],
        ),
      );
    } catch (e) {
      emit(FetchSystemSettingsFailure(e.toString()));
    }
  }

  void updateAmount(String amount) {
    if (state is FetchSystemSettingsSuccess) {
      emit((state as FetchSystemSettingsSuccess).copyWith(availableAmount: amount));
    }
  }
}
