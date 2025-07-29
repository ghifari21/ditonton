import 'package:core/domain/usecases/get_top_rated_tvs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTopRatedTVs(mockTVRepository);
  });

  test('should return top rated TV list from repository', () async {
    when(
      mockTVRepository.getTopRatedTvs(),
    ).thenAnswer((_) async => Right(testTvList));

    final result = await usecase.execute();
    verify(mockTVRepository.getTopRatedTvs());
    expect(result, Right(testTvList));
  });
}
