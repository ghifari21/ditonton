import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/blocs/top_rated_tvs/top_rated_tvs_bloc.dart';
import 'package:tv/presentation/pages/top_rated_tvs_page.dart';

class MockTopRatedTVsBloc extends MockBloc<TopRatedTVsEvent, TopRatedTVsState>
    implements TopRatedTVsBloc {}

class FakeTopRatedTVsEvent extends Fake implements TopRatedTVsEvent {}

class FakeTopRatedTVsState extends Fake implements TopRatedTVsState {}

void main() {
  late MockTopRatedTVsBloc mockTopRatedTVsBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedTVsEvent());
    registerFallbackValue(FakeTopRatedTVsState());
  });

  setUp(() {
    mockTopRatedTVsBloc = MockTopRatedTVsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTVsBloc>.value(
      value: mockTopRatedTVsBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockTopRatedTVsBloc.state).thenReturn(TopRatedTVsLoading());
    whenListen(
      mockTopRatedTVsBloc,
      Stream.value(TopRatedTVsLoading()),
      initialState: TopRatedTVsLoading(),
    );

    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));

    final centerFinder = find.byType(Center);
    final progressBarFinder = find.byType(CircularProgressIndicator);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    final state = TopRatedTVsLoaded(<TV>[]);
    when(() => mockTopRatedTVsBloc.state).thenReturn(state);
    whenListen(mockTopRatedTVsBloc, Stream.value(state), initialState: state);

    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display error message when error occurs', (
    WidgetTester tester,
  ) async {
    final state = TopRatedTVsError('Error message');
    when(() => mockTopRatedTVsBloc.state).thenReturn(state);
    whenListen(mockTopRatedTVsBloc, Stream.value(state), initialState: state);

    await tester.pumpWidget(makeTestableWidget(TopRatedTVsPage()));

    final errorMessageFinder = find.text('Error message');
    expect(errorMessageFinder, findsOneWidget);
  });
}
