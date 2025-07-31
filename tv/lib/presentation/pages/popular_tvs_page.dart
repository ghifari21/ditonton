import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/blocs/popular_tvs/popular_tvs_bloc.dart';

class PopularTVsPage extends StatefulWidget {
  const PopularTVsPage({super.key});

  @override
  State<PopularTVsPage> createState() => _PopularTVsPageState();
}

class _PopularTVsPageState extends State<PopularTVsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(
      () => context.read<PopularTVsBloc>().add(FetchPopularTVs()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTVsBloc, PopularTVsState>(
          builder: (_, state) {
            if (state is PopularTVsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PopularTVsLoaded) {
              return ListView.builder(
                itemCount: state.result.length,
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
              );
            } else if (state is PopularTVsError) {
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
