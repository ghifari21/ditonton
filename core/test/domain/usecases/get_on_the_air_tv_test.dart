import 'package:core/domain/usecases/get_on_the_air_tvs.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetOnTheAirTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetOnTheAirTVs(mockTVRepository);
  });

  test('should get on the air TV list from the repository', () async {
    when(
      mockTVRepository.getOnTheAirTvs(),
    ).thenAnswer((_) async => Right(testTvList));

    final result = await usecase.execute();
    verify(mockTVRepository.getOnTheAirTvs());
    expect(result, Right(testTvList));
  });
}
