import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/business/format_date_provider.dart';

import '../../../../core/style/colors.dart';
import '../../../../data/constaints/constaints.dart';
import '../../../../data/model/weather_model.dart';
import '../../search/search_screen.dart';
import '../../subscription/subscription_screen.dart';
import '../../weather_saved/weather_saved_screen.dart';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../../data/repositories/email_subscription_repository.dart';

class HomeForm extends StatefulWidget {
  const HomeForm({super.key});

  @override
  State<HomeForm> createState() => _HomeFormState();
}

class _HomeFormState extends State<HomeForm> {
  final TextEditingController _cityNameController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoadingMore = false;
  WeatherResponse? _weatherResponse;

  /// Loading more
  int _daysForecast = 0;
  String _currentCityName = '';
  bool _isSubscribed = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _scrollController.addListener(() {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        // Check if we're at least 80% through the scroll
        if (currentScroll >= (maxScroll * 0.8)) {
          if (_daysForecast > 0 && _currentCityName.isNotEmpty && !_isLoadingMore && _daysForecast < 14) {
            _isLoadingMore = true;
            context.read<HomeBloc>().add(
              LoadMoreForecastEvent(
                cityName: _currentCityName,
                days: _daysForecast + 4,
                currentWeather: _weatherResponse!.currentWeather,
              ),
            );
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _cityNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Dashboard', style: TextStyle(fontWeight: FontWeight.w600, color: whiteColor)),
        backgroundColor: blueColor,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherSavedScreen()));
            },
            icon: Icon(Icons.save_alt, color: whiteColor),
          ),

          BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previousState, state) {
              return state is HomeStatusSubscriptionState;
            },
            builder: (context, state) {
              if (state is HomeStatusSubscriptionState) {
                _isSubscribed = state.status;
              }
              return IconButton(
                onPressed: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) => SubscriptionScreen()));
                  context.read<HomeBloc>().add(CheckSubscriptionStatusEvent());
                },
                icon: Stack(
                  children: [
                    Icon(Icons.mail_outline, color: whiteColor),
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Icon(Icons.circle, size: 12, color: _isSubscribed ? Colors.green : Colors.red),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          FocusScope.of(context).unfocus();
          if (state is HomeLoadingState) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (state is HomeLoadedState) {
            Navigator.of(context).pop();
            _weatherResponse = WeatherResponse(
              currentWeather: state.currentWeather,
              forecastWeather: state.listForecastWeather,
            );
            _currentCityName = state.currentWeather.cityName!;
            _daysForecast = state.listForecastWeather.length;
            _isLoadingMore = false;
          } else if (state is HomeLoadedMoreState) {
            _weatherResponse = _weatherResponse!.copyWith(forecastWeather: state.forecastWeather);
            _daysForecast = state.forecastWeather.length;
            _isLoadingMore = false;
          } else if (state is HomeErrorState) {
            Navigator.of(context, rootNavigator: true).pop();
            FocusScope.of(context).unfocus();
            _isLoadingMore = false;

            // Different dialog/message based on error type
            if (state.errorType == CITY_NOT_FOUND_ERROR_TYPE) {
              // City not found error
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("City Not Found"),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: 'Location ', style: TextStyle(fontWeight: FontWeight.normal)),
                                TextSpan(
                                  text: _cityNameController.text,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                TextSpan(text: ' not found.', style: TextStyle(fontWeight: FontWeight.normal)),
                              ],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Please check the spelling or try a different location.'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else if (state.errorType == NETWORK_ERROR_TYPE) {
              // Network error
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Network Error"),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Unable to connect to the weather service.'),
                          SizedBox(height: 8),
                          Text('Please check your internet connection and try again.'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            } else {
              // General or other errors
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Error"),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text(state.errorMessage),
                          SizedBox(height: 8),
                          Text('Please try again later.'),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            }
          } else if (state is HomeErrorMoreState) {
            /// Lazy loading
            _isLoadingMore = false;

            // Show a snackbar with the error message for load more errors
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                duration: Duration(seconds: 3),
                backgroundColor:
                    state.errorType == NETWORK_ERROR_TYPE
                        ? Colors.red
                        : (state.errorType == CITY_NOT_FOUND_ERROR_TYPE ? Colors.orange : Colors.grey[700]),
                action: SnackBarAction(
                  label: 'OK',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
              ),
            );
          } else if (state is HomeLoadingMoreState) {
            /// Lazy loading
            _isLoadingMore = true;
          }
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          child: BlocBuilder<HomeBloc, HomeState>(
            buildWhen: (previous, current) {
              // Rebuild UI when state changes to HomeLoadedState or HomeLoadedMoreState
              return current is HomeLoadedState || current is HomeLoadedMoreState;
            },
            builder: (context, state) {
              return Column(children: [_leftPanel(), if (_weatherResponse != null) _rightPanel()]);
            },
          ),
        ),
      ),
    );
  }

  Widget _leftPanel() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Enter a city Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: TextField(
              controller: _cityNameController,
              onChanged: (value) {},
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                filled: true,
                fillColor: whiteColor,
                border: OutlineInputBorder(),
                hintText: 'E.g., New York, Tokyo',
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: blueColor, width: 1.0)),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search, color: blueColor, size: 30),
              ),
              readOnly: true,
              onTap: () async {
                FocusScope.of(context).unfocus();

                // Navigate to SearchScreen with current query
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchScreen(initialQuery: _cityNameController.text)),
                );

                // Handle the returned query
                if (result != null && result is String && result.isNotEmpty) {
                  _cityNameController.text = result;
                  context.read<HomeBloc>().add(SearchCityEvent(cityName: result));
                }
              },
            ),
          ),

          InkWell(
            onTap: () {
              context.read<HomeBloc>().add(RequireCurrentLocationEvent(isWebsite: kIsWeb));
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: grayColor, borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/marker.png', height: 20, width: 20),
                  SizedBox(width: 5),
                  Text('Use Current Location', style: TextStyle(fontSize: 16, color: whiteColor)),
                ],
              ),
            ),
          ),
        ],
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
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) {
        return current is HomeLoadedState;
      },
      builder: (context, state) {
        return _buildWeatherSummary(_weatherResponse!.currentWeather);
      },
    );
  }

  Widget _buildWeatherSummary(CurrentWeather currentWeather) {
    return Container(
      padding: EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 40),
      width: double.infinity,
      decoration: BoxDecoration(color: blueColor, borderRadius: BorderRadius.circular(5)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/marker.png', height: 20, width: 20),
                        SizedBox(width: 5),
                        Text(
                          '${currentWeather.cityName}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: whiteColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Text(
                      FormatDateProvider.formatYMMMd(currentWeather.date),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: whiteColor),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      '${currentWeather.iconUrl ?? ''}',
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return CircularProgressIndicator();
                      },
                    ),
                    Text(
                      currentWeather.iconText ?? 'No description',
                      style: TextStyle(fontWeight: FontWeight.w600, color: whiteColor),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${currentWeather.temperature}°C',
                  style: TextStyle(fontSize: 40, color: whiteColor, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.air, color: whiteColor),
                        Text(
                          'Wind: ${currentWeather.windSpeed} M/s',
                          style: TextStyle(fontSize: 14, color: whiteColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.water_drop, color: whiteColor),
                        Text(
                          'Humidity: ${currentWeather.humidity}%',
                          style: TextStyle(fontSize: 14, color: whiteColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _weatherForecast() {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) {
        return current is HomeLoadedState || current is HomeLoadedMoreState || current is HomeLoadingState;
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeaderWeatherForecast(_weatherResponse!.forecastWeather.length), _buildWeatherForecast()],
        );
      },
    );
  }

  Widget _buildWeatherForecast() {
    if (kIsWeb) {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) {
                return current is HomeLoadedMoreState ||
                    current is HomeLoadingMoreState ||
                    current is HomeErrorMoreState;
              },
              builder: (context, state) {
                if (state is HomeLoadingMoreState) {
                  return Center(child: Container(margin: EdgeInsets.only(top: 30), child: CircularProgressIndicator()));
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      );
    } else {
      return BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
            child: _listWeatherForecastMobile(_weatherResponse!.forecastWeather, state),
          );
        },
      );
    }
  }

  Widget _buildHeaderWeatherForecast(int days) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Text('$days-Day Forecast', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
    );
  }

  Widget _listWeatherForecastMobile(List<ForecastWeather> listForecastsWeather, HomeState state) {
    // Don't show loading indicator if we're already at the maximum forecasts
    bool isLoading = _isLoadingMore && _daysForecast < 14;

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: listForecastsWeather.length + (isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < listForecastsWeather.length) {
          return Container(child: _itemWeatherForecast(listForecastsWeather[index]));
        } else {
          return Container(width: 80, child: Center(child: CircularProgressIndicator()));
        }
      },
    );
  }

  Widget _itemWeatherForecast(ForecastWeather forecastWth) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8), // Reduced padding
      decoration: BoxDecoration(color: grayColor, borderRadius: BorderRadius.circular(5)),
      child: Row(
        children: [
          Column(
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
                FormatDateProvider.formatWeekday(forecastWth.date),
                style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${forecastWth.temperature}°C',
                style: TextStyle(color: whiteColor, fontWeight: FontWeight.w600, fontSize: 25), // Smaller font
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3), // Reduced spacing
              Text(
                'Wind: ${forecastWth.windSpeed} M/s',
                style: TextStyle(color: whiteColor, fontWeight: FontWeight.w500, fontSize: 12), // Smaller font
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 3), // Reduced spacing
              Text(
                'Humidity: ${forecastWth.humidity}%',
                style: TextStyle(color: whiteColor, fontWeight: FontWeight.w500, fontSize: 12), // Smaller font
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Spacer(),
          Text(
            FormatDateProvider.formatMonthDay(forecastWth.date),
            style: TextStyle(fontWeight: FontWeight.w600, color: whiteColor),
          ),
        ],
      ),
    );
  }
}
