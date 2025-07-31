import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchLoaded extends SearchState {
  final List<Movie> movies;
  final List<TV> tvs;

  const SearchLoaded(this.movies, this.tvs);

  @override
  List<Object> get props => [movies, tvs];
}
