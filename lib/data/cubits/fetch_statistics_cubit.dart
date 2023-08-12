// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:edemand_partner/data/model/statistics_model.dart';
import 'package:edemand_partner/data/repository/statistics_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class FetchStatisticsState {}

class FetchStatisticsInitial extends FetchStatisticsState {}

class FetchStatisticsInProgress extends FetchStatisticsState {}

class FetchStatisticsSuccess extends FetchStatisticsState {
  final StatisticsModel statistics;
  FetchStatisticsSuccess({
    required this.statistics,
  });
}

class FetchStatisticsFailure extends FetchStatisticsState {
  final String errorMessage;

  FetchStatisticsFailure(this.errorMessage);
}

class FetchStatisticsCubit extends Cubit<FetchStatisticsState> {
  final StatisticsRepository _statisticsRepository = StatisticsRepository();

  FetchStatisticsCubit() : super(FetchStatisticsInitial());

  getStatistics() async {
    try {
      emit(FetchStatisticsInProgress());
      StatisticsModel result = await _statisticsRepository.fetchStatistics();

      // List<MonthlySalesModel> monthlySales =
      //     (result['caregories'] as List).map((element) {
      //   return MonthlySalesModel(
      //       name: element['name'], count: element['total_services']);
      // }).toList();

      // List<CategoryStatesModel> categoryStates =
      //     (result['monthly_earnings']['monthly_sales'] as List).map((element) {
      //   return CategoryStatesModel(
      //       totalAmount: element['total_amount'], month: element['month']);
      // }).toList();

      emit(FetchStatisticsSuccess(statistics: result));
    } catch (e) {
      emit(FetchStatisticsFailure(e.toString()));
    }
  }
}
