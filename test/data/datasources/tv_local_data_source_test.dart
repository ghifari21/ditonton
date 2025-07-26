import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TVLocalDataSourceImpl dataSource;
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
    dataSource = TVLocalDataSourceImpl(databaseHelper: mockDatabaseHelper);
  });

  group('save watchlist', () {
    test(
      'should return success message when insert to database is success',
      () async {
        when(
          mockDatabaseHelper.insertTvWatchlist(testTvTable),
        ).thenAnswer((_) async => 1);

        final result = await dataSource.insertWatchlist(testTvTable);
        expect(result, 'Added to Watchlist');
      },
    );

    test(
      'should throw DatabaseException when insert to database is failed',
      () async {
        when(
          mockDatabaseHelper.insertTvWatchlist(testTvTable),
        ).thenThrow(Exception());

        final call = dataSource.insertWatchlist(testTvTable);
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('remove watchlist', () {
    test(
      'should return success message when remove from database is success',
      () async {
        when(
          mockDatabaseHelper.removeTvWatchlist(testTvTable),
        ).thenAnswer((_) async => 1);

        final result = await dataSource.removeWatchlist(testTvTable);
        expect(result, 'Removed from Watchlist');
      },
    );

    test(
      'should throw DatabaseException when remove from database is failed',
      () async {
        when(
          mockDatabaseHelper.removeTvWatchlist(testTvTable),
        ).thenThrow(Exception());

        final call = dataSource.removeWatchlist(testTvTable);
        expect(() => call, throwsA(isA<DatabaseException>()));
      },
    );
  });

  group('Get TV Detail By Id', () {
    final tId = 1;

    test('should return TV Detail Table when data is found', () async {
      when(
        mockDatabaseHelper.getTvById(tId),
      ).thenAnswer((_) async => testTvMap);

      final result = await dataSource.getTvById(tId);
      expect(result, testTvTable);
    });

    test('should return null when data is not found', () async {
      when(mockDatabaseHelper.getTvById(tId)).thenAnswer((_) async => null);

      final result = await dataSource.getTvById(tId);
      expect(result, null);
    });
  });

  group('Get Watchlist TV', () {
    test('should return list of TV Table from database', () async {
      when(
        mockDatabaseHelper.getWatchlistTvs(),
      ).thenAnswer((_) async => [testTvMap]);

      final result = await dataSource.getWatchlistTvs();
      expect(result, [testTvTable]);
    });
  });
}
