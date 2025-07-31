import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/blocs/popular_tvs/popular_tvs_bloc.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late PopularTVsBloc bloc;
  late MockGetPopularTVs mockGetPopularTVs;

  setUp(() {
    mockGetPopularTVs = MockGetPopularTVs();
    bloc = PopularTVsBloc(getPopularTvs: mockGetPopularTVs);
  });

  test('initial state should be empty', () {
    expect(bloc.state, PopularTVsEmpty());
  });

  blocTest<PopularTVsBloc, PopularTVsState>(
    'should emit [Loading, Loaded] when fetching data is success',
    build: () {
      when(
        mockGetPopularTVs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTVs()),
    expect: () => [PopularTVsLoading(), PopularTVsLoaded(testTvList)],
    verify: (_) {
      verify(mockGetPopularTVs.execute());
    },
  );

  blocTest<PopularTVsBloc, PopularTVsState>(
    'should emit [Loading, Error] when fetching data is unsuccessful',
    build: () {
      when(
        mockGetPopularTVs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchPopularTVs()),
    expect: () => [
      PopularTVsLoading(),
      const PopularTVsError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetPopularTVs.execute());
    },
  );
}
