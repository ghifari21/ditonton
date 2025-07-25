import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTvWatchlistStatus {
  final TvRepository _repository;

  GetTvWatchlistStatus(this._repository);

  Future<bool> execute(int id) {
    return _repository.isAddedToWatchlist(id);
  }
}
