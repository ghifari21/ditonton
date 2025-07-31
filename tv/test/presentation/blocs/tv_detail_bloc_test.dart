import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';
import 'package:tv/domain/usecases/get_tv_watchlist_status.dart';
import 'package:tv/domain/usecases/remove_tv_watchlist.dart';
import 'package:tv/domain/usecases/save_tv_watchlist.dart';
import 'package:tv/presentation/blocs/tv_detail/tv_detail_bloc.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import 'tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTVDetail,
  GetTVRecommendations,
  GetTVWatchlistStatus,
  SaveTVWatchlist,
  RemoveTVWatchlist,
])
void main() {
  late TVDetailBloc bloc;
  late MockGetTVDetail mockGetTVDetail;
  late MockGetTVRecommendations mockGetTVRecommendations;
  late MockGetTVWatchlistStatus mockGetTVWatchlistStatus;
  late MockSaveTVWatchlist mockSaveTVWatchlist;
  late MockRemoveTVWatchlist mockRemoveTVWatchlist;

  setUp(() {
    mockGetTVDetail = MockGetTVDetail();
    mockGetTVRecommendations = MockGetTVRecommendations();
    mockGetTVWatchlistStatus = MockGetTVWatchlistStatus();
    mockSaveTVWatchlist = MockSaveTVWatchlist();
    mockRemoveTVWatchlist = MockRemoveTVWatchlist();
    bloc = TVDetailBloc(
      getTVDetail: mockGetTVDetail,
      getTVRecommendations: mockGetTVRecommendations,
      getTVWatchlistStatus: mockGetTVWatchlistStatus,
      saveWatchlist: mockSaveTVWatchlist,
      removeWatchlist: mockRemoveTVWatchlist,
    );
  });

  const tId = 1;

  test('initial state should be empty', () {
    expect(bloc.state, TVDetailEmpty());
  });

  group('Fetch TV Detail', () {
    blocTest<TVDetailBloc, TVDetailState>(
      'Should emit [Loading, Loaded] when data is gotten successfully',
      build: () {
        when(
          mockGetTVDetail.execute(tId),
        ).thenAnswer((_) async => Right(testTvDetail));
        when(
          mockGetTVRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testTvList));
        when(
          mockGetTVWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTVDetail(tId)),
      expect: () => [
        TVDetailLoading(),
        TVDetailLoaded(
          tv: testTvDetail,
          tvRecommendations: testTvList,
          isAddedToWatchlist: true,
        ),
      ],
      verify: (_) {
        verify(mockGetTVDetail.execute(tId));
        verify(mockGetTVRecommendations.execute(tId));
        verify(mockGetTVWatchlistStatus.execute(tId));
      },
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'Should emit [Loading, Error] when get detail is unsuccessful',
      build: () {
        when(
          mockGetTVDetail.execute(tId),
        ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
        when(
          mockGetTVRecommendations.execute(tId),
        ).thenAnswer((_) async => Right(testTvList));
        when(
          mockGetTVWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      act: (bloc) => bloc.add(const FetchTVDetail(tId)),
      expect: () => [TVDetailLoading(), const TVDetailError('Server Failure')],
      verify: (_) {
        verify(mockGetTVDetail.execute(tId));
        verify(mockGetTVRecommendations.execute(tId));
        verify(mockGetTVWatchlistStatus.execute(tId));
      },
    );
  });

  group('Watchlist Actions', () {
    blocTest<TVDetailBloc, TVDetailState>(
      'should emit updated watchlist status when adding to watchlist succeeds',
      build: () {
        when(
          mockSaveTVWatchlist.execute(testTvDetail),
        ).thenAnswer((_) async => const Right('Added to Watchlist'));
        when(
          mockGetTVWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => TVDetailLoaded(
        tv: testTvDetail,
        tvRecommendations: testTvList,
        isAddedToWatchlist: false,
      ),
      act: (bloc) => bloc.add(AddTVToWatchlist(testTvDetail)),
      expect: () => [
        isA<TVDetailLoaded>()
            .having(
              (state) => state.isAddedToWatchlist,
              'isAddedToWatchlist',
              true,
            )
            .having(
              (state) => state.watchlistMessage,
              'watchlistMessage',
              TVDetailBloc.watchlistAddSuccessMessage,
            ),
      ],
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'should emit updated watchlist status with error message when adding to watchlist fails',
      build: () {
        when(
          mockSaveTVWatchlist.execute(testTvDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('DB Failure')));
        when(
          mockGetTVWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => TVDetailLoaded(
        tv: testTvDetail,
        tvRecommendations: testTvList,
        isAddedToWatchlist: false,
      ),
      act: (bloc) => bloc.add(AddTVToWatchlist(testTvDetail)),
      expect: () => [
        isA<TVDetailLoaded>()
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

    blocTest<TVDetailBloc, TVDetailState>(
      'should emit updated watchlist status when removing from watchlist succeeds',
      build: () {
        when(
          mockRemoveTVWatchlist.execute(testTvDetail),
        ).thenAnswer((_) async => const Right('Removed from Watchlist'));
        when(
          mockGetTVWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => false);
        return bloc;
      },
      seed: () => TVDetailLoaded(
        tv: testTvDetail,
        tvRecommendations: testTvList,
        isAddedToWatchlist: true,
      ),
      act: (bloc) => bloc.add(RemoveTVFromWatchlist(testTvDetail)),
      expect: () => [
        isA<TVDetailLoaded>()
            .having(
              (state) => state.isAddedToWatchlist,
              'isAddedToWatchlist',
              false,
            )
            .having(
              (state) => state.watchlistMessage,
              'watchlistMessage',
              TVDetailBloc.watchlistRemoveSuccessMessage,
            ),
      ],
    );

    blocTest<TVDetailBloc, TVDetailState>(
      'should emit updated watchlist status with error message when removing from watchlist fails',
      build: () {
        when(
          mockRemoveTVWatchlist.execute(testTvDetail),
        ).thenAnswer((_) async => Left(DatabaseFailure('DB Failure')));
        when(
          mockGetTVWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => TVDetailLoaded(
        tv: testTvDetail,
        tvRecommendations: testTvList,
        isAddedToWatchlist: true,
      ),
      act: (bloc) => bloc.add(RemoveTVFromWatchlist(testTvDetail)),
      expect: () => [
        isA<TVDetailLoaded>()
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
    blocTest<TVDetailBloc, TVDetailState>(
      'should update isAddedToWatchlist status',
      build: () {
        when(
          mockGetTVWatchlistStatus.execute(tId),
        ).thenAnswer((_) async => true);
        return bloc;
      },
      seed: () => TVDetailLoaded(
        tv: testTvDetail,
        tvRecommendations: testTvList,
        isAddedToWatchlist: false,
      ),
      act: (bloc) => bloc.add(const LoadTVWatchlistStatus(tId)),
      expect: () => [
        isA<TVDetailLoaded>().having(
          (state) => state.isAddedToWatchlist,
          'isAddedToWatchlist',
          true,
        ),
      ],
    );
  });
}
