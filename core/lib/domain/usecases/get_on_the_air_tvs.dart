import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetOnTheAirTVs {
  final TVRepository repository;

  GetOnTheAirTVs(this.repository);

  Future<Either<Failure, List<TV>>> execute() {
    return repository.getOnTheAirTvs();
  }
}
