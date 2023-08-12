// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edemand_partner/data/repository/withdrawal_repository.dart';

abstract class SendWithdrawalRequestState {}

class SendWithdrawalRequestInitial extends SendWithdrawalRequestState {}

class SendWithdrawalRequestInProgress extends SendWithdrawalRequestState {}

class SendWithdrawalRequestSuccess extends SendWithdrawalRequestState {
  final String balance;
  SendWithdrawalRequestSuccess({
    required this.balance,
  });
}

class SendWithdrawalRequestFailure extends SendWithdrawalRequestState {
  final String errorMessage;

  SendWithdrawalRequestFailure(this.errorMessage);
}

class SendWithdrawalRequestCubit extends Cubit<SendWithdrawalRequestState> {
  SendWithdrawalRequestCubit() : super(SendWithdrawalRequestInitial());
  final WithdrawalRepository _withdrawalRepository = WithdrawalRepository();
  sendWithdrawalRequest(
      {required String amount, required String paymentAddress}) async {
    try {
      emit(SendWithdrawalRequestInProgress());
      var balance = await _withdrawalRepository.sendWithdrawalRequest(
        amount: amount,
        paymentAddress: paymentAddress,
      );
      emit(SendWithdrawalRequestSuccess(balance: balance));
    } catch (e) {
      emit(SendWithdrawalRequestFailure(e.toString()));
    }
  }
}
