import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/remove_tv_watchlist.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late RemoveTVWatchlist usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = RemoveTVWatchlist(mockTVRepository);
  });

  test('should remove watchlist TV show from repository', () async {
    when(
      mockTVRepository.removeWatchlist(testTvDetail),
    ).thenAnswer((_) async => Right('Removed from watchlist'));

    final result = await usecase.execute(testTvDetail);

    verify(mockTVRepository.removeWatchlist(testTvDetail));
    expect(result, Right('Removed from watchlist'));
  });
}
