import 'package:edemand_partner/data/model/user_details_model.dart';
import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInInProgress extends SignInState {}

class SignInSuccess extends SignInState {
  final ProviderDetails providerDetails;
  final bool error;
  final String message;

  SignInSuccess({
    required this.providerDetails,
    required this.error,
    required this.message,
  });
}

class SignInFailure extends SignInState {
  final String errorMessage;

  SignInFailure(this.errorMessage);
}

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(SignInInitial());

  final AuthRepository _authRepository = AuthRepository();

  Future<void> SignIn(
      {required String phoneNumber, required String password, required String countryCode}) async {
    try {
      emit(SignInInProgress());
      Map<String, dynamic> response = await _authRepository.loginUser(
          phoneNumber: phoneNumber, password: password, countryCode: countryCode);

      if (response['userDetails'] != null) {
        emit(SignInSuccess(
            providerDetails: response['userDetails'],
            error: response['error'],
            message: response['message']));
      } else {
        emit(SignInFailure(response['message']));
      }
    } catch (e) {
      emit(SignInFailure(e.toString()));
    }
  }

  void setInitial() {
    emit(SignInInitial());
  }
}
