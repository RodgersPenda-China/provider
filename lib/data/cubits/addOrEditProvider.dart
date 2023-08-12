import 'package:dio/dio.dart';
import 'package:edemand_partner/data/model/user_details_model.dart';
import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditProviderDetailsState {}

class EditProviderDetailsInitial extends EditProviderDetailsState {}

class EditProviderDetailsInProgress extends EditProviderDetailsState {}

class EditProviderDetailsSuccess extends EditProviderDetailsState {
  final bool isError;
  final String message;
  final ProviderDetails providerDetails;

  EditProviderDetailsSuccess(
      {required this.isError, required this.message, required this.providerDetails});
}

class EditProviderDetailsFailure extends EditProviderDetailsState {
  final String errorMessage;

  EditProviderDetailsFailure({required this.errorMessage});
}

class EditProviderDetailsCubit extends Cubit<EditProviderDetailsState> {
  final AuthRepository _authRepository = AuthRepository();

  EditProviderDetailsCubit() : super(EditProviderDetailsInitial());

  //
  //This method is used to edit provide
  void editProviderDetails({required ProviderDetails providerDetails}) async {
    try {
      emit(EditProviderDetailsInProgress());
      //
      Map<String, dynamic> parameters = providerDetails.toJson();

      //logo
      if (parameters['image'] != "" && parameters['image'] != null) {
        parameters['image'] = await MultipartFile.fromFile(parameters['image']);
      } else {
        parameters.remove('image');
      }
      //banner image
      if (parameters['banner_image'] != "" && parameters['banner_image'] != null) {
        parameters['banner_image'] = await MultipartFile.fromFile(parameters['banner_image']);
      } else {
        parameters.remove('banner_image');
      }
      //national id proof
      if (parameters['national_id'] != "" && parameters['national_id'] != null) {
        parameters['national_id'] = await MultipartFile.fromFile(parameters['national_id']);
      } else {
        parameters.remove('national_id');
      }
      //address id proof
      if (parameters['address_id'] != "" && parameters['address_id'] != null) {
        parameters['address_id'] = await MultipartFile.fromFile(parameters['address_id']);
      } else {
        parameters.remove('address_id');
      }
      //passport id proof
      if (parameters['passport'] != "" && parameters['passport'] != null) {
        parameters['passport'] = await MultipartFile.fromFile(parameters['passport']);
      } else {
        parameters.remove('passport');
      }
      Map<String, dynamic> responseData = await _authRepository.registerProvider(
          parameters: parameters, isAuthTokenRequired: false);
      //

      if (!responseData['error']) {
        emit(EditProviderDetailsSuccess(
            providerDetails: responseData['providerDetails'],
            isError: responseData['error'],
            message: responseData['message']));
        return;
      }
      //
      emit(EditProviderDetailsFailure(errorMessage: responseData['message']));
    } catch (e, st) {
      emit(EditProviderDetailsFailure(errorMessage: st.toString()));
    }
  }
}
