import 'package:core/domain/entities/genre.dart';
import 'package:flutter/widgets.dart' hide Key;

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

String showGenres(List<Genre> genres) {
  return genres.map((e) => e.name).toList().join(',');
}

String showDuration(int runtime) {
  final int hours = runtime ~/ 60;
  final int minutes = runtime % 60;

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else {
    return '${minutes}m';
  }
}
