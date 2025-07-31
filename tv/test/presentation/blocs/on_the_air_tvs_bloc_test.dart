import 'package:bloc_test/bloc_test.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv/presentation/blocs/on_the_air_tvs/on_the_air_tvs_bloc.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';
import '../../../../core/test/helpers/test_helper.mocks.dart';

void main() {
  late OnTheAirTVsBloc bloc;
  late MockGetOnTheAirTVs mockGetOnTheAirTVs;

  setUp(() {
    mockGetOnTheAirTVs = MockGetOnTheAirTVs();
    bloc = OnTheAirTVsBloc(getOnTheAirTvs: mockGetOnTheAirTVs);
  });

  test('initial state should be empty', () {
    expect(bloc.state, OnTheAirTVsEmpty());
  });

  blocTest<OnTheAirTVsBloc, OnTheAirTVsState>(
    'should emit [Loading, Loaded] when fetching data is success',
    build: () {
      when(
        mockGetOnTheAirTVs.execute(),
      ).thenAnswer((_) async => Right(testTvList));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTVs()),
    expect: () => [OnTheAirTVsLoading(), OnTheAirTVsLoaded(testTvList)],
    verify: (_) {
      verify(mockGetOnTheAirTVs.execute());
    },
  );

  blocTest<OnTheAirTVsBloc, OnTheAirTVsState>(
    'should emit [Loading, Error] when fetching data is unsuccessful',
    build: () {
      when(
        mockGetOnTheAirTVs.execute(),
      ).thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return bloc;
    },
    act: (bloc) => bloc.add(FetchOnTheAirTVs()),
    expect: () => [
      OnTheAirTVsLoading(),
      const OnTheAirTVsError('Server Failure'),
    ],
    verify: (_) {
      verify(mockGetOnTheAirTVs.execute());
    },
  );
}
