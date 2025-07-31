import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_popular_tvs.dart';
import 'package:equatable/equatable.dart';

part 'popular_tvs_event.dart';
part 'popular_tvs_state.dart';

class PopularTVsBloc extends Bloc<PopularTVsEvent, PopularTVsState> {
  final GetPopularTVs getPopularTvs;

  PopularTVsBloc({required this.getPopularTvs}) : super(PopularTVsEmpty()) {
    on<FetchPopularTVs>((event, emit) async {
      emit(PopularTVsLoading());

      final result = await getPopularTvs.execute();
      result.fold(
        (failure) => emit(PopularTVsError(failure.message)),
        (tvs) => emit(PopularTVsLoaded(tvs)),
      );
    });
  }
}
