import 'package:edemand_partner/data/model/user_details_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProviderDetailsState {
  final ProviderDetails providerDetails;
  ProviderDetailsState(this.providerDetails);
}

class UserInfoCubit extends Cubit<ProviderDetailsState> {
  UserInfoCubit() : super(ProviderDetailsState(ProviderDetails.createEmptyModel()));

  void setUserInfo(ProviderDetails userInfo) {
    emit(ProviderDetailsState(userInfo));
  }

  ProviderDetails get providerDetails => state.providerDetails;
}
