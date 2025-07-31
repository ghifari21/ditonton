import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_detail.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetTVDetail usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVDetail(mockTVRepository);
  });

  final tId = 1;

  test('should get TV detail from the repository', () async {
    when(
      mockTVRepository.getTvDetail(tId),
    ).thenAnswer((_) async => Right(testTvDetail));

    final result = await usecase.execute(tId);
    verify(mockTVRepository.getTvDetail(tId));
    expect(result, Right(testTvDetail));
  });
}
