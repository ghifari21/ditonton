import 'package:dartz/dartz.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/utils/failure.dart';

class SearchTVs {
  final TVRepository repository;

  SearchTVs(this.repository);

  Future<Either<Failure, List<TV>>> execute(String query) {
    return repository.searchTvs(query);
  }
}
