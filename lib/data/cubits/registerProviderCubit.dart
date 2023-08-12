import 'package:edemand_partner/data/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class RegisterProviderState {}

class RegisterProviderInitial extends RegisterProviderState {}

class RegisterProviderInProgress extends RegisterProviderState {}

class RegisterProviderSuccess extends RegisterProviderState {
  final bool isError;
  final String message;

  RegisterProviderSuccess({
    required this.isError,
    required this.message,
  });
}

class RegisterProviderFailure extends RegisterProviderState {
  final String errorMessage;

  RegisterProviderFailure({required this.errorMessage});
}

class RegisterProviderCubit extends Cubit<RegisterProviderState> {
  final AuthRepository _authRepository = AuthRepository();

  RegisterProviderCubit() : super(RegisterProviderInitial());

  //
  //This method is used to register provider
  void registerProvider({required Map<String, dynamic> parameter}) async {
    try {
      emit(RegisterProviderInProgress());
      //

      Map<String, dynamic> responseData =
          await _authRepository.registerProvider(parameters: parameter, isAuthTokenRequired: false);

      //
      if (!responseData['error']) {
        emit(RegisterProviderSuccess(
            isError: responseData['error'], message: responseData['message']));
        return;
      }
      //
      emit(RegisterProviderFailure(errorMessage: responseData['message']));
    } catch (e, st) {
      emit(RegisterProviderFailure(errorMessage: st.toString()));
    }
  }
}
