import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/domain/usecases/get_tv_recommendations.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late GetTVRecommendations usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = GetTVRecommendations(mockTVRepository);
  });

  final tId = 1;
  final tTvShows = <TV>[];

  test('should get list of tv recommendations from the repository', () async {
    when(
      mockTVRepository.getTvRecommendations(tId),
    ).thenAnswer((_) async => Right(tTvShows));

    final result = await usecase.execute(tId);
    verify(mockTVRepository.getTvRecommendations(tId));
    expect(result, Right(tTvShows));
  });
}
