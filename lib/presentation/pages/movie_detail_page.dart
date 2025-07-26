import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/presentation/provider/movie_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class MovieDetailPage extends StatefulWidget {
  static const routeName = '/movie';

  final int id;

  const MovieDetailPage({super.key, required this.id});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieDetailNotifier>(
        context,
        listen: false,
      ).fetchMovieDetail(widget.id);
      Provider.of<MovieDetailNotifier>(
        context,
        listen: false,
      ).loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<MovieDetailNotifier>(
        builder: (_, provider, _) {
          if (provider.movieState == RequestState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.movieState == RequestState.Loaded) {
            final movie = provider.movie;
            return SafeArea(
              child: DetailContent(
                movie: movie,
                recommendations: provider.movieRecommendations,
                isAddedWatchlist: provider.isAddedToWatchlist,
              ),
            );
          } else {
            return Text(provider.message);
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedWatchlist;

  const DetailContent({
    required this.movie,
    required this.recommendations,
    required this.isAddedWatchlist,
    super.key,
  });

  Future<void> _onWatchlistButtonPressed(BuildContext context) async {
    if (!isAddedWatchlist) {
      await Provider.of<MovieDetailNotifier>(
        context,
        listen: false,
      ).addWatchlist(movie);
    } else {
      await Provider.of<MovieDetailNotifier>(
        context,
        listen: false,
      ).removeFromWatchlist(movie);
    }

    final message = Provider.of<MovieDetailNotifier>(
      context,
      listen: false,
    ).watchlistMessage;

    if (message == MovieDetailNotifier.watchlistAddSuccessMessage ||
        message == MovieDetailNotifier.watchlistRemoveSuccessMessage) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(content: Text(message));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: '$baseImageUrl${movie.posterPath}',
          width: screenWidth,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: richBlack,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: _buildSheetContent(scrollController, context),
              );
            },
            // initialChildSize: 0.5,
            minChildSize: 0.25,
            // maxChildSize: 1.0,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: richBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSheetContent(
    ScrollController scrollController,
    BuildContext context,
  ) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 16),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(movie.title, style: textHeading5),
                FilledButton(
                  onPressed: () async {
                    await _onWatchlistButtonPressed(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isAddedWatchlist ? Icon(Icons.check) : Icon(Icons.add),
                      Text('Watchlist'),
                    ],
                  ),
                ),
                Text(showGenres(movie.genres)),
                Text(showDuration(movie.runtime)),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: movie.voteAverage / 2,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Icon(Icons.star, color: mikadoYellow);
                      },
                      itemSize: 24,
                    ),
                    Text('${movie.voteAverage}'),
                  ],
                ),
                SizedBox(height: 16),
                Text('Overview', style: textHeading6),
                Text(movie.overview),
                SizedBox(height: 16),
                Text('Recommendations', style: textHeading6),
                Consumer<MovieDetailNotifier>(
                  builder: (context, data, child) {
                    if (data.recommendationState == RequestState.Loading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (data.recommendationState == RequestState.Error) {
                      return Text(data.message);
                    } else if (data.recommendationState ==
                        RequestState.Loaded) {
                      return _buildRecommendations();
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(color: Colors.white, height: 4, width: 48),
        ),
      ],
    );
  }

  SizedBox _buildRecommendations() {
    return SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final movie = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  MovieDetailPage.routeName,
                  arguments: movie.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${movie.posterPath}',
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          );
        },
        itemCount: recommendations.length,
      ),
    );
  }
}
