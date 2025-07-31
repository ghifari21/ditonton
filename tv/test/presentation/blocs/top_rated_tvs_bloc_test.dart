import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/blocs/top_rated_tvs/top_rated_tvs_bloc.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late TopRatedTVsBloc bloc;
  late MockGetTopRatedTVs mockGetTopRatedTVs;

  setUp(() {
    mockGetTopRatedTVs = MockGetTopRatedTVs();
    bloc = TopRatedTVsBloc(getTopRatedTvs: mockGetTopRatedTVs);
  });

  test('initial state should be empty', () {
    expect(bloc.state, TopRatedTVsEmpty());
  });

  blocTest<TopRatedTVsBloc, TopRatedTVsState>(
    'should emit [Loading, Loaded] when fetching data is success',
    build: () {
      when(
        mockGetTopRatedTVs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTVs()),
    expect: () => [TopRatedTVsLoading(), TopRatedTVsLoaded(testTvList)],
    verify: (_) {
      verify(mockGetTopRatedTVs.execute());
    },
  );

  blocTest<TopRatedTVsBloc, TopRatedTVsState>(
    'should emit [Loading, Error] when fetching data is unsuccessful',
    build: () {
      when(
        mockGetTopRatedTVs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTVs()),
    expect: () => [
      TopRatedTVsLoading(),
      const TopRatedTVsError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetTopRatedTVs.execute());
    },
  );
}
