import 'package:core/domain/usecases/get_popular_tvs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetPopularTVs(mockTVRepository);
  });

  test('should get popular TV list from repository', () async {
    when(
      mockTVRepository.getPopularTvs(),
    ).thenAnswer((_) async => Right(testTvList));

    final result = await usecase.execute();
    verify(mockTVRepository.getPopularTvs());
    expect(result, Right(testTvList));
  });
}
