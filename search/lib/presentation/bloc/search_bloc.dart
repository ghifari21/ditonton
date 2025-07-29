import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:search/domain/usecases/search_movies.dart';
import 'package:search/domain/usecases/search_tvs.dart';
import 'package:search/presentation/bloc/search_event.dart';
import 'package:search/presentation/bloc/search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;
  final SearchTVs searchTVs;

  SearchBloc({required this.searchMovies, required this.searchTVs})
    : super(SearchEmpty()) {
    on<OnQueryChanged>((event, emit) async {
      final query = event.query;

      emit(SearchLoading());

      final movieResult = await searchMovies.execute(query);
      final tvResult = await searchTVs.execute(query);

      movieResult.fold(
        (failure) {
          emit(SearchError(failure.message));
        },
        (movies) {
          tvResult.fold(
            (failure) => emit(SearchError(failure.message)),
            (tvs) => emit(SearchHasData(movies, tvs)),
          );
        },
      );
    }, transformer: debounce(const Duration(milliseconds: 500)));
  }

  EventTransformer<T> debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
