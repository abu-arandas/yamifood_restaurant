// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  // Auth Routes
  static const login = '/login';
  static const SIGNUP = '/signup';
  static const FORGOT_PASSWORD = '/forgot-password';

  // Driver Routes
  static const DRIVER_HOME = '/driver/home';
  static const DRIVER_PROFILE = '/driver/profile';
  static const DRIVER_HISTORY = '/driver/history';

  // Admin Routes
  static const ADMIN_DASHBOARD = '/admin/dashboard';
  static const ADMIN_POS = '/admin/pos';
  static const ADMIN_PROFILE = '/admin/profile';

  // Customer Routes
  static const CUSTOMER_HOME = '/customer/home';
  static const CUSTOMER_CART = '/customer/cart';
  static const CUSTOMER_ORDERS = '/customer/orders';
  static const CUSTOMER_PROFILE = '/customer/profile';
}
