
class AppConstants {
  // App Info
  static const String appName = 'Yamifood Restaurant';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String foodsCollection = 'foods';
  static const String categoriesCollection = 'categories';
  static const String ordersCollection = 'orders';

  // Default Values
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultTaxRate = 0.1; // 10%
  static const double defaultDeliveryFee = 3.99;

  // Animation Durations
  static const Duration defaultDuration = Duration(milliseconds: 300);

  // Asset Paths
  static const String logoPath = 'asset/images/logo.png';
  static const String placeholderImagePath = 'asset/images/placeholder.png';
}
