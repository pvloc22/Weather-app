import 'package:flutter/foundation.dart';

// Conditional import
import 'location_service.dart';
import 'mobile_location_service.dart';
import 'website_location_service.dart' if (dart.library.io) 'unsupported_location_service.dart';

class LocationServiceFactory {
  static LocationService getLocationService() {
    if (kIsWeb) {
      return WebsiteLocationService();
    } else {
      return MobileLocationService();
    }
  }
} 