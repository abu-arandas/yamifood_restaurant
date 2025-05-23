import 'package:get/get.dart';
import '../views/admin/home/admin_home_view.dart';
import '../views/auth/login_view.dart';
import '../views/auth/signup_view.dart';
import '../views/auth/forgot_password_view.dart';
import '../views/driver/home/driver_home_view.dart';
import '../views/driver/profile/driver_profile_view.dart';
import '../views/driver/history/driver_history_view.dart';
import '../views/admin/pos/admin_pos_view.dart';
import '../views/admin/profile/admin_profile_view.dart';
import '../views/customer/home/customer_home_view.dart';
import '../views/customer/orders/customer_orders_view.dart';
import '../views/customer/profile/customer_profile_view.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    // Auth Routes
    GetPage(
      name: Routes.login,
      page: () => LoginView(),
    ),
    GetPage(
      name: Routes.SIGNUP,
      page: () => const SignupView(),
    ),
    GetPage(
      name: Routes.FORGOT_PASSWORD,
      page: () => ForgotPasswordView(),
    ),

    // Driver Routes
    GetPage(
      name: Routes.DRIVER_HOME,
      page: () => DriverHomeView(),
    ),
    GetPage(
      name: Routes.DRIVER_PROFILE,
      page: () => DriverProfileView(),
    ),
    GetPage(
      name: Routes.DRIVER_HISTORY,
      page: () => DriverHistoryView(),
    ),

    // Admin Routes
    GetPage(
      name: Routes.ADMIN_DASHBOARD,
      page: () => AdminHomeView(),
    ),
    GetPage(
      name: Routes.ADMIN_POS,
      page: () => AdminPosView(),
    ),
    GetPage(
      name: Routes.ADMIN_PROFILE,
      page: () => AdminProfileView(),
    ),

    // Customer Routes
    GetPage(
      name: Routes.CUSTOMER_HOME,
      page: () => CustomerHomeView(),
    ),

    GetPage(
      name: Routes.CUSTOMER_ORDERS,
      page: () => const CustomerOrdersView(),
    ),
    GetPage(
      name: Routes.CUSTOMER_PROFILE,
      page: () => const CustomerProfileView(),
    ),
  ];
}
