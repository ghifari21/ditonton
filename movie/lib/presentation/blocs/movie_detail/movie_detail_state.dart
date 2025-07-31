part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> movieRecommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailLoaded({
    required this.movie,
    required this.movieRecommendations,
    required this.isAddedToWatchlist,
    this.watchlistMessage = '',
  });

  MovieDetailLoaded copyWith({
    MovieDetail? movie,
    List<Movie>? movieRecommendations,
    bool? isAddedToWatchlist,
    String? watchlistMessage,
  }) {
    return MovieDetailLoaded(
      movie: movie ?? this.movie,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      watchlistMessage: watchlistMessage ?? this.watchlistMessage,
    );
  }

  @override
  List<Object> get props => [
    movie,
    movieRecommendations,
    isAddedToWatchlist,
    watchlistMessage,
  ];
}
