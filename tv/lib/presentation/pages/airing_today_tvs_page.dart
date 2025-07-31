import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/blocs/airing_today_tvs/airing_today_tvs_bloc.dart';

class AiringTodayTVsPage extends StatefulWidget {
  const AiringTodayTVsPage({super.key});

  @override
  State<AiringTodayTVsPage> createState() => _AiringTodayTVsPageState();
}

class _AiringTodayTVsPageState extends State<AiringTodayTVsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<AiringTodayTVsBloc>().add(FetchAiringTodayTVs()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Airing Today TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<AiringTodayTVsBloc, AiringTodayTVsState>(
          builder: (_, state) {
            if (state is AiringTodayTVsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is AiringTodayTVsLoaded) {
              return ListView.builder(
                itemCount: state.result.length,
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
              );
            } else if (state is AiringTodayTVsError) {
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
