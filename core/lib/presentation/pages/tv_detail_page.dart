import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/presentation/provider/tv_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class TVDetailPage extends StatefulWidget {
  final int id;

  const TVDetailPage({super.key, required this.id});

  @override
  State<TVDetailPage> createState() => _TVDetailPageState();
}

class _TVDetailPageState extends State<TVDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TvDetailNotifier>(
        context,
        listen: false,
      ).fetchTvDetail(widget.id);
      Provider.of<TvDetailNotifier>(
        context,
        listen: false,
      ).loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<TvDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.tvState == RequestState.Loading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.tvState == RequestState.Loaded) {
            final tv = provider.tv;
            return SafeArea(
              child: TVDetailContent(
                tv: tv,
                recommendations: provider.tvRecommendations,
                isAddedToWatchlist: provider.isAddedToWatchlist,
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

class TVDetailContent extends StatelessWidget {
  final TVDetail tv;
  final List<TV> recommendations;
  final bool isAddedToWatchlist;

  const TVDetailContent({
    super.key,
    required this.tv,
    required this.recommendations,
    required this.isAddedToWatchlist,
  });

  Future<void> _onWatchlistButtonPressed(BuildContext context) async {
    if (!isAddedToWatchlist) {
      await Provider.of<TvDetailNotifier>(
        context,
        listen: false,
      ).addWatchlist(tv);
    } else {
      await Provider.of<TvDetailNotifier>(
        context,
        listen: false,
      ).removeFromWatchlist(tv);
    }

    final message = Provider.of<TvDetailNotifier>(
      context,
      listen: false,
    ).watchlistMessage;

    if (message == TvDetailNotifier.watchlistAddSuccessMessage ||
        message == TvDetailNotifier.watchlistRemoveSuccessMessage) {
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
          imageUrl: '$baseImageUrl${tv.posterPath}',
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

  Stack _buildSheetContent(
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
                Text(tv.name, style: textHeading5),
                FilledButton(
                  onPressed: () async {
                    await _onWatchlistButtonPressed(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      isAddedToWatchlist ? Icon(Icons.check) : Icon(Icons.add),
                      Text('Watchlist'),
                    ],
                  ),
                ),
                Text(showGenres(tv.genres)),
                Text('Total Seasons: ${tv.numberOfSeasons}'),
                Text('Total Episodes: ${tv.numberOfEpisodes}'),
                Row(
                  children: [
                    RatingBarIndicator(
                      rating: tv.voteAverage / 2,
                      itemCount: 5,
                      itemBuilder: (context, index) =>
                          Icon(Icons.star, color: mikadoYellow),
                      itemSize: 24,
                    ),
                    Text('${tv.voteAverage}'),
                  ],
                ),
                SizedBox(height: 16),
                Text('Overview', style: textHeading6),
                Text(tv.overview),
                SizedBox(height: 16),
                Text('Recommendations', style: textHeading6),
                Consumer<TvDetailNotifier>(
                  builder: (context, data, child) {
                    if (data.recommendationState == RequestState.Loading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (data.recommendationState == RequestState.Error) {
                      return Text(data.message);
                    } else if (data.recommendationState ==
                        RequestState.Loaded) {
                      if (data.tvRecommendations.isNotEmpty) {
                        return _buildRecommendations();
                      } else {
                        return Text('No recommendations found');
                      }
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
          final tv = recommendations[index];
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  tvDetailRoute,
                  arguments: tv.id,
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: '$baseImageUrl${tv.posterPath}',
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
