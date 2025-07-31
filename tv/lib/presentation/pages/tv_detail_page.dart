import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/entities/tv_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:tv/presentation/blocs/tv_detail/tv_detail_bloc.dart';

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
      context.read<TVDetailBloc>().add(FetchTVDetail(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TVDetailBloc, TVDetailState>(
        listenWhen: (_, current) {
          return current is TVDetailLoaded &&
              current.watchlistMessage.isNotEmpty;
        },
        listener: (context, state) {
          if (state is TVDetailLoaded) {
            final message = state.watchlistMessage;
            if (message == TVDetailBloc.watchlistAddSuccessMessage ||
                message == TVDetailBloc.watchlistRemoveSuccessMessage) {
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
          return current is! TVDetailLoaded || previous != current;
        },
        builder: (context, state) {
          if (state is TVDetailLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TVDetailLoaded) {
            return SafeArea(
              child: TVDetailContent(
                tv: state.tv,
                recommendations: state.tvRecommendations,
                isAddedToWatchlist: state.isAddedToWatchlist,
              ),
            );
          } else if (state is TVDetailError) {
            return Text(state.message);
          } else {
            return SizedBox.shrink();
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
                  onPressed: () {
                    if (!isAddedToWatchlist) {
                      context.read<TVDetailBloc>().add(AddTVToWatchlist(tv));
                    } else {
                      context.read<TVDetailBloc>().add(
                        RemoveTVFromWatchlist(tv),
                      );
                    }
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
