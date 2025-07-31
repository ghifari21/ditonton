part of 'top_rated_tvs_bloc.dart';

abstract class TopRatedTVsState extends Equatable {
  const TopRatedTVsState();

  @override
  List<Object> get props => [];
}

class TopRatedTVsEmpty extends TopRatedTVsState {}

class TopRatedTVsLoading extends TopRatedTVsState {}

class TopRatedTVsError extends TopRatedTVsState {
  final String message;

  const TopRatedTVsError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedTVsLoaded extends TopRatedTVsState {
  final List<TV> result;

  const TopRatedTVsLoaded(this.result);

  @override
  List<Object> get props => [result];
}
