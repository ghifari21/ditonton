import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tvs.dart';
import 'package:flutter/material.dart';

class PopularTvsNotifier extends ChangeNotifier {
  final GetPopularTvs getPopularTvs;

  PopularTvsNotifier({required this.getPopularTvs});

  RequestState _state = RequestState.Empty;

  RequestState get state => _state;

  List<Tv> _popularTvs = [];

  List<Tv> get tvs => _popularTvs;

  String _message = '';

  String get message => _message;

  Future<void> fetchPopularTvs() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getPopularTvs.execute();

    result.fold(
      (failure) {
        _state = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _state = RequestState.Loaded;
        _popularTvs = tvsData;
        notifyListeners();
      },
    );
  }
}
