import 'package:bloc_test/bloc_test.dart';
import 'package:core/presentation/blocs/home_page_bloc/home_page_bloc.dart';
import 'package:core/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockHomePageBloc extends MockBloc<HomePageEvent, HomePageState>
    implements HomePageBloc {}

class FakeHomePageEvent extends Fake implements HomePageEvent {}

class FakeHomePageState extends Fake implements HomePageState {}

void main() {
  late MockHomePageBloc mockHomePageBloc;

  setUpAll(() {
    registerFallbackValue(FakeHomePageEvent());
    registerFallbackValue(FakeHomePageState());
  });

  setUp(() {
    mockHomePageBloc = MockHomePageBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<HomePageBloc>.value(
      value: mockHomePageBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    final initialState = HomePageLoading();
    when(() => mockHomePageBloc.state).thenReturn(initialState);

    await tester.pumpWidget(makeTestableWidget(const HomePage()));

    final progressBarFinder = find.byType(CircularProgressIndicator);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display all list views when data is loaded', (
    WidgetTester tester,
  ) async {
    final state = HomePageLoaded(
      nowPlayingMovies: testMovieList,
      popularMovies: testMovieList,
      topRatedMovies: testMovieList,
      airingTodayTvs: testTvList,
      onTheAirTvs: testTvList,
      popularTvs: testTvList,
      topRatedTvs: testTvList,
    );
    when(() => mockHomePageBloc.state).thenReturn(state);

    await tester.pumpWidget(makeTestableWidget(const HomePage()));

    final movieListFinder = find.byType(MovieList);
    final tvListFinder = find.byType(TVList);

    expect(movieListFinder, findsNWidgets(3));
    expect(tvListFinder, findsNWidgets(4));
  });

  testWidgets('Page should display error text when data failed to load', (
    WidgetTester tester,
  ) async {
    const errorMessage = 'Failed to load data';
    final state = HomePageError(errorMessage);
    when(() => mockHomePageBloc.state).thenReturn(state);

    await tester.pumpWidget(makeTestableWidget(const HomePage()));

    expect(find.text(errorMessage), findsOneWidget);
  });
}
