import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/entities/movie_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie/presentation/blocs/movie_detail/movie_detail_bloc.dart';

class MovieDetailPage extends StatefulWidget {
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
      context.read<MovieDetailBloc>().add(FetchMovieDetail(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<MovieDetailBloc, MovieDetailState>(
        listenWhen: (_, current) {
          return current is MovieDetailLoaded &&
              current.watchlistMessage.isNotEmpty;
        },
        listener: (context, state) {
          if (state is MovieDetailLoaded) {
            final message = state.watchlistMessage;
            if (message == MovieDetailBloc.watchlistAddSuccessMessage ||
                message == MovieDetailBloc.watchlistRemoveSuccessMessage) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            } else if (message.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(content: Text(message));
                },
              );
            }
          }
        },
        buildWhen: (previous, current) {
          return current is! MovieDetailLoaded || previous != current;
        },
        builder: (context, state) {
          if (state is MovieDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieDetailLoaded) {
            return SafeArea(
              child: DetailContent(
                movie: state.movie,
                recommendations: state.movieRecommendations,
                isAddedWatchlist: state.isAddedToWatchlist,
              ),
            );
          } else if (state is MovieDetailError) {
            return Text(state.message);
          } else {
            return SizedBox.shrink();
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
            minChildSize: 0.25,
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
                  onPressed: () {
                    if (!isAddedWatchlist) {
                      context.read<MovieDetailBloc>().add(
                        AddMovieToWatchlist(movie),
                      );
                    } else {
                      context.read<MovieDetailBloc>().add(
                        RemoveMovieFromWatchlist(movie),
                      );
                    }
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
                _buildRecommendations(),
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
                  movieDetailRoute,
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
