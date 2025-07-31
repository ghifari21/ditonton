import 'package:bloc_test/bloc_test.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/presentation/blocs/popular_tvs/popular_tvs_bloc.dart';
import 'package:tv/presentation/pages/popular_tvs_page.dart';

class MockPopularTVsBloc extends MockBloc<PopularTVsEvent, PopularTVsState>
    implements PopularTVsBloc {}

class FakePopularTVsEvent extends Fake implements PopularTVsEvent {}

class FakePopularTVsState extends Fake implements PopularTVsState {}

void main() {
  late MockPopularTVsBloc mockPopularTVsBloc;

  setUpAll(() {
    registerFallbackValue(FakePopularTVsEvent());
    registerFallbackValue(FakePopularTVsState());
  });

  setUp(() {
    mockPopularTVsBloc = MockPopularTVsBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTVsBloc>.value(
      value: mockPopularTVsBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading', (
    WidgetTester tester,
  ) async {
    when(() => mockPopularTVsBloc.state).thenReturn(PopularTVsLoading());
    whenListen(
      mockPopularTVsBloc,
      Stream.value(PopularTVsLoading()),
      initialState: PopularTVsLoading(),
    );

    await tester.pumpWidget(makeTestableWidget(PopularTVsPage()));

    final centerFinder = find.byType(Center);
    final progressBarFinder = find.byType(CircularProgressIndicator);

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded', (
    WidgetTester tester,
  ) async {
    final state = PopularTVsLoaded(<TV>[]);
    when(() => mockPopularTVsBloc.state).thenReturn(state);
    whenListen(mockPopularTVsBloc, Stream.value(state), initialState: state);

    await tester.pumpWidget(makeTestableWidget(PopularTVsPage()));

    final listViewFinder = find.byType(ListView);

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display error message when error occurs', (
    WidgetTester tester,
  ) async {
    final state = PopularTVsError('Error message');
    when(() => mockPopularTVsBloc.state).thenReturn(state);
    whenListen(mockPopularTVsBloc, Stream.value(state), initialState: state);

    await tester.pumpWidget(makeTestableWidget(PopularTVsPage()));

    final errorMessageFinder = find.text('Error message');

    expect(errorMessageFinder, findsOneWidget);
  });
}
