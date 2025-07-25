import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tvs.dart';
import 'package:flutter/material.dart';

class TopRatedTvsNotifier extends ChangeNotifier {
  final GetTopRatedTvs getTopRatedTvs;

  TopRatedTvsNotifier({required this.getTopRatedTvs});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tv> _topRatedTvs = [];

  List<Tv> get tvs => _topRatedTvs;

  String _message = '';

  String get message => _message;

  Future<void> fetchTopRatedTvs() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTopRatedTvs.execute();

    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _state = RequestState.Loaded;
        _topRatedTvs = tvsData;
        notifyListeners();
      },
    );
  }
}
