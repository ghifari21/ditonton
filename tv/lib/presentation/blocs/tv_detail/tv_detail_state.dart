part of 'tv_detail_bloc.dart';

abstract class TVDetailState extends Equatable {
  const TVDetailState();

  @override
  List<Object> get props => [];
}

class TVDetailEmpty extends TVDetailState {}

class TVDetailLoading extends TVDetailState {}

class TVDetailError extends TVDetailState {
  final String message;

  const TVDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TVDetailLoaded extends TVDetailState {
  final TVDetail tv;
  final List<TV> tvRecommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TVDetailLoaded({
    required this.tv,
    required this.tvRecommendations,
    required this.isAddedToWatchlist,
    this.watchlistMessage = '',
  });

  TVDetailLoaded copyWith({
    TVDetail? tv,
    List<TV>? tvRecommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return TVDetailLoaded(
      tv: tv ?? this.tv,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object> get props => [
    tv,
    tvRecommendations,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
