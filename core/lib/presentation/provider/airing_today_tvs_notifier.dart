import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_airing_today_tvs.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

class AiringTodayTvsNotifier extends ChangeNotifier {
  final GetAiringTodayTVs getAiringTodayTvs;

  AiringTodayTvsNotifier({required this.getAiringTodayTvs});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<TV> _tvs = [];

  List<TV> get tvs => _tvs;

  String _message = '';

  String get message => _message;

  Future<void> fetchAiringTodayTvs() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getAiringTodayTvs.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
        notifyListeners();
      },
      (tvsData) {
        _tvs = tvsData;
        _state = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
