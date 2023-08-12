// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edemand_partner/data/model/data_output.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edemand_partner/data/model/withdrawal_model.dart';
import 'package:edemand_partner/data/repository/withdrawal_repository.dart';

import '../../utils/constant.dart';

abstract class FetchWithdrawalRequestState {}

class FetchWithdrawalRequestInitial extends FetchWithdrawalRequestState {}

class FetchWithdrawalRequestInProgress extends FetchWithdrawalRequestState {}

class FetchWithdrawalRequestSuccess extends FetchWithdrawalRequestState {
  final bool isLoadingMore;
  final bool hasError;
  final int offset;
  final int total;
  final List<WithdrawalModel> withdrawals;
  FetchWithdrawalRequestSuccess({
    required this.isLoadingMore,
    required this.hasError,
    required this.offset,
    required this.total,
    required this.withdrawals,
  });

  FetchWithdrawalRequestSuccess copyWith({
    bool? isLoadingMore,
    bool? hasError,
    int? offset,
    int? total,
    List<WithdrawalModel>? withdrawals,
  }) {
    return FetchWithdrawalRequestSuccess(
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      offset: offset ?? this.offset,
      total: total ?? this.total,
      withdrawals: withdrawals ?? this.withdrawals,
    );
  }
}

class FetchWithdrawalRequestFailure extends FetchWithdrawalRequestState {
  final String errorMessage;

  FetchWithdrawalRequestFailure(this.errorMessage);
}

class FetchWithdrawalRequestCubit extends Cubit<FetchWithdrawalRequestState> {
  FetchWithdrawalRequestCubit() : super(FetchWithdrawalRequestInitial());
  final WithdrawalRepository _withdrawalRepository = WithdrawalRepository();
  fetchWithdrawals() async {
    try {
      emit(FetchWithdrawalRequestInProgress());
      DataOutput<WithdrawalModel> result =
          await _withdrawalRepository.fetchWithdrawalRequests();
      emit(FetchWithdrawalRequestSuccess(
          hasError: false,
          isLoadingMore: false,
          offset: 0,
          total: result.total,
          withdrawals: result.modelList));
    } catch (e) {
      emit(FetchWithdrawalRequestFailure(e.toString()));
    }
  }

  Future<void> fetchMoreWithdrawals() async {
    try {
      if (state is FetchWithdrawalRequestSuccess) {
        if ((state as FetchWithdrawalRequestSuccess).isLoadingMore) {
          return;
        }
        emit((state as FetchWithdrawalRequestSuccess)
            .copyWith(isLoadingMore: true));

        DataOutput<WithdrawalModel> result =
            await _withdrawalRepository.fetchWithdrawalRequests();

        FetchWithdrawalRequestSuccess withdrawalState =
            (state as FetchWithdrawalRequestSuccess);
        withdrawalState.withdrawals.addAll(result.modelList);
        emit(
          FetchWithdrawalRequestSuccess(
            isLoadingMore: false,
            hasError: false,
            withdrawals: withdrawalState.withdrawals,
            offset: (state as FetchWithdrawalRequestSuccess).offset +
                Constant.limit,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit(
        (state as FetchWithdrawalRequestSuccess).copyWith(
          isLoadingMore: false,
          hasError: true,
        ),
      );
    }
  }

  bool hasMoreData() {
    if (state is FetchWithdrawalRequestSuccess) {
      return (state as FetchWithdrawalRequestSuccess).offset <
          (state as FetchWithdrawalRequestSuccess).total;
    }
    return false;
  }
}
