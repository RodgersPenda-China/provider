import 'package:bloc/bloc.dart';
import 'package:edemand_partner/utils/hive_utils.dart';

import '../../app/appTheme.dart';

class AppThemeCubit extends Cubit<ThemeState> {
  AppThemeCubit() : super(ThemeState(HiveUtils.getCurrentTheme()));

  void changeTheme(AppTheme appTheme) {
    HiveUtils.setCurrentTheme(appTheme);
    emit(ThemeState(appTheme));
  }

  //dev!
  void toggleTheme() {
    if (state.appTheme == AppTheme.dark) {
      HiveUtils.setCurrentTheme(AppTheme.light);

      emit(ThemeState(AppTheme.light));
    } else {
      HiveUtils.setCurrentTheme(AppTheme.dark);

      emit(ThemeState(AppTheme.dark));
    }
  }

  bool isDarkMode() {
    return state.appTheme == AppTheme.dark;
  }
}

class ThemeState {
  final AppTheme appTheme;

  ThemeState(this.appTheme);
}
