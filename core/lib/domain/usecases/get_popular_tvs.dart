import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetPopularTVs {
  final TVRepository repository;

  GetPopularTVs(this.repository);

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getPopularTvs();
  }
}
