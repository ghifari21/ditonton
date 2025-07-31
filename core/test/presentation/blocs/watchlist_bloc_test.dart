import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/blocs/watchlist/watchlist_bloc.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late WatchlistBloc bloc;
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late MockGetWatchlistTVs mockGetWatchlistTVs;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    mockGetWatchlistTVs = MockGetWatchlistTVs();
    bloc = WatchlistBloc(
      getWatchlistMovies: mockGetWatchlistMovies,
      getWatchlistTVs: mockGetWatchlistTVs,
    );
  });

  test('initial state should be empty', () {
    expect(bloc.state, WatchlistEmpty());
  });

  blocTest<WatchlistBloc, WatchlistState>(
    'should emit [Loading, Loaded] when fetching data is success',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Right(testMovieList));
      when(
        mockGetWatchlistTVs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlist()),
    expect: () => [
      WatchlistLoading(),
      WatchlistLoaded(testMovieList, testTvList),
    ],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute());
      verify(mockGetWatchlistTVs.execute());
    },
  );

  blocTest<WatchlistBloc, WatchlistState>(
    'should emit [Loading, Error] when fetching data is unsuccessful',
    build: () {
      when(
        mockGetWatchlistMovies.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(
        mockGetWatchlistTVs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchWatchlist()),
    expect: () => [WatchlistLoading(), const WatchlistError('Server Failure')],
    verify: (_) {
      verify(mockGetWatchlistMovies.execute());
      verify(mockGetWatchlistTVs.execute());
    },
  );
}
