import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/blocs/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

class FakeTopRatedMoviesEvent extends Fake implements TopRatedMoviesEvent {}

class FakeTopRatedMoviesState extends Fake implements TopRatedMoviesState {}

void main() {
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUpAll(() {
    registerFallbackValue(FakeTopRatedMoviesEvent());
    registerFallbackValue(FakeTopRatedMoviesState());
  });

  setUp(() {
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockTopRatedMoviesBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading', (
    WidgetTester tester,
  ) async {
    final state = TopRatedMoviesLoading();
    when(() => mockTopRatedMoviesBloc.state).thenReturn(state);
    whenListen(
      mockTopRatedMoviesBloc,
      Stream.value(state),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(centerFinder, findsOneWidget);
    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded', (
    WidgetTester tester,
  ) async {
    final state = TopRatedMoviesLoaded(<Movie>[]);
    when(() => mockTopRatedMoviesBloc.state).thenReturn(state);
    whenListen(
      mockTopRatedMoviesBloc,
      Stream.value(state),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));

    final listViewFinder = find.byType(ListView);
    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error', (
    WidgetTester tester,
  ) async {
    final state = TopRatedMoviesError('Error message');
    when(() => mockTopRatedMoviesBloc.state).thenReturn(state);
    whenListen(
      mockTopRatedMoviesBloc,
      Stream.value(state),
      initialState: state,
    );

    await tester.pumpWidget(makeTestableWidget(TopRatedMoviesPage()));

    final textFinder = find.byKey(Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
