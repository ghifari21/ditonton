import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_on_the_air_tvs.dart';
import 'package:flutter/material.dart';

class OnTheAirTvsNotifier extends ChangeNotifier {
  final GetOnTheAirTvs getOnTheAirTvs;

  OnTheAirTvsNotifier({required this.getOnTheAirTvs});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tv> _tvs = [];

  List<Tv> get tvs => _tvs;

  String _message = '';

  String get message => _message;

  Future<void> fetchOnTheAirTvs() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getOnTheAirTvs.execute();
    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _state = RequestState.Loaded;
        _tvs = tvsData;
        notifyListeners();
      },
    );
  }
}
