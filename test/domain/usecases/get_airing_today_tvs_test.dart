import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetAiringTodayTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetAiringTodayTvs(mockTvRepository);
  });

  test('should get list of airing today tvs from the repository', () async {
    when(
      mockTvRepository.getAiringTodayTvs(),
    ).thenAnswer((_) async => Right(testTvList));

    final result = await usecase.execute();
    verify(mockTvRepository.getAiringTodayTvs());
    expect(result, Right(testTvList));
  });
}
