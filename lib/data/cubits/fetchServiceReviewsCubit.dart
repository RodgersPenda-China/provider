// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edemand_partner/data/repository/service_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/data_output.dart';
import '../model/ratings_model.dart';
import '../model/reviews_model.dart';

abstract class FetchServiceReviewsState {}

class FetchServiceReviewsInitial extends FetchServiceReviewsState {}

class FetchServiceReviewsInProgress extends FetchServiceReviewsState {}

class FetchServiceReviewsSuccess extends FetchServiceReviewsState {
  final bool isLoadingMoreReviews;
  final bool loadingMoreReviewsError;
  final List<ReviewsModel> reviews;
  final RatingsModel ratings;
  final int offset;
  final int total;
  FetchServiceReviewsSuccess({
    required this.isLoadingMoreReviews,
    required this.loadingMoreReviewsError,
    required this.reviews,
    required this.ratings,
    required this.offset,
    required this.total,
  });
}

class FetchServiceReviewsFailure extends FetchServiceReviewsState {
  final String errorMessage;

  FetchServiceReviewsFailure(this.errorMessage);
}

class FetchServiceReviewsCubit extends Cubit<FetchServiceReviewsState> {
  FetchServiceReviewsCubit() : super(FetchServiceReviewsInitial());
  final ServiceRepository _serviceRepository = ServiceRepository();
  fetchReviews(int id) async {
    try {
      emit(FetchServiceReviewsInProgress());
      DataOutput<ReviewsModel> result = await _serviceRepository.fetchReviews(id, offset: 0);

      emit(FetchServiceReviewsSuccess(reviews: result.modelList, isLoadingMoreReviews: false, loadingMoreReviewsError: false, offset: 0, ratings: result.extraData?.data, total: result.total));
    } catch (e) {
      emit(FetchServiceReviewsFailure(e.toString()));
    }
  }
}
