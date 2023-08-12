// ignore_for_file: file_names

import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VerifyOtpState {}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpInProcess extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  UserCredential signinCredential;

  VerifyOtpSuccess(this.signinCredential);
}

class VerifyOtpFail extends VerifyOtpState {
  final dynamic error;

  VerifyOtpFail(this.error);
}

class VerifyOtpCubit extends Cubit<VerifyOtpState> {
  final AuthRepository authRepo = AuthRepository();

  VerifyOtpCubit() : super(VerifyOtpInitial());

  verifyOtp(String otp) async {
    try {
      emit(VerifyOtpInProcess());
      await authRepo.verifyOtp(
          code: otp,
          onVerificationSuccess: (UserCredential signinCredential) {
            emit(VerifyOtpSuccess(signinCredential));
          });
    } on FirebaseAuthException catch (error) {
      emit(VerifyOtpFail(error));
    }
  }

  setInitialState() {
    if (state is VerifyOtpFail) {
      emit(VerifyOtpInitial());
    }
    if (state is VerifyOtpSuccess) {
      emit(VerifyOtpInitial());
    }
  }
}
