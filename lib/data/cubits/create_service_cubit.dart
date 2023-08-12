// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edemand_partner/data/model/create_service_model.dart';
import 'package:edemand_partner/data/model/service_model.dart';
import 'package:edemand_partner/data/repository/service_repository.dart';

abstract class CreateServiceCubitState {}

class CreateServiceInitial extends CreateServiceCubitState {}

class CreateServiceInProgress extends CreateServiceCubitState {}

class CreateServiceSuccess extends CreateServiceCubitState {
  final ServiceModel service;
  CreateServiceSuccess({
    required this.service,
  });
}

class CreateServiceFailure extends CreateServiceCubitState {
  final String errorMessage;

  CreateServiceFailure(this.errorMessage);
}

class CreateServiceCubit extends Cubit<CreateServiceCubitState> {
  final ServiceRepository _serviceRepository = ServiceRepository();
  CreateServiceCubit() : super(CreateServiceInitial());

  Future<void> createService(CreateServiceModel dataModel) async {
    try {
      emit(CreateServiceInProgress());
      ServiceModel serviceModel =
          await _serviceRepository.createService(dataModel);
      emit(CreateServiceSuccess(service: serviceModel));
    } catch (e,s) {
      print("error is ${e.toString()} ${s.toString()}");
      emit(CreateServiceFailure(e.toString()));
    }
  }
}
