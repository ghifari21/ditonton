import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/blocs/airing_today_tvs/airing_today_tvs_bloc.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late AiringTodayTVsBloc bloc;
  late MockGetAiringTodayTVs mockGetAiringTodayTVs;

  setUp(() {
    mockGetAiringTodayTVs = MockGetAiringTodayTVs();
    bloc = AiringTodayTVsBloc(getAiringTodayTvs: mockGetAiringTodayTVs);
  });

  test('initial state should be empty', () {
    expect(bloc.state, AiringTodayTVsEmpty());
  });

  blocTest<AiringTodayTVsBloc, AiringTodayTVsState>(
    'should emit [Loading, Loaded] when fetching data is success',
    build: () {
      when(
        mockGetAiringTodayTVs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTVs()),
    expect: () => [AiringTodayTVsLoading(), AiringTodayTVsLoaded(testTvList)],
    verify: (_) {
      verify(mockGetAiringTodayTVs.execute());
    },
  );

  blocTest<AiringTodayTVsBloc, AiringTodayTVsState>(
    'should emit [Loading, Error] when fetching data is unsuccessful',
    build: () {
      when(
        mockGetAiringTodayTVs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchAiringTodayTVs()),
    expect: () => [
      AiringTodayTVsLoading(),
      const AiringTodayTVsError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetAiringTodayTVs.execute());
    },
  );
}
