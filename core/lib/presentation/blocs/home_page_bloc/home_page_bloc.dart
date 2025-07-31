import 'package:bloc/bloc.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_airing_today_tvs.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_on_the_air_tvs.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_popular_tvs.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/get_top_rated_tvs.dart';
import 'package:equatable/equatable.dart';

part 'home_page_event.dart';
part 'home_page_state.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;
  final GetAiringTodayTVs getAiringTodayTvs;
  final GetOnTheAirTVs getOnTheAirTvs;
  final GetPopularTVs getPopularTvs;
  final GetTopRatedTVs getTopRatedTvs;

  HomePageBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
    required this.getAiringTodayTvs,
    required this.getOnTheAirTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  }) : super(HomePageEmpty()) {
    on<FetchHomePageData>((event, emit) async {
      emit(HomePageLoading());

      final results = await Future.wait([
        getNowPlayingMovies.execute(),
        getPopularMovies.execute(),
        getTopRatedMovies.execute(),
        getAiringTodayTvs.execute(),
        getOnTheAirTvs.execute(),
        getPopularTvs.execute(),
        getTopRatedTvs.execute(),
      ]);

      if (results.any((result) => result.isLeft())) {
        emit(const HomePageError('Failed to load data'));
        return;
      }

      emit(
        HomePageLoaded(
          nowPlayingMovies:
              results[0].getOrElse(() => <Movie>[]) as List<Movie>,
          popularMovies: results[1].getOrElse(() => <Movie>[]) as List<Movie>,
          topRatedMovies: results[2].getOrElse(() => <Movie>[]) as List<Movie>,
          airingTodayTvs: results[3].getOrElse(() => <TV>[]) as List<TV>,
          onTheAirTvs: results[4].getOrElse(() => <TV>[]) as List<TV>,
          popularTvs: results[5].getOrElse(() => <TV>[]) as List<TV>,
          topRatedTvs: results[6].getOrElse(() => <TV>[]) as List<TV>,
        ),
      );
    });
  }
}
