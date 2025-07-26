import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVDetail usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTVDetail(mockTvRepository);
  });

  final tId = 1;

  test('should get TV detail from the repository', () async {
    when(
      mockTvRepository.getTvDetail(tId),
    ).thenAnswer((_) async => Right(testTvDetail));

    final result = await usecase.execute(tId);
    verify(mockTvRepository.getTvDetail(tId));
    expect(result, Right(testTvDetail));
  });
}
