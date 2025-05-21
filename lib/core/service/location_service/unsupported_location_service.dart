import 'package:weather_app/core/service/location_service/location_service.dart';

class WebsiteLocationService extends LocationService {
  @override
  Future<List<double>?> getCurrentLocation() async {
    throw UnsupportedError('Web location service is not available on this platform. Please use the mobile location service instead.');
  }
} 