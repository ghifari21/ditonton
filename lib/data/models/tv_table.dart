import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

class TVTable extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final String? type;

  const TVTable({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    this.type = 'tv',
  });

  factory TVTable.fromEntity(TVDetail tv) {
    return TVTable(
      id: tv.id,
      title: tv.name,
      posterPath: tv.posterPath,
      overview: tv.overview,
      type: 'tv',
    );
  }

  factory TVTable.fromMap(Map<String, dynamic> map) {
    return TVTable(
      id: map['id'],
      title: map['title'],
      posterPath: map['posterPath'],
      overview: map['overview'],
      type: map['type'] ?? 'tv',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'posterPath': posterPath,
      'overview': overview,
      'type': type,
    };
  }

  TV toEntity() {
    return TV.watchlist(
      id: id,
      name: title,
      posterPath: posterPath,
      overview: overview,
    );
  }

  @override
  List<Object?> get props => [id, title, posterPath, overview, type];
}
