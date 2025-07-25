import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TvTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String? type;

  TvTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    this.type = 'tv',
  });

  factory TvTable.fromEntity(TvDetail tv) => TvTable(
    id: tv.id,
    title: tv.name,
    posterPath: tv.posterPath,
    overview: tv.overview,
    type: 'tv',
  );

  factory TvTable.fromMap(Map<String, dynamic> map) => TvTable(
    id: map['id'],
    title: map['title'],
    posterPath: map['posterPath'],
    overview: map['overview'],
    type: map['type'] ?? 'tv',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'posterPath': posterPath,
    'overview': overview,
    'type': type,
  };

  Tv toEntity() => Tv.watchlist(
    id: id,
    name: title,
    posterPath: posterPath,
    overview: overview,
  );

  @override
  List<Object?> get props => [id, title, posterPath, overview, type];
}
