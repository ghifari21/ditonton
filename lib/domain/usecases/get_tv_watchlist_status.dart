import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTVWatchlistStatus {
  final TVRepository _repository;

  GetTVWatchlistStatus(this._repository);

  Future<bool> execute(int id) {
    return _repository.isAddedToWatchlist(id);
  }
}
