// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edemand_partner/utils/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:edemand_partner/data/model/categoryModel.dart';
import 'package:edemand_partner/data/model/data_output.dart';
import 'package:edemand_partner/data/repository/categories_repository.dart';

abstract class FetchCategoriesState {}

class FetchCategoriesInitial extends FetchCategoriesState {}

class FetchCategoriesInProgress extends FetchCategoriesState {}

class FetchCategoriesSuccess extends FetchCategoriesState {
  final bool isLoadingMoreCategories;
  final bool loadingMoreCategoriesError;
  final List<CategoryModel> categories;
  final int offset;
  final int total;
  FetchCategoriesSuccess({
    required this.isLoadingMoreCategories,
    required this.loadingMoreCategoriesError,
    required this.categories,
    required this.offset,
    required this.total,
  });

  FetchCategoriesSuccess copyWith({
    bool? isLoadingMoreCategories,
    bool? loadingMoreCategoriesError,
    List<CategoryModel>? categories,
    int? offset,
    int? total,
  }) {
    return FetchCategoriesSuccess(
      isLoadingMoreCategories:
          isLoadingMoreCategories ?? this.isLoadingMoreCategories,
      loadingMoreCategoriesError:
          loadingMoreCategoriesError ?? this.loadingMoreCategoriesError,
      categories: categories ?? this.categories,
      offset: offset ?? this.offset,
      total: total ?? this.total,
    );
  }
}

class FetchCategoriesFailure extends FetchCategoriesState {
  final String errorMessage;

  FetchCategoriesFailure(this.errorMessage);
}

class FetchCategoriesCubit extends Cubit<FetchCategoriesState> {
  FetchCategoriesCubit() : super(FetchCategoriesInitial());
  final CategoriesRepository _categoriesRepository = CategoriesRepository();
  void fetchCategories() async {
    try {
      emit(FetchCategoriesInProgress());
      DataOutput<CategoryModel> categories =
          await _categoriesRepository.fetchCategories(offset: 0);
      emit(FetchCategoriesSuccess(
          categories: categories.modelList,
          isLoadingMoreCategories: false,
          loadingMoreCategoriesError: false,
          offset: 0,
          total: categories.total));
    } catch (e) {
      emit(FetchCategoriesFailure(e.toString()));
    }
  }

  void fetchMoreCategories() async {
    try {
      if (state is FetchCategoriesSuccess) {
        if ((state as FetchCategoriesSuccess).isLoadingMoreCategories) {
          return;
        }

        emit((state as FetchCategoriesSuccess)
            .copyWith(isLoadingMoreCategories: true));

        List<CategoryModel> categories =
            (state as FetchCategoriesSuccess).categories;

        DataOutput<CategoryModel> result =
            await _categoriesRepository.fetchCategories(
                offset:
                    (state as FetchCategoriesSuccess).offset + Constant.limit);

        categories.addAll(result.modelList);

        emit(
          FetchCategoriesSuccess(
            categories: categories,
            isLoadingMoreCategories: false,
            loadingMoreCategoriesError: false,
            offset: (state as FetchCategoriesSuccess).offset + Constant.limit,
            total: result.total,
          ),
        );
      }
    } catch (e) {
      emit((state as FetchCategoriesSuccess).copyWith(
          isLoadingMoreCategories: false, loadingMoreCategoriesError: true));
    }
  }

  bool hasMoreCategories() {
    if (state is FetchCategoriesSuccess) {
      return (state as FetchCategoriesSuccess).offset <
          (state as FetchCategoriesSuccess).total;
    }

    return false;
  }
}
