import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTVRecommendations usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetTVRecommendations(mockTvRepository);
  });

  final tId = 1;
  final tTvShows = <TV>[];

  test('should get list of tv recommendations from the repository', () async {
    when(
      mockTvRepository.getTvRecommendations(tId),
    ).thenAnswer((_) async => Right(tTvShows));

    final result = await usecase.execute(tId);
    verify(mockTvRepository.getTvRecommendations(tId));
    expect(result, Right(tTvShows));
  });
}
