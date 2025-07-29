import 'package:core/domain/usecases/get_airing_today_tvs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetAiringTodayTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetAiringTodayTVs(mockTVRepository);
  });

  test('should get list of airing today tvs from the repository', () async {
    when(
      mockTVRepository.getAiringTodayTvs(),
    ).thenAnswer((_) async => Right(testTvList));

    final result = await usecase.execute();
    verify(mockTVRepository.getAiringTodayTvs());
    expect(result, Right(testTvList));
  });
}
