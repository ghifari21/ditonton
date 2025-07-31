part of 'home_page_bloc.dart';

abstract class HomePageEvent extends Equatable {
  const HomePageEvent();

  @override
  List<Object> get props => [];
}

class FetchHomePageData extends HomePageEvent {
  const FetchHomePageData();

  @override
  List<Object> get props => [];
}
