import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/provider/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/watchlist_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist';

  const WatchlistPage({super.key});

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<WatchlistMovieNotifier>(
        context,
        listen: false,
      ).fetchWatchlistMovies();
      Provider.of<WatchlistTvNotifier>(
        context,
        listen: false,
      ).fetchWatchlistTvs();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(
      context,
      listen: false,
    ).fetchWatchlistMovies();
    Provider.of<WatchlistTvNotifier>(
      context,
      listen: false,
    ).fetchWatchlistTvs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Watchlist')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer2<WatchlistMovieNotifier, WatchlistTvNotifier>(
          builder: (context, dataMovie, dataTv, child) {
            if (dataMovie.watchlistState == RequestState.Loading &&
                dataTv.watchlistState == RequestState.Loading) {
              return Center(child: CircularProgressIndicator());
            } else if (dataMovie.watchlistState == RequestState.Loaded &&
                dataTv.watchlistState == RequestState.Loaded) {
              final List<Object> combinedWatchlist = [];
              combinedWatchlist.addAll(dataMovie.watchlistMovies);
              combinedWatchlist.addAll(dataTv.watchlistTvs);

              if (combinedWatchlist.isEmpty) {
                return Center(
                  key: Key('empty_watchlist'),
                  child: Text("No watchlist found."),
                );
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  final item = combinedWatchlist[index];
                  if (item is Movie) {
                    return MovieCard(item);
                  } else if (item is Tv) {
                    return TvCard(item);
                  }

                  return const SizedBox.shrink();
                },
                itemCount: combinedWatchlist.length,
              );
            } else {
              return Center(
                key: Key('error_message'),
                child: Text(dataMovie.message),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
