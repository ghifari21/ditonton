import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

abstract class TVRepository {
  Future<Either<Failure, List<TV>>> getAiringTodayTvs();

  Future<Either<Failure, List<TV>>> getOnTheAirTvs();

  Future<Either<Failure, List<TV>>> getPopularTvs();

  Future<Either<Failure, List<TV>>> getTopRatedTvs();

  Future<Either<Failure, TVDetail>> getTvDetail(int id);

  Future<Either<Failure, List<TV>>> getTvRecommendations(int id);

  Future<Either<Failure, List<TV>>> searchTvs(String query);

  Future<Either<Failure, String>> saveWatchlist(TVDetail tv);

  Future<Either<Failure, String>> removeWatchlist(TVDetail tv);

  Future<bool> isAddedToWatchlist(int id);

  Future<Either<Failure, List<TV>>> getWatchlistTvs();
}
