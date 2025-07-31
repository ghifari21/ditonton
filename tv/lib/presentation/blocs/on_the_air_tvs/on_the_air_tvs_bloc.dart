import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_on_the_air_tvs.dart';
import 'package:equatable/equatable.dart';

part 'on_the_air_tvs_event.dart';
part 'on_the_air_tvs_state.dart';

class OnTheAirTVsBloc extends Bloc<OnTheAirTVsEvent, OnTheAirTVsState> {
  final GetOnTheAirTVs getOnTheAirTvs;

  OnTheAirTVsBloc({required this.getOnTheAirTvs}) : super(OnTheAirTVsEmpty()) {
    on<FetchOnTheAirTVs>((event, emit) async {
      emit(OnTheAirTVsLoading());

      final result = await getOnTheAirTvs.execute();
      result.fold(
        (failure) => emit(OnTheAirTVsError(failure.message)),
        (tvs) => emit(OnTheAirTVsLoaded(tvs)),
      );
    });
  }
}
