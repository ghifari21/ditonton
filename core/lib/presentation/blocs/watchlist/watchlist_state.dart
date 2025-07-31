part of 'watchlist_bloc.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object> get props => [];
}

class WatchlistEmpty extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object> get props => [message];
}

class WatchlistLoaded extends WatchlistState {
  final List<Movie> movies;
  final List<TV> tvs;

  const WatchlistLoaded(this.movies, this.tvs);

  @override
  List<Object> get props => [movies, tvs];
}
