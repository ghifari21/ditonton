part of 'popular_tvs_bloc.dart';

abstract class PopularTVsState extends Equatable {
  const PopularTVsState();

  @override
  List<Object> get props => [];
}

class PopularTVsEmpty extends PopularTVsState {}

class PopularTVsLoading extends PopularTVsState {}

class PopularTVsError extends PopularTVsState {
  final String message;

  const PopularTVsError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularTVsLoaded extends PopularTVsState {
  final List<TV> result;

  const PopularTVsLoaded(this.result);

  @override
  List<Object> get props => [result];
}
