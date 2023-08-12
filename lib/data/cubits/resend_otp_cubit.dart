import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ResendOtpState {}

class ResendOtpInitial extends ResendOtpState {}

class ResendOtpInProcess extends ResendOtpState {}

class ResendOtpSuccess extends ResendOtpState {}

class ResendOtpFail extends ResendOtpState {
  final dynamic error;

  ResendOtpFail(this.error);
}

class ResendOtpCubit extends Cubit<ResendOtpState> {
  final AuthRepository authRepo = AuthRepository();

  ResendOtpCubit() : super(ResendOtpInitial());

  resendOtp(String phoneNumber, {VoidCallback? onOtpSent}) async {
    try {
      emit(ResendOtpInProcess());
      await authRepo.verifyPhoneNumber(
        phoneNumber,
        onError: (err) {
          emit(ResendOtpFail(err));
        },
        onCodeSent: () {
          onOtpSent?.call();
          emit(ResendOtpSuccess());
        },
      );
      // await Future.delayed(const Duration(milliseconds: 400));
    } on FirebaseAuthException catch (error) {
      emit(ResendOtpFail(error));
    }
  }

  setDefaultOtpState() {
    emit(ResendOtpInitial());
  }
}
