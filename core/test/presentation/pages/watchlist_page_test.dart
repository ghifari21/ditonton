import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/blocs/watchlist/watchlist_bloc.dart';
import 'package:core/presentation/pages/watchlist_page.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockWatchlistBloc extends MockBloc<WatchlistEvent, WatchlistState>
    implements WatchlistBloc {}

class FakeWatchlistEvent extends Fake implements WatchlistEvent {}

class FakeWatchlistState extends Fake implements WatchlistState {}

void main() {
  late MockWatchlistBloc mockWatchlistBloc;

  setUpAll(() {
    registerFallbackValue(FakeWatchlistEvent());
    registerFallbackValue(FakeWatchlistState());
  });

  setUp(() {
    mockWatchlistBloc = MockWatchlistBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistBloc>.value(
      value: mockWatchlistBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    final initialState = WatchlistLoading();
    when(() => mockWatchlistBloc.state).thenReturn(initialState);

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    expect(progressBarFinder, findsOneWidget);

    await tester.tap(find.text('TV Series'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display list views when data is loaded', (
    WidgetTester tester,
  ) async {
    final state = WatchlistLoaded(testMovieList, testTvList);
    when(() => mockWatchlistBloc.state).thenReturn(state);

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

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

  testWidgets('Page should display empty message when data is empty', (
    WidgetTester tester,
  ) async {
    final state = WatchlistLoaded([], []);
    when(() => mockWatchlistBloc.state).thenReturn(state);

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    expect(find.text('No movies in watchlist.'), findsOneWidget);

    await tester.tap(find.text('TV Series'));
    await tester.pumpAndSettle();

    expect(find.text('No TV series in watchlist.'), findsOneWidget);
  });

  testWidgets('Page should display error message when data fails to load', (
    WidgetTester tester,
  ) async {
    const errorMessage = 'Failed to load watchlist';
    final state = WatchlistError(errorMessage);
    when(() => mockWatchlistBloc.state).thenReturn(state);

    await tester.pumpWidget(makeTestableWidget(const WatchlistPage()));

    expect(find.byKey(const Key('movies_error_message')), findsOneWidget);

    await tester.tap(find.text('TV Series'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(const Key('tvs_error_message')), findsOneWidget);
  });
}
