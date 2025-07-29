import 'dart:io';

import 'package:core/data/models/genre_model.dart';
import 'package:core/data/models/tv_detail_model.dart';
import 'package:core/data/models/tv_model.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/utils/exception.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVRepositoryImpl repository;
  late MockTVRemoteDataSource mockTVRemoteDataSource;
  late MockTVLocalDataSource mockTVLocalDataSource;

  setUp(() {
    mockTVRemoteDataSource = MockTVRemoteDataSource();
    mockTVLocalDataSource = MockTVLocalDataSource();
    repository = TVRepositoryImpl(
      remoteDataSource: mockTVRemoteDataSource,
      localDataSource: mockTVLocalDataSource,
    );
  });

  final tTvModel = TVModel(
    backdropPath: '/96RT2A47UdzWlUfvIERFyBsLhL2.jpg',
    firstAirDate: '2023-09-29',
    genreIds: [16, 10759, 18, 10765],
    id: 209867,
    name: 'Freiren: Beyond Journey\'s End',
    originCountry: 'JP',
    originalLanguage: 'ja',
    originalName: '葬送のフリーレン',
    overview:
        'Decades after her party defeated the Demon King, an old friend\'s funeral launches the elf wizard Frieren on a journey of self-discovery.',
    popularity: 56.3858,
    posterPath: '/dqZENchTd7lp5zht7BdlqM7RBhD.jpg',
    voteAverage: 8.78,
    voteCount: 475,
  );

  final tTv = TV(
    backdropPath: '/96RT2A47UdzWlUfvIERFyBsLhL2.jpg',
    firstAirDate: '2023-09-29',
    genreIds: [16, 10759, 18, 10765],
    id: 209867,
    name: 'Freiren: Beyond Journey\'s End',
    originCountry: 'JP',
    originalLanguage: 'ja',
    originalName: '葬送のフリーレン',
    overview:
        'Decades after her party defeated the Demon King, an old friend\'s funeral launches the elf wizard Frieren on a journey of self-discovery.',
    popularity: 56.3858,
    posterPath: '/dqZENchTd7lp5zht7BdlqM7RBhD.jpg',
    voteAverage: 8.78,
    voteCount: 475,
  );

  final tTvList = <TV>[tTv];
  final tTvModelList = <TVModel>[tTvModel];

  group('Airing Today TV Series', () {
    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        when(
          mockTVRemoteDataSource.getAiringTodayTvShows(),
        ).thenAnswer((_) async => tTvModelList);

        final result = await repository.getAiringTodayTvs();
        verify(mockTVRemoteDataSource.getAiringTodayTvShows());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return server failure when the call to remote data source is failed',
      () async {
        when(
          mockTVRemoteDataSource.getAiringTodayTvShows(),
        ).thenThrow(ServerException());

        final result = await repository.getAiringTodayTvs();
        verify(mockTVRemoteDataSource.getAiringTodayTvShows());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when the device is not connected to internet',
      () async {
        when(
          mockTVRemoteDataSource.getAiringTodayTvShows(),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getAiringTodayTvs();
        verify(mockTVRemoteDataSource.getAiringTodayTvShows());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('On The Air TV Series', () {
    test(
      'should return TV list when call to remote data source is success',
      () async {
        when(
          mockTVRemoteDataSource.getOnTheAirTvShows(),
        ).thenAnswer((_) async => tTvModelList);

        final result = await repository.getOnTheAirTvs();
        verify(mockTVRemoteDataSource.getOnTheAirTvShows());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return server failure when call to remote data source is failed',
      () async {
        when(
          mockTVRemoteDataSource.getOnTheAirTvShows(),
        ).thenThrow(ServerException());

        final result = await repository.getOnTheAirTvs();
        verify(mockTVRemoteDataSource.getOnTheAirTvShows());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        when(
          mockTVRemoteDataSource.getOnTheAirTvShows(),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getOnTheAirTvs();
        verify(mockTVRemoteDataSource.getOnTheAirTvShows());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Popular TV Series', () {
    test(
      'should return TV list when call to remote data source is success',
      () async {
        when(
          mockTVRemoteDataSource.getPopularTvShows(),
        ).thenAnswer((_) async => tTvModelList);

        final result = await repository.getPopularTvs();
        verify(mockTVRemoteDataSource.getPopularTvShows());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return server failure when call to remote data source is failed',
      () async {
        when(
          mockTVRemoteDataSource.getPopularTvShows(),
        ).thenThrow(ServerException());

        final result = await repository.getPopularTvs();
        verify(mockTVRemoteDataSource.getPopularTvShows());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        when(
          mockTVRemoteDataSource.getPopularTvShows(),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getPopularTvs();
        verify(mockTVRemoteDataSource.getPopularTvShows());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Top Rated TV Series', () {
    test(
      'should return TV list when call to remote data source is success',
      () async {
        when(
          mockTVRemoteDataSource.getTopRatedTvShows(),
        ).thenAnswer((_) async => tTvModelList);

        final result = await repository.getTopRatedTvs();
        verify(mockTVRemoteDataSource.getTopRatedTvShows());
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return server failure when call to remote data source is failed',
      () async {
        when(
          mockTVRemoteDataSource.getTopRatedTvShows(),
        ).thenThrow(ServerException());

        final result = await repository.getTopRatedTvs();
        verify(mockTVRemoteDataSource.getTopRatedTvShows());
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return connection failure when device is not connected to the internet',
      () async {
        when(
          mockTVRemoteDataSource.getTopRatedTvShows(),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getTopRatedTvs();
        verify(mockTVRemoteDataSource.getTopRatedTvShows());
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get TV Detail', () {
    final tId = 1;
    final tTvResponse = TVDetailResponse(
      adult: false,
      backdropPath: '/96RT2A47UdzWlUfvIERFyBsLhL2.jpg',
      episodeRunTime: [25],
      firstAirDate: '2023-09-29',
      genres: [GenreModel(id: 16, name: 'Animation')],
      homepage: 'https://frieren-anime.jp/',
      id: 1,
      inProduction: true,
      languages: ['ja'],
      lastAirDate: '2024-03-22',
      name: 'name',
      numberOfEpisodes: 28,
      numberOfSeasons: 2,
      originCountry: ['JP'],
      originalLanguage: 'ja',
      originalName: '葬送のフリーレン',
      overview: 'overview',
      popularity: 56.3858,
      posterPath: 'posterPath',
      status: 'Returning Series',
      tagline: '',
      type: 'Scripted',
      voteAverage: 8.78,
      voteCount: 475,
    );

    test(
      'should return TV data when the call to remote data source is success',
      () async {
        when(
          mockTVRemoteDataSource.getTvShowDetail(tId),
        ).thenAnswer((_) async => tTvResponse);

        final result = await repository.getTvDetail(tId);
        verify(mockTVRemoteDataSource.getTvShowDetail(tId));
        expect(result, equals(Right(testTvDetail)));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is failed',
      () async {
        when(
          mockTVRemoteDataSource.getTvShowDetail(tId),
        ).thenThrow(ServerException());

        final result = await repository.getTvDetail(tId);
        verify(mockTVRemoteDataSource.getTvShowDetail(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return Connection Failure when the device is not connected to the internet',
      () async {
        when(
          mockTVRemoteDataSource.getTvShowDetail(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getTvDetail(tId);
        verify(mockTVRemoteDataSource.getTvShowDetail(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Get TV Series Recommendations', () {
    final tId = 1;
    final tTvList = <TVModel>[];

    test(
      'should return TV list when the call to remote data source is success',
      () async {
        when(
          mockTVRemoteDataSource.getTvShowRecommendations(tId),
        ).thenAnswer((_) async => tTvList);

        final result = await repository.getTvRecommendations(tId);
        verify(mockTVRemoteDataSource.getTvShowRecommendations(tId));
        final resultList = result.getOrElse(() => []);
        expect(resultList, equals(tTvList));
      },
    );

    test(
      'should return Server Failure when the call to remote data source is failed',
      () async {
        when(
          mockTVRemoteDataSource.getTvShowRecommendations(tId),
        ).thenThrow(ServerException());

        final result = await repository.getTvRecommendations(tId);
        verify(mockTVRemoteDataSource.getTvShowRecommendations(tId));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return Connection Failure when the device is not connected to the internet',
      () async {
        when(
          mockTVRemoteDataSource.getTvShowRecommendations(tId),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.getTvRecommendations(tId);
        verify(mockTVRemoteDataSource.getTvShowRecommendations(tId));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('Search TV Series', () {
    final tQuery = 'the fragrant flower';

    test(
      'should return TV list wen call to remote data source is success',
      () async {
        when(
          mockTVRemoteDataSource.searchTvShows(tQuery),
        ).thenAnswer((_) async => tTvModelList);

        final result = await repository.searchTvs(tQuery);
        verify(mockTVRemoteDataSource.searchTvShows(tQuery));
        final resultList = result.getOrElse(() => []);
        expect(resultList, tTvList);
      },
    );

    test(
      'should return Server Failure when call to remote data source is failed',
      () async {
        when(
          mockTVRemoteDataSource.searchTvShows(tQuery),
        ).thenThrow(ServerException());

        final result = await repository.searchTvs(tQuery);
        verify(mockTVRemoteDataSource.searchTvShows(tQuery));
        expect(result, equals(Left(ServerFailure(''))));
      },
    );

    test(
      'should return Connection Failure when device is not connected to the internet',
      () async {
        when(
          mockTVRemoteDataSource.searchTvShows(tQuery),
        ).thenThrow(SocketException('Failed to connect to the network'));

        final result = await repository.searchTvs(tQuery);
        verify(mockTVRemoteDataSource.searchTvShows(tQuery));
        expect(
          result,
          equals(Left(ConnectionFailure('Failed to connect to the network'))),
        );
      },
    );
  });

  group('save watchlist', () {
    test(
      'should return success message when saving watchlist to local data source',
      () async {
        when(
          mockTVLocalDataSource.insertWatchlist(testTvTable),
        ).thenAnswer((_) async => 'Added to Watchlist');

        final result = await repository.saveWatchlist(testTvDetail);
        verify(mockTVLocalDataSource.insertWatchlist(testTvTable));
        expect(result, Right('Added to Watchlist'));
      },
    );

    test(
      'should return Database Failure when saving watchlist is failed',
      () async {
        when(
          mockTVLocalDataSource.insertWatchlist(testTvTable),
        ).thenThrow(DatabaseException('Failed to add watchlist'));

        final result = await repository.saveWatchlist(testTvDetail);
        verify(mockTVLocalDataSource.insertWatchlist(testTvTable));
        expect(result, Left(DatabaseFailure('Failed to add watchlist')));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when removing watchlist from local data source ',
      () async {
        when(
          mockTVLocalDataSource.removeWatchlist(testTvTable),
        ).thenAnswer((_) async => 'Removed from Watchlist');

        final result = await repository.removeWatchlist(testTvDetail);
        verify(mockTVLocalDataSource.removeWatchlist(testTvTable));
        expect(result, Right('Removed from Watchlist'));
      },
    );

    test(
      'should return Database Failure when removing watchlist is failed',
      () async {
        when(
          mockTVLocalDataSource.removeWatchlist(testTvTable),
        ).thenThrow(DatabaseException('Failed to remove watchlist'));

        final result = await repository.removeWatchlist(testTvDetail);
        verify(mockTVLocalDataSource.removeWatchlist(testTvTable));
        expect(result, Left(DatabaseFailure('Failed to remove watchlist')));
      },
    );
  });

  group('Get watchlist status', () {
    test('should return watch status whether data is found', () async {
      final tId = 1;
      when(mockTVLocalDataSource.getTvById(tId)).thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(tId);
      verify(mockTVLocalDataSource.getTvById(tId));
      expect(result, false);
    });
  });

  group('Get watchlist TV Series', () {
    test('should return list of TV from local data source', () async {
      when(
        mockTVLocalDataSource.getWatchlistTvs(),
      ).thenAnswer((_) async => [testTvTable]);

      final result = await repository.getWatchlistTvs();
      verify(mockTVLocalDataSource.getWatchlistTvs());
      final resultList = result.getOrElse(() => []);
      expect(resultList, [testWatchlistTv]);
    });
  });
}
