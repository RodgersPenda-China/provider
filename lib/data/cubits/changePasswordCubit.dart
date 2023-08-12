import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordInProgress extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {
  final String errorMessage;
  final bool error;

  ChangePasswordSuccess({required this.errorMessage, required this.error});
}

class ChangePasswordFailure extends ChangePasswordState {
  final String errorMessage;
  final bool error;

  ChangePasswordFailure({required this.errorMessage, required this.error});
}

class ChangePasswordCubit extends Cubit<ChangePasswordState> {
  ChangePasswordCubit() : super(ChangePasswordInitial());

  final AuthRepository _authRepository = AuthRepository();

  Future<void> changePassword({required String oldPassword, required String newPassword}) async {
    try {
      emit(ChangePasswordInProgress());
      //
      Map<String, dynamic> response =
          await _authRepository.changePassword(newPassword: newPassword, oldPassword: oldPassword);
      if (!response['error']) {
        //
        emit(ChangePasswordSuccess(error: response['error'], errorMessage: response['message']));
        //
      } else {
        //
        emit(ChangePasswordFailure(error: response['error'], errorMessage: response['message']));
        //
      }
    } catch (e) {
      emit(ChangePasswordFailure(error: true, errorMessage: e.toString()));
    }
  }
}
