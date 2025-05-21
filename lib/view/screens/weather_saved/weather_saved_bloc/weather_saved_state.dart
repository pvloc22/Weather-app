

import '../../../../data/model/weather_model.dart';

abstract class WeatherSavedState {}

class WeatherSavedInitialState extends WeatherSavedState {}

class WeatherSavedLoadingState extends WeatherSavedState {}

class WeatherSavedLoadedState extends WeatherSavedState {
  final List<WeatherResponse> savedWeathers;
  
  WeatherSavedLoadedState({required this.savedWeathers});
}

class WeatherSavedErrorState extends WeatherSavedState {
  final String message;
  
  WeatherSavedErrorState({required this.message});
} 