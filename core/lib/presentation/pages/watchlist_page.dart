import 'package:core/presentation/blocs/watchlist/watchlist_bloc.dart';
import 'package:core/presentation/widgets/movie_card_list.dart';
import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:core/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WatchlistBloc>().add(FetchWatchlist());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistBloc>().add(FetchWatchlist());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Watchlist'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Series'),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildMovieWatchlist(), _buildTVWatchlist()],
        ),
      ),
    );
  }

  Widget _buildMovieWatchlist() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WatchlistLoaded) {
            if (state.movies.isEmpty) {
              return const Center(child: Text('No movies in watchlist.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return MovieCard(movie);
              },
              itemCount: state.movies.length,
            );
          } else if (state is WatchlistError) {
            return Center(
              child: Text(key: Key('movies_error_message'), state.message),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildTVWatchlist() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is WatchlistLoaded) {
            if (state.tvs.isEmpty) {
              return const Center(child: Text('No TV series in watchlist.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final tv = state.tvs[index];
                return TvCard(tv);
              },
              itemCount: state.tvs.length,
            );
          } else if (state is WatchlistError) {
            return Center(
              child: Text(key: Key('tvs_error_message'), state.message),
            );
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
