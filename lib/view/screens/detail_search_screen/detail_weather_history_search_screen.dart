import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:weather_app/core/business/format_date_provider.dart';

import '../../../core/style/colors.dart';
import '../../../data/model/weather_model.dart';

class DetailWeatherHistorySearchScreen extends StatelessWidget {
  final WeatherResponse weatherResponse;
  final String cityName;

  const DetailWeatherHistorySearchScreen({
    Key? key,
    required this.weatherResponse,
    required this.cityName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details', style: TextStyle(fontWeight: FontWeight.w600, color: whiteColor)),
        backgroundColor: blueColor,
        iconTheme: IconThemeData(color: whiteColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            _rightPanel(),
          ],
        ),
      ),
    );
  }


  Widget _rightPanel() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_weatherSummary(), _weatherForecast()]),
    );
  }

  Widget _weatherSummary() {
    return _buildWeatherSummary(weatherResponse.currentWeather);
  }

  Widget _buildWeatherSummary(CurrentWeather currentWeather) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 40),
      width: double.infinity,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset('assets/images/marker_blue.png', height: 20, width: 20,),
                      SizedBox(width: 5,),
                      Text(
                        '${currentWeather.cityName} ',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(FormatDateProvider.formatYMMMd(currentWeather.date))
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: blueColor,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Image.network(
                  '${currentWeather.iconUrl ?? ''}',
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return CircularProgressIndicator();
                  },
                ),
              )
            ],
          ),

          SizedBox(
            height: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${currentWeather.temperature}°C',
                style: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                currentWeather.iconText ?? 'No description',
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Divider()
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.water_drop, color: Colors.blue,),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wind:',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${currentWeather.windSpeed} m/s',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  )
                ],
              ),

              Row(
                children: [
                  Icon(Icons.air),
                  SizedBox(width: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Humidity',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${currentWeather.humidity}%',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weatherForecast() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderWeatherForecast(weatherResponse.forecastWeather.length), 
        _buildWeatherForecast()
      ],
    );
  }

  Widget _buildWeatherForecast() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: _listWeatherForecastMobile(weatherResponse.forecastWeather),
    );
  }

  Widget _buildHeaderWeatherForecast(int days) {
    return Container(
      margin: EdgeInsets.only(top: 20,bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today_outlined,size: 20,),
          SizedBox(width: 5,),
          Text('$days-Day Forecast', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _listWeatherForecastMobile(List<ForecastWeather> listForecastsWeather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listForecastsWeather.map((forecast) => 
        Container(
          margin: EdgeInsets.only(bottom: 5),
          child: _itemWeatherForecast(forecast),
        )
      ).toList(),
    );
  }


  Widget _itemWeatherForecast(ForecastWeather forecastWth) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8), // Reduced padding
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Use minimum space needed
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 40, // Smaller image
            child: Image.network(
              '${forecastWth.iconUrl ?? ''}',
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return CircularProgressIndicator();
              },
            ),
          ),
          Text(
            '${forecastWth.date}',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 14), // Smaller font
            overflow: TextOverflow.ellipsis,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${forecastWth.temperature}°C',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12), // Smaller font
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${forecastWth.windSpeed} M/s',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500, fontSize: 12), // Smaller font
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
} 