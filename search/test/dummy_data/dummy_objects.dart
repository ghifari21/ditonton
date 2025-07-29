import 'package:core/data/models/movie_table.dart';
import 'package:core/data/models/tv_table.dart';
import 'package:core/domain/entities/genre.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

final testTV = TV(
  backdropPath: '/96RT2A47UdzWlUfvIERFyBsLhL2.jpg',
  firstAirDate: '2023-09-29',
  genreIds: [16, 10759, 18, 10765],
  id: 209867,
  name: 'Freiren: Beyond Journey\'s End',
  originCountry: 'JP',
  originalLanguage: 'ja',
  originalName: '葬送のフリーレン',
  overview:
      'Decades after her party defeated the Demon King, an old friend\'s funeral launches the elf wizard Frieren on a journey of self-discovery.',
  popularity: 56.3858,
  posterPath: '/dqZENchTd7lp5zht7BdlqM7RBhD.jpg',
  voteAverage: 8.78,
  voteCount: 475,
);

final testTVList = [testTV];

final testTVDetail = TVDetail(
  adult: false,
  backdropPath: '/96RT2A47UdzWlUfvIERFyBsLhL2.jpg',
  episodeRunTime: [25],
  firstAirDate: '2023-09-29',
  genres: [Genre(id: 16, name: 'Animation')],
  homepage: 'https://frieren-anime.jp/',
  id: 1,
  inProduction: true,
  languages: ['ja'],
  lastAirDate: '2024-03-22',
  name: 'name',
  numberOfEpisodes: 28,
  numberOfSeasons: 2,
  originCountry: ['JP'],
  originalLanguage: 'ja',
  originalName: '葬送のフリーレン',
  overview: 'overview',
  popularity: 56.3858,
  posterPath: 'posterPath',
  status: 'Returning Series',
  tagline: '',
  type: 'Scripted',
  voteAverage: 8.78,
  voteCount: 475,
);

final testWatchlistTV = TV.watchlist(
  id: 1,
  name: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVTable = TVTable(
  id: 1,
  title: 'name',
  posterPath: 'posterPath',
  overview: 'overview',
);

final testTVMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'name',
};
