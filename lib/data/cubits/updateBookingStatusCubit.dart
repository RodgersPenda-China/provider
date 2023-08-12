// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edemand_partner/data/repository/bookings_repository.dart';

abstract class UpdateBookingStatusState {}

class UpdateBookingStatusInitial extends UpdateBookingStatusState {}

class UpdateBookingStatusInProgress extends UpdateBookingStatusState {}

class UpdateBookingStatusSuccess extends UpdateBookingStatusState {
  final int orderId;
  final String status;
  UpdateBookingStatusSuccess({
    required this.orderId,
    required this.status,
  });
}

class UpdateBookingStatusFailure extends UpdateBookingStatusState {
  final String errorMessage;

  UpdateBookingStatusFailure(this.errorMessage);
}

class UpdateBookingStatusCubit extends Cubit<UpdateBookingStatusState> {
  final BookingsRepository _bookingsRepository = BookingsRepository();

  UpdateBookingStatusCubit() : super(UpdateBookingStatusInitial());

  updateBookingStatus({
    required int orderId,
    required int customerId,
    required String status,
    String? time,
    String? date,
  }) async {
    try {
      emit(UpdateBookingStatusInProgress());
      await _bookingsRepository.updateBookingStatus(
        customerId: customerId,
        orderId: orderId,
        status: status,
        date: date,
        time: time,
      );
      emit(UpdateBookingStatusSuccess(orderId: orderId, status: status));
    } catch (e) {
      emit(UpdateBookingStatusFailure(e.toString()));
    }
  }
}
