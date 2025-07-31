import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/blocs/movie_detail/movie_detail_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

class FakeMovieDetailEvent extends Fake implements MovieDetailEvent {}

class FakeMovieDetailState extends Fake implements MovieDetailState {}

void main() {
  late MockMovieDetailBloc mockMovieDetailBloc;

  setUpAll(() {
    registerFallbackValue(FakeMovieDetailEvent());
    registerFallbackValue(FakeMovieDetailState());
  });

  setUp(() {
    mockMovieDetailBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockMovieDetailBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when movie not added to watchlist',
    (WidgetTester tester) async {
      final state = MovieDetailLoaded(
        movie: testMovieDetail,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      );

      when(() => mockMovieDetailBloc.state).thenReturn(state);
      whenListen(mockMovieDetailBloc, Stream.value(state), initialState: state);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      final watchlistButtonIcon = find.byIcon(Icons.add);
      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when movie is added to watchlist',
    (WidgetTester tester) async {
      final state = MovieDetailLoaded(
        movie: testMovieDetail,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: true,
      );
      when(() => mockMovieDetailBloc.state).thenReturn(state);
      whenListen(mockMovieDetailBloc, Stream.value(state), initialState: state);

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));

      final watchlistButtonIcon = find.byIcon(Icons.check);

      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      final initialState = MovieDetailLoaded(
        movie: testMovieDetail,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      );
      final finalState = initialState.copyWith(
        isAddedToWatchlist: true,
        watchlistMessage: 'Added to Watchlist',
      );

      when(() => mockMovieDetailBloc.state).thenReturn(initialState);
      whenListen(
        mockMovieDetailBloc,
        Stream.fromIterable([initialState, finalState]),
        initialState: initialState,
      );

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Added to Watchlist'), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      final initialState = MovieDetailLoaded(
        movie: testMovieDetail,
        movieRecommendations: <Movie>[],
        isAddedToWatchlist: false,
      );
      final finalState = initialState.copyWith(watchlistMessage: 'Failed');

      when(() => mockMovieDetailBloc.state).thenReturn(initialState);
      whenListen(
        mockMovieDetailBloc,
        Stream.fromIterable([initialState, finalState]),
        initialState: initialState,
      );

      await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}
