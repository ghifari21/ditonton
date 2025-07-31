import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/blocs/tv_detail/tv_detail_bloc.dart';
import 'package:tv/presentation/pages/tv_detail_page.dart';

import '../../../../core/test/dummy_data/dummy_objects.dart';

class MockTVDetailBloc extends MockBloc<TVDetailEvent, TVDetailState>
    implements TVDetailBloc {}

class FakeTVDetailEvent extends Fake implements TVDetailEvent {}

class FakeTVDetailState extends Fake implements TVDetailState {}

void main() {
  late MockTVDetailBloc mockTVDetailBloc;

  setUpAll(() {
    registerFallbackValue(FakeTVDetailEvent());
    registerFallbackValue(FakeTVDetailState());
  });

  setUp(() {
    mockTVDetailBloc = MockTVDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TVDetailBloc>.value(
      value: mockTVDetailBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
    'Watchlist button should display add icon when TV show not added to watchlist',
    (WidgetTester tester) async {
      final state = TVDetailLoaded(
        tv: testTvDetail,
        tvRecommendations: <TV>[],
        isAddedToWatchlist: false,
      );

      when(() => mockTVDetailBloc.state).thenReturn(state);
      whenListen(mockTVDetailBloc, Stream.value(state), initialState: state);

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

      final watchlistButtonIcon = find.byIcon(Icons.add);
      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when TV show is added to watchlist',
    (WidgetTester tester) async {
      final state = TVDetailLoaded(
        tv: testTvDetail,
        tvRecommendations: <TV>[],
        isAddedToWatchlist: true,
      );

      when(() => mockTVDetailBloc.state).thenReturn(state);
      whenListen(mockTVDetailBloc, Stream.value(state), initialState: state);

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));

      final watchlistButtonIcon = find.byIcon(Icons.check);
      expect(watchlistButtonIcon, findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      final initialState = TVDetailLoaded(
        tv: testTvDetail,
        tvRecommendations: <TV>[],
        isAddedToWatchlist: false,
      );
      final finalState = initialState.copyWith(
        isAddedToWatchlist: true,
        watchlistMessage: 'Added to Watchlist',
      );

      when(() => mockTVDetailBloc.state).thenReturn(initialState);
      whenListen(
        mockTVDetailBloc,
        Stream.fromIterable([initialState, finalState]),
        initialState: initialState,
      );

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
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
      final initialState = TVDetailLoaded(
        tv: testTvDetail,
        tvRecommendations: <TV>[],
        isAddedToWatchlist: false,
      );
      final finalState = initialState.copyWith(watchlistMessage: 'Failed');

      when(() => mockTVDetailBloc.state).thenReturn(initialState);
      whenListen(
        mockTVDetailBloc,
        Stream.fromIterable([initialState, finalState]),
        initialState: initialState,
      );

      await tester.pumpWidget(makeTestableWidget(TVDetailPage(id: 1)));
      expect(find.byIcon(Icons.add), findsOneWidget);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}
