import 'package:core/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/blocs/on_the_air_tvs/on_the_air_tvs_bloc.dart';

class OnTheAirTVsPage extends StatefulWidget {
  const OnTheAirTVsPage({super.key});

  @override
  State<OnTheAirTVsPage> createState() => _OnTheAirTVsPageState();
}

class _OnTheAirTVsPageState extends State<OnTheAirTVsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<OnTheAirTVsBloc>().add(FetchOnTheAirTVs()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('On The Air TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<OnTheAirTVsBloc, OnTheAirTVsState>(
          builder: (_, state) {
            if (state is OnTheAirTVsLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OnTheAirTVsLoaded) {
              return ListView.builder(
                itemCount: state.result.length,
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
              );
            } else if (state is OnTheAirTVsError) {
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
    ;
  }
}
