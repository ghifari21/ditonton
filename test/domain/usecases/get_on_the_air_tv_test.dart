import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnTheAirTvs usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetOnTheAirTvs(mockTvRepository);
  });

  test('should get on the air TV list from the repository', () async {
    when(
      mockTvRepository.getOnTheAirTvs(),
    ).thenAnswer((_) async => Right(testTvList));

    final result = await usecase.execute();
    verify(mockTvRepository.getOnTheAirTvs());
    expect(result, Right(testTvList));
  });
}
