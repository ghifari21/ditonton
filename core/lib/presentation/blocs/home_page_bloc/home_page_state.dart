part of 'home_page_bloc.dart';

abstract class HomePageState extends Equatable {
  const HomePageState();

  @override
  List<Object> get props => [];
}

class HomePageEmpty extends HomePageState {}

class HomePageLoading extends HomePageState {}

class HomePageError extends HomePageState {
  final String message;

  const HomePageError(this.message);

  @override
  List<Object> get props => [message];
}

class HomePageLoaded extends HomePageState {
  final List<Movie> nowPlayingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<TV> airingTodayTvs;
  final List<TV> onTheAirTvs;
  final List<TV> popularTvs;
  final List<TV> topRatedTvs;

  const HomePageLoaded({
    required this.nowPlayingMovies,
    required this.popularMovies,
    required this.topRatedMovies,
    required this.airingTodayTvs,
    required this.onTheAirTvs,
    required this.popularTvs,
    required this.topRatedTvs,
  });

  @override
  List<Object> get props => [
    nowPlayingMovies,
    popularMovies,
    topRatedMovies,
    airingTodayTvs,
    onTheAirTvs,
    popularTvs,
    topRatedTvs,
  ];
}
