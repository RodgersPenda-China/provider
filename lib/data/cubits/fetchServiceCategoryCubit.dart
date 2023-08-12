// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edemand_partner/data/model/service_category_model.dart';
import 'package:edemand_partner/data/repository/service_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/constant.dart';
import '../model/data_output.dart';

abstract class FetchServiceCategoryState {}

class FetchServiceCategoryInitial extends FetchServiceCategoryState {}

class FetchServiceCategoryInProgress extends FetchServiceCategoryState {}

class FetchServiceCategorySuccess extends FetchServiceCategoryState {
  final bool isLoadingMoreServicesCategory;
  final bool loadingMoreServicesCategoryError;
  final List<ServiceCategoryModel> serviceCategories;
  final int offset;
  final int total;
  FetchServiceCategorySuccess({
    required this.isLoadingMoreServicesCategory,
    required this.loadingMoreServicesCategoryError,
    required this.serviceCategories,
    required this.offset,
    required this.total,
  });

  FetchServiceCategorySuccess copyWith({
    bool? isLoadingMoreServicesCategory,
    bool? loadingMoreServicesCategoryError,
    List<ServiceCategoryModel>? serviceCategories,
    int? offset,
    int? total,
  }) {
    return FetchServiceCategorySuccess(
      isLoadingMoreServicesCategory: isLoadingMoreServicesCategory ?? this.isLoadingMoreServicesCategory,
      loadingMoreServicesCategoryError: loadingMoreServicesCategoryError ?? this.loadingMoreServicesCategoryError,
      serviceCategories: serviceCategories ?? this.serviceCategories,
      offset: offset ?? this.offset,
      total: total ?? this.total,
    );
  }
}

class FetchServiceCategoryFailure extends FetchServiceCategoryState {
  final String errorMessage;

  FetchServiceCategoryFailure(this.errorMessage);
}

class FetchServiceCategoryCubit extends Cubit<FetchServiceCategoryState> {
  final ServiceRepository _serviceRepository = ServiceRepository();

  FetchServiceCategoryCubit() : super(FetchServiceCategoryInitial());

  Future<void> fetchCategories() async {
    try {
      emit(FetchServiceCategoryInProgress());

      DataOutput<ServiceCategoryModel> result = await _serviceRepository.fetchCategories(
        offset: 0,
      );

      emit(FetchServiceCategorySuccess(serviceCategories: result.modelList, isLoadingMoreServicesCategory: false, loadingMoreServicesCategoryError: false, offset: 0, total: result.total));
    } catch (e, st) {
      emit(FetchServiceCategoryFailure(e.toString()));
    }
  }

  void fetchMoreCategories() async {
    try {
      if (state is FetchServiceCategorySuccess) {
        if ((state as FetchServiceCategorySuccess).isLoadingMoreServicesCategory) {
          return;
        }

        emit((state as FetchServiceCategorySuccess).copyWith(isLoadingMoreServicesCategory: true));

        List<ServiceCategoryModel> categories = (state as FetchServiceCategorySuccess).serviceCategories;

        DataOutput<ServiceCategoryModel> result = await _serviceRepository.fetchCategories(offset: (state as FetchServiceCategorySuccess).offset + Constant.limit);

        categories.addAll(result.modelList);

        emit(
          FetchServiceCategorySuccess(
            serviceCategories: categories,
            isLoadingMoreServicesCategory: false,
            loadingMoreServicesCategoryError: false,
            offset: (state as FetchServiceCategorySuccess).offset + Constant.limit,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit((state as FetchServiceCategorySuccess).copyWith(isLoadingMoreServicesCategory: false, loadingMoreServicesCategoryError: true));
    }
  }

  bool hasMoreData() {
    if (state is FetchServiceCategorySuccess) {
      return (state as FetchServiceCategorySuccess).offset < (state as FetchServiceCategorySuccess).total;
    }

    return false;
  }
}
