import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchlistTVs {
  final TVRepository _repository;

  GetWatchlistTVs(this._repository);

  Future<Either<Failure, List<TV>>> execute() {
    return _repository.getWatchlistTvs();
  }
}
