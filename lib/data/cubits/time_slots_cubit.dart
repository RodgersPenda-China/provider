import 'package:edemand_partner/data/model/data_output.dart';
import 'package:edemand_partner/data/model/time_slot_model.dart';
import 'package:edemand_partner/data/repository/bookings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class TimeSlotState {}

class TimeSlotInitial extends TimeSlotState {}

class TimeSlotFetchInProgress extends TimeSlotState {}

class TimeSlotFetchSuccess extends TimeSlotState {
  final List<TimeSlotModel> slotsData;
  final bool isError;
  final String message;

  TimeSlotFetchSuccess({required this.isError, required this.message, required this.slotsData});
}

class TimeSlotFetchFailure extends TimeSlotState {
  final String errorMessage;

  TimeSlotFetchFailure({required this.errorMessage});
}

class TimeSlotCubit extends Cubit<TimeSlotState> {
  // CartRepository cartRepository;
  final BookingsRepository _bookingsRepository = BookingsRepository();
  TimeSlotCubit() : super(TimeSlotInitial());

  //
  //This method is used to fetch timeslot details
  void getTimeslotDetails({required DateTime selectedDate}) async {
    try {
      emit(TimeSlotFetchInProgress());

      _bookingsRepository.getAllTimeSlots(selectedDate.toString().split(" ")[0]).then(
        (DataOutput<TimeSlotModel> value) {
          emit(
            TimeSlotFetchSuccess(
              message: value.extraData!.data['message'],
              isError: value.extraData!.data['error'],
              slotsData: value.modelList,
            ),
          );
          // }).catchError((onError) {
        },
      );
    } catch (e, st) {
      emit(TimeSlotFetchFailure(errorMessage: st.toString()));
    }
  }
}
