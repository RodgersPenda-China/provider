import 'package:edemand_partner/app/routes.dart';
import 'package:edemand_partner/data/cubits/auth_cubit.dart';
import 'package:edemand_partner/data/model/user_details_model.dart';
import 'package:edemand_partner/utils/api.dart';
import 'package:edemand_partner/utils/constant.dart';
import 'package:edemand_partner/utils/hive_keys.dart';
import 'package:edemand_partner/utils/hive_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthRepository {
  static String? kPhoneNumber;
  static String? verificationId;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isLoggedIn {
    return _auth.currentUser != null;
  }

  verifyPhoneNumber(String phoneNumber,
      {Function(dynamic err)? onError, VoidCallback? onCodeSent}) async {
    kPhoneNumber = phoneNumber;
    await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: Constant.resendOTPCountDownTime),
        verificationCompleted: (PhoneAuthCredential complete) {},
        verificationFailed: (FirebaseAuthException err) {
          onError?.call(err);
        },
        codeSent: (String verification, int? forceResendingToken) {
          verificationId = verification;
          // this is force resending token
          Hive.box(HiveKeys.authBox).put("resendToken", forceResendingToken);
          if (onCodeSent != null) {
            onCodeSent();
          }
        },
        forceResendingToken: Hive.box(HiveKeys.authBox).get("resendToken"),
        codeAutoRetrievalTimeout: (String timeout) {});

    //  confirmation = confirmationResult;
  }

  verifyOtp(
      {required String code,
      required Function(UserCredential credential) onVerificationSuccess}) async {
    if (verificationId != null) {
      PhoneAuthCredential credential =
          PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: code);

      await _auth.signInWithCredential(credential).then((credential) {
        onVerificationSuccess(credential);
      });
    }
  }

  verifyUserMobileNumberFromAPI({required String mobileNumber}) async {
    try {
      Map<String, dynamic> parameter = {Api.mobile: mobileNumber};

      final response =
          await Api.post(parameter: parameter, url: Api.verifyUser, useAuthToken: false);

      return {
        "error": response['error'],
        "message": response['message'] ?? "",
        "status": response['status'] ?? ""
      };
    } catch (e) {
      throw ApiException(e.toString());
    }
  }

  Future<Map<String, dynamic>> loginUser(
      {required String phoneNumber, required String password, required String countryCode}) async {
    Map<String, dynamic> parameters = {
      Api.mobile: phoneNumber,
      Api.password: password,
      Api.countryCode: countryCode
    };
    Map<String, dynamic> response = await Api.post(
      url: Api.loginApi,
      parameter: parameters,
      useAuthToken: false,
    );

//store locally for later use
    if (response['token'] != null) {
      HiveUtils.setJWT(response['token']);
      HiveUtils.setUserData(response['data']);
    }

    if (response['data'] == null) {
      return {"userDetails": null, "error": true, "message": response['message'] ?? ""};
    }

    return {
      "userDetails": ProviderDetails.fromJson(response['data'] ?? {}),
      "error": response['error'] ?? false,
      "message": response['message'] ?? ""
    };
  }

  Future logout(BuildContext context) async {
    await HiveUtils.logoutUser(onLogout: () {
      //This is for remove all other routes from history.
      Navigator.of(context).popUntil((route) => route.isFirst);
      Navigator.pushReplacementNamed(context, Routes.loginScreenRoute);
    });
    Future.delayed(
      Duration.zero,
      () {
        context.read<AuthenticationCubit>().setUnAuthenticated();
      },
    );
  }

  //Delete user account
  Future deleteUserAccount() async {
    await Api.post(url: Api.deleteUserAccount, parameter: {}, useAuthToken: true);
  }

  //register Provider
  Future<Map<String, dynamic>> registerProvider(
      {required Map<String, dynamic> parameters, required bool isAuthTokenRequired}) async {
    try {
      //

      //
      Map<String, dynamic> response = await Api.post(
        url: Api.registerProvider,
        parameter: parameters,
        useAuthToken: isAuthTokenRequired,
      );

      return {
        "providerDetails": ProviderDetails.fromJson(Map.from(response['data'])),
        "message": response['message'],
        "error": response['error'],
      };
    } catch (e, st) {
      return {"message": e.toString(), "error": true, "providerDetails": ProviderDetails()};
    }
  }

  //change Password
  Future<Map<String, dynamic>> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      Map<String, dynamic> parameters = {
        Api.oldPassword: oldPassword,
        Api.newPassword: newPassword,
      };
      Map<String, dynamic> response = await Api.post(
        url: Api.changePassword,
        parameter: parameters,
        useAuthToken: true,
      );
      return {
        "message": response['message'],
        "error": response['error'],
      };
    } catch (e) {
      return {
        "message": e.toString(),
        "error": true,
      };
    }
  }
}
