import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/blocs/top_rated_tvs/top_rated_tvs_bloc.dart';

class TopRatedTVsPage extends StatefulWidget {
  const TopRatedTVsPage({super.key});

  @override
  State<TopRatedTVsPage> createState() => _TopRatedTVsPageState();
}

class _TopRatedTVsPageState extends State<TopRatedTVsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => context.read<TopRatedTVsBloc>().add(FetchTopRatedTVs()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTVsBloc, TopRatedTVsState>(
          builder: (_, state) {
            if (state is TopRatedTVsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is TopRatedTVsLoaded) {
              return ListView.builder(
                itemCount: state.result.length,
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
              );
            } else if (state is TopRatedTVsError) {
              return Center(
                child: Text(key: Key('error_message'), state.message),
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
