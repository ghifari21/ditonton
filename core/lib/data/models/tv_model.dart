import 'package:core/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

class TVModel extends Equatable {
  final String backdropPath;
  final String firstAirDate;
  final List<int> genreIds;
  final int id;
  final String name;
  final String originCountry;
  final String originalLanguage;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;

  const TVModel({
    required this.backdropPath,
    required this.firstAirDate,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originCountry,
    required this.originalLanguage,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TVModel.fromJson(Map<String, dynamic> json) {
    return TVModel(
      backdropPath: json["backdrop_path"] ?? '',
      firstAirDate: json["first_air_date"] ?? '',
      genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
      id: json["id"],
      name: json["name"] ?? '',
      originCountry: json["origin_country"]?.isNotEmpty == true
          ? json["origin_country"][0]
          : '',
      originalLanguage: json["original_language"] ?? '',
      originalName: json["original_name"] ?? '',
      overview: json["overview"] ?? '',
      popularity: (json["popularity"] as num).toDouble(),
      posterPath: json["poster_path"] ?? '',
      voteAverage: (json["vote_average"] as num).toDouble(),
      voteCount: json["vote_count"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "backdrop_path": backdropPath,
      "first_air_date": firstAirDate,
      "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
      "id": id,
      "name": name,
      "origin_country": originCountry,
      "original_language": originalLanguage,
      "original_name": originalName,
      "overview": overview,
      "popularity": popularity,
      "poster_path": posterPath,
      "vote_average": voteAverage,
      "vote_count": voteCount,
    };
  }

  TV toEntity() {
    return TV(
      backdropPath: backdropPath,
      firstAirDate: firstAirDate,
      genreIds: genreIds,
      id: id,
      name: name,
      originCountry: originCountry,
      originalLanguage: originalLanguage,
      originalName: originalName,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  @override
  List<Object?> get props => [
    backdropPath,
    firstAirDate,
    genreIds,
    id,
    name,
    originCountry,
    originalLanguage,
    originalName,
    overview,
    popularity,
    posterPath,
    voteAverage,
    voteCount,
  ];
}
