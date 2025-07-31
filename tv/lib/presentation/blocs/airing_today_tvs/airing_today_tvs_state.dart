part of 'airing_today_tvs_bloc.dart';

abstract class AiringTodayTVsState extends Equatable {
  const AiringTodayTVsState();

  @override
  List<Object> get props => [];
}

class AiringTodayTVsEmpty extends AiringTodayTVsState {}

class AiringTodayTVsLoading extends AiringTodayTVsState {}

class AiringTodayTVsError extends AiringTodayTVsState {
  final String message;

  const AiringTodayTVsError(this.message);

  @override
  List<Object> get props => [message];
}

class AiringTodayTVsLoaded extends AiringTodayTVsState {
  final List<TV> result;

  const AiringTodayTVsLoaded(this.result);

  @override
  List<Object> get props => [result];
}
