class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.yamifood.com';
  static const String apiVersion = 'v1';
  
  // App Configuration
  static const String appName = 'YamiFood Restaurant';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache Duration
  static const Duration cacheExpiry = Duration(hours: 1);
  static const Duration shortCacheExpiry = Duration(minutes: 15);
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
  
  // Validation
  static const int minPasswordLength = 8;
  static const int maxNameLength = 50;
  static const int maxDescriptionLength = 500;
  
  // Business Rules
  static const double minOrderAmount = 10.0;
  static const double maxDeliveryDistance = 50.0; // km
  static const int maxItemsPerOrder = 50;
  
  // File Upload
  static const int maxImageSizeMB = 5;
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];
  
  // Error Messages
  static const String networkError = 'Network connection failed. Please check your internet connection.';
  static const String serverError = 'Server error occurred. Please try again later.';
  static const String unknownError = 'An unexpected error occurred. Please try again.';
}