import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_airing_today_tvs.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:flutter/material.dart';

class TvListNotifier extends ChangeNotifier {
  var _airingTodayTvs = <Tv>[];

  List<Tv> get airingTodayTvs => _airingTodayTvs;

  RequestState _airingTodayState = RequestState.Empty;

  RequestState get airingTodayState => _airingTodayState;

  var _onTheAirTvs = <Tv>[];

  List<Tv> get onTheAirTvs => _onTheAirTvs;

  RequestState _onTheAirState = RequestState.Empty;

  RequestState get onTheAirState => _onTheAirState;

  var _popularTvs = <Tv>[];

  List<Tv> get popularTvs => _popularTvs;

  RequestState _popularTvState = RequestState.Empty;

  RequestState get popularTvState => _popularTvState;

  var _topRatedTvs = <Tv>[];

  List<Tv> get topRatedTvs => _topRatedTvs;

  RequestState _topRatedTvState = RequestState.Empty;

  RequestState get topRatedTvState => _topRatedTvState;

  String _message = '';

  String get message => _message;

  TvListNotifier({
    required this.getAiringTodayTvs,
    required this.getOnTheAirTvs,
    required this.getPopularTvs,
    required this.getTopRatedTvs,
  });

  final GetAiringTodayTvs getAiringTodayTvs;
  final GetOnTheAirTvs getOnTheAirTvs;
  final GetPopularTvs getPopularTvs;
  final GetTopRatedTvs getTopRatedTvs;

  Future<void> fetchAiringTodayTvs() async {
    _airingTodayState = RequestState.Loading;
    notifyListeners();

    final result = await getAiringTodayTvs.execute();
    result.fold(
      (failure) {
        _airingTodayState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _airingTodayState = RequestState.Loaded;
        _airingTodayTvs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchOnTheAirTvs() async {
    _onTheAirState = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirTvs.execute();
    result.fold(
      (failure) {
        _onTheAirState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _onTheAirState = RequestState.Loaded;
        _onTheAirTvs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchPopularTvs() async {
    _popularTvState = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvs.execute();
    result.fold(
      (failure) {
        _popularTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _popularTvState = RequestState.Loaded;
        _popularTvs = tvsData;
        notifyListeners();
      },
    );
  }

  Future<void> fetchTopRatedTvs() async {
    _topRatedTvState = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvs.execute();
    result.fold(
      (failure) {
        _topRatedTvState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _topRatedTvState = RequestState.Loaded;
        _topRatedTvs = tvsData;
        notifyListeners();
      },
    );
  }
}
