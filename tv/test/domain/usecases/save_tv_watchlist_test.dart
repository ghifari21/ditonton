import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/save_tv_watchlist.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late SaveTVWatchlist usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SaveTVWatchlist(mockTVRepository);
  });

  test('should save TV show to the repository', () async {
    when(
      mockTVRepository.saveWatchlist(testTvDetail),
    ).thenAnswer((_) async => Right('Added to Watchlist'));

    final result = await usecase.execute(testTvDetail);

    verify(mockTVRepository.saveWatchlist(testTvDetail));
    expect(result, Right('Added to Watchlist'));
  });
}
