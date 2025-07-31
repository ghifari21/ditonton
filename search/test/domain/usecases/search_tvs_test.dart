import 'package:core/domain/entities/tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tvs.dart';

import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late SearchTVs usecase;
  late MockTVRepository mockTVRepository;

  setUp(() {
    mockTVRepository = MockTVRepository();
    usecase = SearchTVs(mockTVRepository);
  });

  final tTVs = <TV>[];
  final tQuery = 'the fragrant flower';

  test('should get list of TV shows from the repository', () async {
    when(
      mockTVRepository.searchTvs(tQuery),
    ).thenAnswer((_) async => Right(tTVs));

    final result = await usecase.execute(tQuery);

    verify(mockTVRepository.searchTvs(tQuery));
    expect(result, Right(tTVs));
  });
}
