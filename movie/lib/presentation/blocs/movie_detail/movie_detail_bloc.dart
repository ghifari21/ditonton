import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_movie_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_movie_watchlist.dart';
import 'package:movie/domain/usecases/save_movie_watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetMovieWatchListStatus getWatchListStatus;
  final SaveMovieWatchlist saveWatchlist;
  final RemoveMovieWatchlist removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>(_onFetchMovieDetail);
    on<AddMovieToWatchlist>(_onAddMovieToWatchlist);
    on<RemoveMovieFromWatchlist>(_onRemoveMovieFromWatchlist);
    on<LoadMovieWatchlistStatus>(_onLoadWatchlistStatus);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetail event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());
    final detailResult = await getMovieDetail.execute(event.id);
    final recommendationResult = await getMovieRecommendations.execute(
      event.id,
    );
    final watchlistStatusResult = await getWatchListStatus.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(MovieDetailError(failure.message));
      },
      (movie) {
        recommendationResult.fold(
          (failure) => emit(MovieDetailError(failure.message)),
          (recommendations) {
            emit(
              MovieDetailLoaded(
                movie: movie,
                movieRecommendations: recommendations,
                isAddedToWatchlist: watchlistStatusResult,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onAddMovieToWatchlist(
    AddMovieToWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);
    String message = '';

    result.fold(
      (failure) => message = failure.message,
      (success) => message = watchlistAddSuccessMessage,
    );

    final isAdded = await getWatchListStatus.execute(event.movie.id);

    if (state is MovieDetailLoaded) {
      final currentState = state as MovieDetailLoaded;
      emit(
        currentState.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistMessage: message,
        ),
      );
    }
  }

  Future<void> _onRemoveMovieFromWatchlist(
    RemoveMovieFromWatchlist event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);
    String message = '';

    result.fold(
      (failure) => message = failure.message,
      (success) => message = watchlistRemoveSuccessMessage,
    );

    final isAdded = await getWatchListStatus.execute(event.movie.id);
    if (state is MovieDetailLoaded) {
      final currentState = state as MovieDetailLoaded;
      emit(
        currentState.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistMessage: message,
        ),
      );
    }
  }

  Future<void> _onLoadWatchlistStatus(
    LoadMovieWatchlistStatus event,
    Emitter<MovieDetailState> emit,
  ) async {
    final isAdded = await getWatchListStatus.execute(event.id);
    if (state is MovieDetailLoaded) {
      final currentState = state as MovieDetailLoaded;
      emit(currentState.copyWith(isAddedToWatchlist: isAdded));
    }
  }
}
