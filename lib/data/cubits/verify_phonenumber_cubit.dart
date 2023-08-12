import 'dart:ui';

import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class VerifyPhoneNumberState {}

class VerifyPhoneNumberInitial extends VerifyPhoneNumberState {}

class PhoneNumberVerificationInProgress extends VerifyPhoneNumberState {}

class SendVerificationCodeInProgress extends VerifyPhoneNumberState {}

class PhoneNumberVerificationSuccess extends VerifyPhoneNumberState {}

class PhoneNumberVerificationFailure extends VerifyPhoneNumberState {
  final dynamic error;

  PhoneNumberVerificationFailure(this.error);
}

class VerifyPhoneNumberCubit extends Cubit<VerifyPhoneNumberState> {
  final AuthRepository authRepo = AuthRepository();

  VerifyPhoneNumberCubit() : super(VerifyPhoneNumberInitial());

  void verifyPhoneNumber(String phoneNumber, {VoidCallback? onCodeSent}) async {
    try {
      emit(PhoneNumberVerificationInProgress());
      await authRepo.verifyPhoneNumber(phoneNumber, onError: (error) {
        emit(PhoneNumberVerificationFailure(error));
      }, onCodeSent: () {
        emit(SendVerificationCodeInProgress());
      });
      // await Future.delayed(const Duration(milliseconds: 400));
    } on FirebaseAuthException catch (error) {
      emit(PhoneNumberVerificationFailure(error.message));
    }
  }

  phoneNumberVerified() {
    if (state is SendVerificationCodeInProgress) {
      emit(PhoneNumberVerificationSuccess());
    }
  }

  setInitialState() {
    if (state is SendVerificationCodeInProgress || state is PhoneNumberVerificationSuccess) {
      emit(VerifyPhoneNumberInitial());
    }
  }
}
