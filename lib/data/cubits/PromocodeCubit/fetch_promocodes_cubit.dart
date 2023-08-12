// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edemand_partner/data/model/data_output.dart';
import 'package:edemand_partner/data/model/promocode_model.dart';
import 'package:edemand_partner/data/repository/promocode_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/constant.dart';

abstract class FetchPromocodesState {}

class FetchPromocodesInitial extends FetchPromocodesState {}

class FetchPromocodesInProgress extends FetchPromocodesState {}

class FetchPromocodesSuccess extends FetchPromocodesState {
  final bool isLoadingMorePromocodes;
  final bool loadingMorePromocodeError;
  final List<PromocodeModel> promocodes;
  final int offset;
  final int total;
  FetchPromocodesSuccess({
    required this.isLoadingMorePromocodes,
    required this.loadingMorePromocodeError,
    required this.promocodes,
    required this.offset,
    required this.total,
  });

  FetchPromocodesSuccess copyWith({
    bool? isLoadingMorePromocodes,
    bool? loadingMorePromocodeError,
    List<PromocodeModel>? promocodes,
    int? offset,
    int? total,
  }) {
    return FetchPromocodesSuccess(
      isLoadingMorePromocodes: isLoadingMorePromocodes ?? this.isLoadingMorePromocodes,
      loadingMorePromocodeError: loadingMorePromocodeError ?? this.loadingMorePromocodeError,
      promocodes: promocodes ?? this.promocodes,
      offset: offset ?? this.offset,
      total: total ?? this.total,
    );
  }
}

class FetchPromocodesFailure extends FetchPromocodesState {
  final String errorMessage;

  FetchPromocodesFailure(this.errorMessage);
}

class FetchPromocodesCubit extends Cubit<FetchPromocodesState> {
  FetchPromocodesCubit() : super(FetchPromocodesInitial());
  final PromocodeRepository _promocodeRepository = PromocodeRepository();
  Future<void> fetchPromocodeList() async {
    try {
      emit(FetchPromocodesInProgress());
      DataOutput<PromocodeModel> result = await _promocodeRepository.fetchPromocodes(offset: 0);
      emit(FetchPromocodesSuccess(isLoadingMorePromocodes: false, loadingMorePromocodeError: false, offset: 0, total: result.total, promocodes: result.modelList));
    } catch (e, st) {
      emit(FetchPromocodesFailure(e.toString()));
    }
  }

  Future<void> fetchMorePromocodes() async {
    if (state is FetchPromocodesSuccess) {
      if ((state as FetchPromocodesSuccess).isLoadingMorePromocodes) {
        return;
      }
      emit((state as FetchPromocodesSuccess).copyWith(isLoadingMorePromocodes: true));
      DataOutput<PromocodeModel> result = await _promocodeRepository.fetchPromocodes(offset: (state as FetchPromocodesSuccess).offset + Constant.limit);
      FetchPromocodesSuccess promocodesState = (state as FetchPromocodesSuccess);
      promocodesState.promocodes.addAll(result.modelList);
      emit(FetchPromocodesSuccess(
          isLoadingMorePromocodes: false, loadingMorePromocodeError: false, promocodes: result.modelList, offset: (state as FetchPromocodesSuccess).offset + Constant.limit, total: result.total));
    }
  }

  void deletePromocodeFromCubit(int id) {
    List<PromocodeModel> promocodes = (state as FetchPromocodesSuccess).promocodes;

    promocodes.removeWhere((element) => element.id == id.toString());

    emit(
      FetchPromocodesSuccess(
        promocodes: promocodes,
        isLoadingMorePromocodes: false,
        loadingMorePromocodeError: false,
        offset: (state as FetchPromocodesSuccess).offset,
        total: (state as FetchPromocodesSuccess).total + 1,
      ),
    );
  }

  void updatePromocode(PromocodeModel model, String promocodeID) {
    if (state is FetchPromocodesSuccess) {
      List<PromocodeModel> promocode = (state as FetchPromocodesSuccess).promocodes;

      //services.insert(0, model); //
      int indexOfModelInList = promocode.indexWhere(
        (element) {
          return element.id == promocodeID;
        },
      );
      promocode[indexOfModelInList] = model;

      emit(
        FetchPromocodesSuccess(
            promocodes: promocode, isLoadingMorePromocodes: false, loadingMorePromocodeError: false, offset: (state as FetchPromocodesSuccess).offset, total: (state as FetchPromocodesSuccess).total),
      );
    }
  }

  addPromocodeToCubit(
    PromocodeModel model,
  ) {
    if (state is FetchPromocodesSuccess) {
      List<PromocodeModel> promocode = (state as FetchPromocodesSuccess).promocodes;

      promocode.insert(0, model);

      emit(
        FetchPromocodesSuccess(
          promocodes: promocode,
          isLoadingMorePromocodes: false,
          loadingMorePromocodeError: false,
          offset: (state as FetchPromocodesSuccess).offset,
          total: (state as FetchPromocodesSuccess).total + 1,
        ),
      );
    }
  }
}
