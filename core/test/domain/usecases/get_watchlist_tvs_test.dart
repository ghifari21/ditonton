import 'package:core/domain/usecases/get_watchlist_tvs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetWatchlistTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetWatchlistTVs(mockTVRepository);
  });

  test('should get list of TV Series from the repository', () async {
    when(
      mockTVRepository.getWatchlistTvs(),
    ).thenAnswer((_) async => Right(testTvList));

    final result = await usecase.execute();
    verify(mockTVRepository.getWatchlistTvs());
    expect(result, Right(testTvList));
  });
}
