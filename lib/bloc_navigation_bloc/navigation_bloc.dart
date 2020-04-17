import 'package:covid/screens/countries_screen.dart';
import 'package:covid/screens/index.dart';
import 'package:covid/screens/preventive_measures.dart';
import 'package:covid/screens/symptoms.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class NavigationEvents {}

class HomePageClickEvent extends NavigationEvents {}

class AllCountriesClickEvent extends NavigationEvents {
  final List countriesList;
  final bool isDark;
  final List followed;

  AllCountriesClickEvent({this.countriesList, this.isDark, this.followed});
}

class SymptomsClickEvent extends NavigationEvents {}

class PreventiveMeasuresClickEvent extends NavigationEvents {}

abstract class NavigationStates {}

class NavigationBloc extends Bloc<NavigationEvents, NavigationStates> {
  @override
  NavigationStates get initialState => Home();

  @override
  Stream<NavigationStates> mapEventToState(NavigationEvents event) async* {
    if (event is HomePageClickEvent) {
      yield Home();
    }
    if (event is AllCountriesClickEvent) {
      yield Countries(
        countriesList: event.countriesList,
        followed: event.followed,
        isDark: event.isDark,
      );
    }
    if (event is SymptomsClickEvent) {
      yield Symptoms();
    }
    if (event is PreventiveMeasuresClickEvent) {
      yield PreventiveMeasures();
    }
  }
}
