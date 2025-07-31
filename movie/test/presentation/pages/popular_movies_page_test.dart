import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/blocs/popular_movies/popular_movies_bloc.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';

class MockPopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

class FakePopularMoviesEvent extends Fake implements PopularMoviesEvent {}

class FakePopularMoviesState extends Fake implements PopularMoviesState {}

void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularMoviesEvent());
    registerFallbackValue(FakePopularMoviesState());
  });

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockPopularMoviesBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockPopularMoviesBloc.state).thenReturn(PopularMoviesLoading());
    whenListen(
      mockPopularMoviesBloc,
      Stream.value(PopularMoviesLoading()),
      initialState: PopularMoviesLoading(),
    );

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    final centerFinder = find.byType(Center);
    final progressBarFinder = find.byType(CircularProgressIndicator);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    final state = PopularMoviesLoaded(<Movie>[]);

    when(() => mockPopularMoviesBloc.state).thenReturn(state);
    whenListen(mockPopularMoviesBloc, Stream.value(state), initialState: state);

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    final state = PopularMoviesError('Error message');

    when(() => mockPopularMoviesBloc.state).thenReturn(state);
    whenListen(mockPopularMoviesBloc, Stream.value(state), initialState: state);

    await tester.pumpWidget(makeTestableWidget(PopularMoviesPage()));

    final textFinder = find.byKey(Key('error_message'));

    expect(textFinder, findsOneWidget);
  });
}
