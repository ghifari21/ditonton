import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/presentation/bloc/search_event.dart';
import 'package:search/presentation/bloc/search_state.dart';
import 'package:search/presentation/pages/search_page.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class FakeSearchEvent extends Fake implements SearchEvent {}

class FakeSearchState extends Fake implements SearchState {}

void main() {
  late MockSearchBloc mockSearchBloc;

  setUpAll(() {
    registerFallbackValue(FakeSearchEvent());
    registerFallbackValue(FakeSearchState());
  });

  setUp(() {
    mockSearchBloc = MockSearchBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<SearchBloc>.value(
      value: mockSearchBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    final initialState = SearchLoading();
    when(() => mockSearchBloc.state).thenReturn(initialState);
    whenListen(
      mockSearchBloc,
      Stream.value(initialState),
      initialState: initialState,
    );

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    final state = SearchLoaded(testMovieList, testTvList);
    when(() => mockSearchBloc.state).thenReturn(state);
    whenListen(mockSearchBloc, Stream.value(state), initialState: state);

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    final movieListViewFinder = find.byType(ListView);
    expect(movieListViewFinder, findsOneWidget);
    expect(find.byType(MovieCard), findsOneWidget);

    await tester.tap(find.text('TV Series'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final tvListViewFinder = find.byType(ListView);
    expect(tvListViewFinder, findsOneWidget);
    expect(find.byType(TvCard), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    const errorMessage = 'Failed to fetch data';
    final state = SearchError(errorMessage);
    when(() => mockSearchBloc.state).thenReturn(state);
    whenListen(mockSearchBloc, Stream.value(state), initialState: state);

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    expect(find.text(errorMessage), findsOneWidget);
  });

  testWidgets('Page should trigger search event when text is entered', (
    WidgetTester tester,
  ) async {
    final state = SearchEmpty();
    when(() => mockSearchBloc.state).thenReturn(state);
    whenListen(mockSearchBloc, Stream.value(state), initialState: state);

    await tester.pumpWidget(makeTestableWidget(const SearchPage()));

    await tester.enterText(find.byType(TextField), 'spiderman');

    await tester.pump(const Duration(milliseconds: 500));

    verify(
      () => mockSearchBloc.add(const OnQueryChanged('spiderman')),
    ).called(1);
  });
}
