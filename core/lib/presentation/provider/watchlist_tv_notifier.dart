import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_watchlist_tvs.dart';
import 'package:core/utils/state_enum.dart';
import 'package:flutter/material.dart';

class WatchlistTvNotifier extends ChangeNotifier {
  final GetWatchlistTVs getWatchlistTvs;

  WatchlistTvNotifier({required this.getWatchlistTvs});

  var _watchlistTvs = <TV>[];

  List<TV> get watchlistTvs => _watchlistTvs;

  RequestState _watchlistState = RequestState.Empty;

  RequestState get watchlistState => _watchlistState;

  String _message = '';

  String get message => _message;

  Future<void> fetchWatchlistTvs() async {
    _watchlistState = RequestState.Loading;
    notifyListeners();

    final result = await getWatchlistTvs.execute();
    result.fold(
      (failure) {
        _watchlistState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (tvsData) {
        _watchlistState = RequestState.Loaded;
        _watchlistTvs = tvsData;
        notifyListeners();
      },
    );
  }
}
