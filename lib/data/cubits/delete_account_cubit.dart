import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:edemand_partner/utils/hive_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountInProgress extends DeleteAccountState {}

class DeleteAccountSuccess extends DeleteAccountState {}

class DeleteAccountFailure extends DeleteAccountState {
  final String errorMessage;

  DeleteAccountFailure(this.errorMessage);
}

class DeleteAccountCubit extends Cubit<DeleteAccountState> {
  DeleteAccountCubit() : super(DeleteAccountInitial());

  final AuthRepository _authRepository = AuthRepository();
  Future deleteAccount() async {
    try {
      emit(DeleteAccountInProgress());
      await _authRepository.deleteUserAccount();
      await HiveUtils.clear();
      emit(DeleteAccountSuccess());
    } catch (e, st) {
      emit(DeleteAccountFailure(e.toString()));
    }
  }
}
