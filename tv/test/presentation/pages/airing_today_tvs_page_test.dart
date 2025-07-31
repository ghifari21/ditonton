import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/blocs/airing_today_tvs/airing_today_tvs_bloc.dart';
import 'package:tv/presentation/pages/airing_today_tvs_page.dart';

class MockAiringTodayTVsBloc
    extends MockBloc<AiringTodayTVsEvent, AiringTodayTVsState>
    implements AiringTodayTVsBloc {}

class FakeAiringTodayTVsEvent extends Fake implements AiringTodayTVsEvent {}

class FakeAiringTodayTVsState extends Fake implements AiringTodayTVsState {}

void main() {
  late MockAiringTodayTVsBloc mockAiringTodayTVsBloc;

  setUpAll(() {
    registerFallbackValue(FakeAiringTodayTVsEvent());
    registerFallbackValue(FakeAiringTodayTVsState());
  });

  setUp(() {
    mockAiringTodayTVsBloc = MockAiringTodayTVsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<AiringTodayTVsBloc>.value(
      value: mockAiringTodayTVsBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(
      () => mockAiringTodayTVsBloc.state,
    ).thenReturn(AiringTodayTVsLoading());
    whenListen(
      mockAiringTodayTVsBloc,
      Stream.value(AiringTodayTVsLoading()),
      initialState: AiringTodayTVsLoading(),
    );

    await tester.pumpWidget(makeTestableWidget(AiringTodayTVsPage()));

    final centerFinder = find.byType(Center);
    final progressBarFinder = find.byType(CircularProgressIndicator);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    final state = AiringTodayTVsLoaded(<TV>[]);

    when(() => mockAiringTodayTVsBloc.state).thenReturn(state);
    whenListen(
      mockAiringTodayTVsBloc,
      Stream.value(state),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(AiringTodayTVsPage()));

    final listViewFinder = find.byType(ListView);

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display error message when error occurs', (
    WidgetTester tester,
  ) async {
    final state = AiringTodayTVsError('Error message');

    when(() => mockAiringTodayTVsBloc.state).thenReturn(state);
    whenListen(
      mockAiringTodayTVsBloc,
      Stream.value(state),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(AiringTodayTVsPage()));

    final errorMessageFinder = find.text('Error message');

    expect(errorMessageFinder, findsOneWidget);
  });
}
