import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_watchlist_status.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetTVWatchlistStatus usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVWatchlistStatus(mockTVRepository);
  });

  test('should get tv watchlist status from repository', () async {
    when(mockTVRepository.isAddedToWatchlist(1)).thenAnswer((_) async => true);

    final result = await usecase.execute(1);
    verify(mockTVRepository.isAddedToWatchlist(1));
    expect(result, true);
  });
}
