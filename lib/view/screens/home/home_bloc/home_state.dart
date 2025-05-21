import 'package:flutter/material.dart';

import '../../../../data/model/weather_model.dart';

@immutable
abstract class HomeState {
  const HomeState();

  @override
  List<Object?> get props => [];
}
class HomeInitialState extends HomeState {
  const HomeInitialState();
  @override
  List<Object?> get props => [];
}
class HomeLoadingState extends HomeState {
  const HomeLoadingState();
  @override
  List<Object?> get props => [];
}
class HomeLoadedState extends HomeState {
  // final String cityName;
  final List<ForecastWeather> listForecastWeather;
  final CurrentWeather currentWeather;

  const HomeLoadedState({required this.currentWeather, required this.listForecastWeather});
  @override   
  List<Object?> get props => [currentWeather, listForecastWeather];
}
class HomeErrorState extends HomeState {
  final String errorMessage;
  final String errorType;

  HomeErrorState({required this.errorMessage, required this.errorType});
  @override
  List<Object?> get props => [errorMessage,errorType];
}
class HomeLoadingMoreState extends HomeState {
  const HomeLoadingMoreState();
  @override
  List<Object?> get props => [];
} 
class HomeLoadedMoreState extends HomeState {
  final List<ForecastWeather> forecastWeather;
  const HomeLoadedMoreState({required this.forecastWeather});
  @override
  List<Object?> get props => [forecastWeather];
}
class HomeErrorMoreState extends HomeState {
  final String errorMessage;
  final String errorType;

  HomeErrorMoreState({required this.errorMessage, required this.errorType});
  @override
  List<Object?> get props => [errorMessage, errorType];
}
class HomeRequireCurrentLocationErrorState extends HomeState {
  final String errorMessage;
  
  const HomeRequireCurrentLocationErrorState({
    this.errorMessage = 'Unable to access your current location. Please check your location settings and permissions.'
  });
  
  @override
  List<Object?> get props => [errorMessage];
}
class HomeRequireCurrentLocationSuccessState extends HomeState {
  final WeatherResponse weatherResponse;
  const HomeRequireCurrentLocationSuccessState({required this.weatherResponse});
  @override
  List<Object?> get props => [weatherResponse];
}

class HomeStatusSubscriptionState extends HomeState{
  final bool status;

  const HomeStatusSubscriptionState({required this.status});

  @override
  List<Object?> get props => [status];
}