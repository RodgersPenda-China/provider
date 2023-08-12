import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//Cubit
class VerifyPhoneNumberFromAPICubit extends Cubit<VerifyPhoneNumberFromAPIState> {
  AuthRepository authenticationRepository;

  VerifyPhoneNumberFromAPICubit({required this.authenticationRepository})
      : super(VerifyPhoneNumberFromAPIInitial());

  void verifyPhoneNumberFromAPI({required String mobileNumber}) async {
    emit(VerifyPhoneNumberFromAPIInProgress());

    try {
      var value =
          await authenticationRepository.verifyUserMobileNumberFromAPI(mobileNumber: mobileNumber);
      //if error is true means number already exists,
      emit(VerifyPhoneNumberFromAPISuccess(
          error: value['error'], message: value['message'], status: value['status']));
    } catch (e) {
      emit(VerifyPhoneNumberFromAPIFailure(errorMessage: e.toString()));
    }
  }
}

//State

abstract class VerifyPhoneNumberFromAPIState {}

class VerifyPhoneNumberFromAPIInitial extends VerifyPhoneNumberFromAPIState {}

class VerifyPhoneNumberFromAPIInProgress extends VerifyPhoneNumberFromAPIState {
  VerifyPhoneNumberFromAPIInProgress();
}

class VerifyPhoneNumberFromAPISuccess extends VerifyPhoneNumberFromAPIState {
  //if error is true then mobile number is already registered

  final bool error;
  final String status;
  final String message;
  VerifyPhoneNumberFromAPISuccess(
      {required this.error, required this.message, required this.status});
}

class VerifyPhoneNumberFromAPIFailure extends VerifyPhoneNumberFromAPIState {
  final String errorMessage;

  VerifyPhoneNumberFromAPIFailure({required this.errorMessage});
}
