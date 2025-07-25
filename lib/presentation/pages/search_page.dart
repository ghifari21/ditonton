import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/movie_search_notifier.dart';
import 'package:ditonton/presentation/provider/tv_search_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  static const ROUTE_NAME = '/search';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Search'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Shows'),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onSubmitted: (query) {
                  Provider.of<MovieSearchNotifier>(
                    context,
                    listen: false,
                  ).fetchMovieSearch(query);
                  Provider.of<TvSearchNotifier>(
                    context,
                    listen: false,
                  ).fetchTvSearch(query);
                },
                decoration: InputDecoration(
                  hintText: 'Search title',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.search,
              ),
              SizedBox(height: 16),
              Text('Search Result', style: kHeading6),

              Expanded(
                child: TabBarView(
                  children: [_buildMovieSearchResult(), _buildTvSearchResult()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMovieSearchResult() {
    return Consumer<MovieSearchNotifier>(
      builder: (context, data, _) {
        if (data.state == RequestState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (data.state == RequestState.Loaded) {
          if (data.searchResult.isEmpty) {
            return const Center(child: Text("No results found."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final movie = data.searchResult[index];
              return MovieCard(movie);
            },
            itemCount: data.searchResult.length,
          );
        } else {
          return Center(child: Text(data.message));
        }
      },
    );
  }

  Widget _buildTvSearchResult() {
    return Consumer<TvSearchNotifier>(
      builder: (context, data, _) {
        if (data.state == RequestState.Loading) {
          return Center(child: CircularProgressIndicator());
        } else if (data.state == RequestState.Loaded) {
          if (data.searchResult.isEmpty) {
            return const Center(child: Text("No results found."));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final tv = data.searchResult[index];
              return TvCard(tv);
            },
            itemCount: data.searchResult.length,
          );
        } else {
          return Center(child: Text(data.message));
        }
      },
    );
  }
}
