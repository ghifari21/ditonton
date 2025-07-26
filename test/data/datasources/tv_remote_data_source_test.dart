import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TVRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TVRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Airing Today TV Series', () {
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_airing_today.json')),
    ).tvList;

    test(
      'should return list of TV Model when the response code is 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_airing_today.json'), 200),
        );

        final result = await dataSource.getAiringTodayTvShows();
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/airing_today?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getAiringTodayTvShows();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get On The Air TV Series', () {
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_on_the_air.json')),
    ).tvList;

    test(
      'should return list of TV Model when the response code is 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_on_the_air.json'), 200),
        );

        final result = await dataSource.getOnTheAirTvShows();
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getOnTheAirTvShows();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Popular TV Series', () {
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_popular.json')),
    ).tvList;

    test(
      'should return list of TV Model when the response code is 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_popular.json'), 200),
        );

        final result = await dataSource.getPopularTvShows();
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getPopularTvShows();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get Top Rated TV Series', () {
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_top_rated.json')),
    ).tvList;

    test(
      'should return list of TV Model when the response code is 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_top_rated.json'), 200),
        );

        final result = await dataSource.getTopRatedTvShows();
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getTopRatedTvShows();
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get TV Detail', () {
    final tId = 1;
    final tTvDetail = TVDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_detail.json')),
    );

    test(
      'should return TV Detail Model when the response code is 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_detail.json'), 200),
        );

        final result = await dataSource.getTvShowDetail(tId);
        expect(result, equals(tTvDetail));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/tv/$tId?$API_KEY')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getTvShowDetail(tId);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get TV Recommendations', () {
    final tId = 1;
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/tv_recommendations.json')),
    ).tvList;

    test(
      'should return list of TV Model when the response code is 200',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_recommendations.json'),
            200,
          ),
        );

        final result = await dataSource.getTvShowRecommendations(tId);
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/tv/$tId/recommendations?$API_KEY'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.getTvShowRecommendations(tId);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('search TV Series', () {
    final tQuery = 'The Fragrant Flower Blooms with Dignity';
    final tTvList = TVResponse.fromJson(
      json.decode(readJson('dummy_data/search_tv.json')),
    ).tvList;

    test(
      'should return list of TV Model when the response code is 200',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery'),
          ),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/search_tv.json'), 200),
        );

        final result = await dataSource.searchTvShows(tQuery);
        expect(result, equals(tTvList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
      () async {
        when(
          mockHttpClient.get(
            Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$tQuery'),
          ),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.searchTvShows(tQuery);
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
