import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late HomePageBloc bloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late MockGetPopularMovies mockGetPopularMovies;
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late MockGetAiringTodayTVs mockGetAiringTodayTvs;
  late MockGetOnTheAirTVs mockGetOnTheAirTvs;
  late MockGetPopularTVs mockGetPopularTvs;
  late MockGetTopRatedTVs mockGetTopRatedTvs;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    mockGetPopularMovies = MockGetPopularMovies();
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    mockGetAiringTodayTvs = MockGetAiringTodayTVs();
    mockGetOnTheAirTvs = MockGetOnTheAirTVs();
    mockGetPopularTvs = MockGetPopularTVs();
    mockGetTopRatedTvs = MockGetTopRatedTVs();

    bloc = HomePageBloc(
      getNowPlayingMovies: mockGetNowPlayingMovies,
      getPopularMovies: mockGetPopularMovies,
      getTopRatedMovies: mockGetTopRatedMovies,
      getAiringTodayTvs: mockGetAiringTodayTvs,
      getOnTheAirTvs: mockGetOnTheAirTvs,
      getPopularTvs: mockGetPopularTvs,
      getTopRatedTvs: mockGetTopRatedTvs,
    );
  });

  test('should be an instance of GetNowPlayingMovies', () {
    expect(bloc.state, isA<HomePageEmpty>());
  });

  blocTest<HomePageBloc, HomePageState>(
    'should emit [Loading, Loaded] when fetching data is successful',
    build: () {
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      when(
        mockGetAiringTodayTvs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      when(
        mockGetOnTheAirTvs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      when(
        mockGetPopularTvs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchHomePageData()),
    expect: () => [
      HomePageLoading(),
      HomePageLoaded(
        nowPlayingMovies: testMovieList,
        popularMovies: testMovieList,
        topRatedMovies: testMovieList,
        airingTodayTvs: testTvList,
        onTheAirTvs: testTvList,
        popularTvs: testTvList,
        topRatedTvs: testTvList,
      ),
    ],
    verify: (_) {
      verify(mockGetNowPlayingMovies.execute());
      verify(mockGetPopularMovies.execute());
      verify(mockGetTopRatedMovies.execute());
      verify(mockGetAiringTodayTvs.execute());
      verify(mockGetOnTheAirTvs.execute());
      verify(mockGetPopularTvs.execute());
      verify(mockGetTopRatedTvs.execute());
    },
  );

  blocTest<HomePageBloc, HomePageState>(
    'should emit [Loading, Error] when fetching data is unsuccessful',
    build: () {
      when(
        mockGetNowPlayingMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetPopularMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetTopRatedMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetAiringTodayTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetOnTheAirTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetPopularTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetTopRatedTvs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchHomePageData()),
    expect: () => [
      HomePageLoading(),
      const HomePageError('Failed to load data'),
    ],
    verify: (_) {
      verify(mockGetNowPlayingMovies.execute());
      verify(mockGetPopularMovies.execute());
      verify(mockGetTopRatedMovies.execute());
      verify(mockGetAiringTodayTvs.execute());
      verify(mockGetOnTheAirTvs.execute());
      verify(mockGetPopularTvs.execute());
      verify(mockGetTopRatedTvs.execute());
    },
  );
}
