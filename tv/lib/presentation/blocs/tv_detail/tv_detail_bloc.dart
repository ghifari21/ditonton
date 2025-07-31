import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_watchlist_status.dart';
import 'package:tv/domain/usecases/remove_tv_watchlist.dart';
import 'package:tv/domain/usecases/save_tv_watchlist.dart';

part 'tv_detail_event.dart';
part 'tv_detail_state.dart';

class TVDetailBloc extends Bloc<TVDetailEvent, TVDetailState> {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTVDetail getTVDetail;
  final GetTVRecommendations getTVRecommendations;
  final GetTVWatchlistStatus getTVWatchlistStatus;
  final SaveTVWatchlist saveWatchlist;
  final RemoveTVWatchlist removeWatchlist;

  TVDetailBloc({
    required this.getTVDetail,
    required this.getTVRecommendations,
    required this.getTVWatchlistStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TVDetailEmpty()) {
    on<FetchTVDetail>(_onFetchTVDetail);
    on<AddTVToWatchlist>(_onAddTVToWatchlist);
    on<RemoveTVFromWatchlist>(_onRemoveTVFromWatchlist);
    on<LoadTVWatchlistStatus>(_onLoadTVWatchlistStatus);
  }

  Future<void> _onFetchTVDetail(
    FetchTVDetail event,
    Emitter<TVDetailState> emit,
  ) async {
    emit(TVDetailLoading());
    final detailResult = await getTVDetail.execute(event.id);
    final recommendationResult = await getTVRecommendations.execute(event.id);
    final watchlistStatusResult = await getTVWatchlistStatus.execute(event.id);

    detailResult.fold(
      (failure) {
        emit(TVDetailError(failure.message));
      },
      (tv) {
        recommendationResult.fold(
          (failure) => emit(TVDetailError(failure.message)),
          (recommendations) {
            emit(
              TVDetailLoaded(
                tv: tv,
                tvRecommendations: recommendations,
                isAddedToWatchlist: watchlistStatusResult,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _onAddTVToWatchlist(
    AddTVToWatchlist event,
    Emitter<TVDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.tv);
    String message = '';

    result.fold(
      (failure) => message = failure.message,
      (success) => message = watchlistAddSuccessMessage,
    );

    final isAdded = await getTVWatchlistStatus.execute(event.tv.id);

    if (state is TVDetailLoaded) {
      final currentState = state as TVDetailLoaded;
      emit(
        currentState.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistMessage: message,
        ),
      );
    }
  }

  Future<void> _onRemoveTVFromWatchlist(
    RemoveTVFromWatchlist event,
    Emitter<TVDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.tv);
    String message = '';

    result.fold(
      (failure) => message = failure.message,
      (success) => message = watchlistRemoveSuccessMessage,
    );

    final isAdded = await getTVWatchlistStatus.execute(event.tv.id);

    if (state is TVDetailLoaded) {
      final currentState = state as TVDetailLoaded;
      emit(
        currentState.copyWith(
          isAddedToWatchlist: isAdded,
          watchlistMessage: message,
        ),
      );
    }
  }

  Future<void> _onLoadTVWatchlistStatus(
    LoadTVWatchlistStatus event,
    Emitter<TVDetailState> emit,
  ) async {
    final isAdded = await getTVWatchlistStatus.execute(event.id);
    if (state is TVDetailLoaded) {
      final currentState = state as TVDetailLoaded;
      emit(currentState.copyWith(isAddedToWatchlist: isAdded));
    }
  }
}
