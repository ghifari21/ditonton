import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_top_rated_tvs.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

class TopRatedTvsNotifier extends ChangeNotifier {
  final GetTopRatedTVs getTopRatedTvs;

  TopRatedTvsNotifier({required this.getTopRatedTvs});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<TV> _topRatedTvs = [];

  List<TV> get tvs => _topRatedTvs;

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
