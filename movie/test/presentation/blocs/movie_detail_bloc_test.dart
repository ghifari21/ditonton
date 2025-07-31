import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_movie_watchlist_status.dart';
import 'package:movie/domain/usecases/remove_movie_watchlist.dart';
import 'package:movie/domain/usecases/save_movie_watchlist.dart';
import 'package:movie/presentation/blocs/movie_detail/movie_detail_bloc.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetMovieWatchListStatus,
  SaveMovieWatchlist,
  RemoveMovieWatchlist,
])
void main() {
  late MovieDetailBloc bloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetMovieWatchListStatus mockGetMovieWatchListStatus;
  late MockSaveMovieWatchlist mockSaveMovieWatchlist;
  late MockRemoveMovieWatchlist mockRemoveMovieWatchlist;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetMovieWatchListStatus = MockGetMovieWatchListStatus();
    mockSaveMovieWatchlist = MockSaveMovieWatchlist();
    mockRemoveMovieWatchlist = MockRemoveMovieWatchlist();
    bloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetMovieWatchListStatus,
      saveWatchlist: mockSaveMovieWatchlist,
      removeWatchlist: mockRemoveMovieWatchlist,
    );
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(bloc.state, MovieDetailEmpty());
  });

  group('Fetch Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Right(testMovieDetail));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testMovieList));
        when(
          mockGetMovieWatchListStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [
        MovieDetailLoading(),
        MovieDetailLoaded(
          movie: testMovieDetail,
          movieRecommendations: testMovieList,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        verify(mockGetMovieWatchListStatus.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'Should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(
          mockGetMovieDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetMovieRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testMovieList));
        when(
          mockGetMovieWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(FetchMovieDetail(tId)),
      expect: () => [MovieDetailLoading(), MovieDetailError('Server Failure')],
      verify: (_) {
        verify(mockGetMovieDetail.execute(tId));
        verify(mockGetMovieRecommendations.execute(tId));
        verify(mockGetMovieWatchListStatus.execute(tId));
      },
    );
  });

  group('Watchlist Actions', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit updated watchlist status when adding to watchlist succeeds',
      build: () {
        when(
          mockSaveMovieWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          mockGetMovieWatchListStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => MovieDetailLoaded(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        isAddedToWatchlist: false,
      ),
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        isA<MovieDetailLoaded>()
            .having(
              (state) => state.isAddedToWatchlist,
              'isAddedToWatchlist',
              true,
            )
            .having(
              (state) => state.watchlistMessage,
              'watchlistMessage',
              MovieDetailBloc.watchlistAddSuccessMessage,
            ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit updated watchlist status with error message when adding to watchlist fails',
      build: () {
        when(
          mockSaveMovieWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('DB Failure')));
        when(
          mockGetMovieWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => MovieDetailLoaded(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        isAddedToWatchlist: false,
      ),
      act: (bloc) => bloc.add(AddMovieToWatchlist(testMovieDetail)),
      expect: () => [
        isA<MovieDetailLoaded>()
            .having(
              (state) => state.isAddedToWatchlist,
              'isAddedToWatchlist',
              false,
            )
            .having(
              (state) => state.watchlistMessage,
              'watchlistMessage',
              'DB Failure',
            ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit updated watchlist status when removing from watchlist succeeds',
      build: () {
        when(
          mockRemoveMovieWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          mockGetMovieWatchListStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => MovieDetailLoaded(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        isAddedToWatchlist: true,
      ),
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        isA<MovieDetailLoaded>()
            .having(
              (state) => state.isAddedToWatchlist,
              'isAddedToWatchlist',
              false,
            )
            .having(
              (state) => state.watchlistMessage,
              'watchlistMessage',
              MovieDetailBloc.watchlistRemoveSuccessMessage,
            ),
      ],
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit updated watchlist status with error message when removing from watchlist fails',
      build: () {
        when(
          mockRemoveMovieWatchlist.execute(testMovieDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('DB Failure')));
        when(
          mockGetMovieWatchListStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => MovieDetailLoaded(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        isAddedToWatchlist: true,
      ),
      act: (bloc) => bloc.add(RemoveMovieFromWatchlist(testMovieDetail)),
      expect: () => [
        isA<MovieDetailLoaded>()
            .having(
              (state) => state.isAddedToWatchlist,
              'isAddedToWatchlist',
              true,
            )
            .having(
              (state) => state.watchlistMessage,
              'watchlistMessage',
              'DB Failure',
            ),
      ],
    );
  });

  group('Load Watchlist Status', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'should update isAddedToWatchlist status',
      build: () {
        when(
          mockGetMovieWatchListStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => MovieDetailLoaded(
        movie: testMovieDetail,
        movieRecommendations: testMovieList,
        isAddedToWatchlist: false,
      ),
      act: (bloc) => bloc.add(const LoadMovieWatchlistStatus(tId)),
      expect: () => [
        isA<MovieDetailLoaded>().having(
          (state) => state.isAddedToWatchlist,
          'isAddedToWatchlist',
          true,
        ),
      ],
    );
  });
}
