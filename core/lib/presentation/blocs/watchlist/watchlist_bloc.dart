import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_tvs.dart';
import 'package:equatable/equatable.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlistMovies getWatchlistMovies;
  final GetWatchlistTVs getWatchlistTVs;

  WatchlistBloc({
    required this.getWatchlistMovies,
    required this.getWatchlistTVs,
  }) : super(WatchlistEmpty()) {
    on<FetchWatchlist>((event, emit) async {
      emit(WatchlistLoading());

      final movieResult = await getWatchlistMovies.execute();
      final tvResult = await getWatchlistTVs.execute();

      movieResult.fold(
        (failure) {
          emit(WatchlistError(failure.message));
        },
        (movies) {
          tvResult.fold(
            (failure) => emit(WatchlistError(failure.message)),
            (tvs) => emit(WatchlistLoaded(movies, tvs)),
          );
        },
      );
    });
  }
}
