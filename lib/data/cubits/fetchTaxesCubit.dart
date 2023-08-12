// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edemand_partner/data/model/taxModel.dart';
import 'package:edemand_partner/data/repository/service_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FetchTaxesState {}

class FetchTaxesInitial extends FetchTaxesState {}

class FetchTaxesInProgress extends FetchTaxesState {}

class FetchTaxesSuccess extends FetchTaxesState {
  final List<Taxes> taxes;
  final String message;
  final bool error;

  FetchTaxesSuccess({
    required this.taxes,
    required this.message,
    required this.error,
  });
}

class FetchTaxesFailure extends FetchTaxesState {
  final String errorMessage;

  FetchTaxesFailure(this.errorMessage);
}

class FetchTaxesCubit extends Cubit<FetchTaxesState> {
  //
  FetchTaxesCubit() : super(FetchTaxesInitial());

  //
  final ServiceRepository serviceRepository = ServiceRepository();

  //
  void fetchTaxes() async {
    try {
      emit(FetchTaxesInProgress());
      Map<String, dynamic> response = await serviceRepository.fetchTaxes();
      if (!response['error']) {
        emit(FetchTaxesSuccess(
            message: response['message'],
            error: response['error'],
            taxes: response['taxesDataList']));
        return;
      }
      emit(FetchTaxesFailure(response['message']));
    } catch (e) {
      emit(FetchTaxesFailure(e.toString()));
    }
  }

  List<Taxes> getTaxDetails() {
    if (state is FetchTaxesSuccess) {
      return (state as FetchTaxesSuccess).taxes;
    }
    return [];
  }
}
