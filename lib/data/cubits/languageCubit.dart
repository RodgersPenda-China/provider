import 'package:edemand_partner/utils/hive_keys.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

class LanguageState {}

class LanguageInitial extends LanguageState {}

class LanguageLoader extends LanguageState {
  final dynamic languageCode;

  LanguageLoader(this.languageCode);
}

class LanguageLoadFail extends LanguageState {}

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(LanguageInitial());

  void loadCurrentLanguage() {
    var language =
        Hive.box(HiveKeys.languageBox).get(HiveKeys.currentLanguageKey);
    if (language != null) {
      emit(LanguageLoader(language));
    } else {
      emit(LanguageLoadFail());
    }
  }

  void changeLanguage(String code) async {
    await Hive.box(HiveKeys.languageBox).put(HiveKeys.currentLanguageKey, code);
    emit(LanguageLoader(code));
  }

  dynamic currentLanguageCode() {
    return Hive.box(HiveKeys.languageBox).get(HiveKeys.currentLanguageKey);
  }
}
