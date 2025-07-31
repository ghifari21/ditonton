import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_tvs_event.dart';
part 'top_rated_tvs_state.dart';

class TopRatedTVsBloc extends Bloc<TopRatedTVsEvent, TopRatedTVsState> {
  final GetTopRatedTVs getTopRatedTvs;

  TopRatedTVsBloc({required this.getTopRatedTvs}) : super(TopRatedTVsEmpty()) {
    on<FetchTopRatedTVs>((event, emit) async {
      emit(TopRatedTVsLoading());

      final result = await getTopRatedTvs.execute();
      result.fold(
        (failure) => emit(TopRatedTVsError(failure.message)),
        (tvs) => emit(TopRatedTVsLoaded(tvs)),
      );
    });
  }
}
