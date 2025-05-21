

import 'package:flutter/material.dart';

import '../model/search_city_result.dart' show SearchCityResult;
import '../model/weather_model.dart';
import '../remote/weather_api_client.dart';
class HomeRepository{
  final weatherApiClient = WeatherApiClient();

  Future<WeatherResponse> getCurrentAndForecastsWeather(String cityName) async {
    try {
      final weatherResponse = await weatherApiClient.fetchWeatherWithCityName(cityName);
      return weatherResponse;
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }
  Future<WeatherResponse> getCurrentAndForecastsUseGPSWeather(double latitude, double longitude) async {
    try {
      final weatherResponse = await weatherApiClient.fetchWeatherWithLatitudeAndLongitude(latitude, longitude);
      return weatherResponse;
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }
  Future<List<ForecastWeather>> getMoreForecastsWeather(String cityName, int days) async {
    try {
      final forecasts = await weatherApiClient.fetchMoreForecasts(cityName, days);
      return forecasts;
    } catch (e) {
      throw Exception('Error fetching more forecast data: $e');
    }
  }
  Future<SearchCityResult> getSearchCityName(String cityName) async {
    try {
      final searchCityResult = await weatherApiClient.searchCityName(cityName);
      return searchCityResult;
    } catch (e) {
      throw Exception('Error fetching search city data: $e');
    }
  }
}