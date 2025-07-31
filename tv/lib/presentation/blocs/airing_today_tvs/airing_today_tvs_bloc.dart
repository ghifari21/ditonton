import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_airing_today_tvs.dart';
import 'package:equatable/equatable.dart';

part 'airing_today_tvs_event.dart';
part 'airing_today_tvs_state.dart';

class AiringTodayTVsBloc
    extends Bloc<AiringTodayTVsEvent, AiringTodayTVsState> {
  final GetAiringTodayTVs getAiringTodayTvs;

  AiringTodayTVsBloc({required this.getAiringTodayTvs})
    : super(AiringTodayTVsEmpty()) {
    on<FetchAiringTodayTVs>((event, emit) async {
      emit(AiringTodayTVsLoading());

      final result = await getAiringTodayTvs.execute();
      result.fold(
        (failure) => emit(AiringTodayTVsError(failure.message)),
        (tvs) => emit(AiringTodayTVsLoaded(tvs)),
      );
    });
  }
}
