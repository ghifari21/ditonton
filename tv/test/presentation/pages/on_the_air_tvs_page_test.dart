import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/blocs/on_the_air_tvs/on_the_air_tvs_bloc.dart';
import 'package:tv/presentation/pages/on_the_air_tvs_page.dart';

class MockOnTheAirTVsBloc extends MockBloc<OnTheAirTVsEvent, OnTheAirTVsState>
    implements OnTheAirTVsBloc {}

class FakeOnTheAirTVsEvent extends Fake implements OnTheAirTVsEvent {}

class FakeOnTheAirTVsState extends Fake implements OnTheAirTVsState {}

void main() {
  late MockOnTheAirTVsBloc mockOnTheAirTVsBloc;

  setUpAll(() {
    registerFallbackValue(FakeOnTheAirTVsEvent());
    registerFallbackValue(FakeOnTheAirTVsState());
  });

  setUp(() {
    mockOnTheAirTVsBloc = MockOnTheAirTVsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<OnTheAirTVsBloc>.value(
      value: mockOnTheAirTVsBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockOnTheAirTVsBloc.state).thenReturn(OnTheAirTVsLoading());
    whenListen(
      mockOnTheAirTVsBloc,
      Stream.value(OnTheAirTVsLoading()),
      initialState: OnTheAirTVsLoading(),
    );

    await tester.pumpWidget(makeTestableWidget(OnTheAirTVsPage()));

    final centerFinder = find.byType(Center);
    final progressBarFinder = find.byType(CircularProgressIndicator);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    final state = OnTheAirTVsLoaded(<TV>[]);
    when(() => mockOnTheAirTVsBloc.state).thenReturn(state);
    whenListen(mockOnTheAirTVsBloc, Stream.value(state), initialState: state);

    await tester.pumpWidget(makeTestableWidget(OnTheAirTVsPage()));

    final listViewFinder = find.byType(ListView);

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display error message when error occurs', (
    WidgetTester tester,
  ) async {
    final state = OnTheAirTVsError('Error message');
    when(() => mockOnTheAirTVsBloc.state).thenReturn(state);
    whenListen(mockOnTheAirTVsBloc, Stream.value(state), initialState: state);

    await tester.pumpWidget(makeTestableWidget(OnTheAirTVsPage()));

    final textFinder = find.text('Error message');

    expect(textFinder, findsOneWidget);
  });
}
