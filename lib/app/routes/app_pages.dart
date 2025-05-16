import '../../exports.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // Custom transition duration
  static const Duration transitionDuration = Duration(milliseconds: 300);

  // Default transition to use across the app
  static const Transition defaultTransition = Transition.fadeIn;
  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.FOOD_DETAILS,
      page: () => const FoodDetailsView(),
      binding: FoodBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.CATEGORIES,
      page: () => const CategoriesView(),
      binding: FoodBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.CART,
      page: () => const CartView(),
      binding: CartBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.ABOUT,
      page: () => const AboutView(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.CONTACT,
      page: () => const ContactView(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.FAVORITES,
      page: () => const FavoritesView(),
      binding: HomeBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.ORDERS,
      page: () => const OrdersView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<OrderController>(() => OrderController());
      }),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
    GetPage(
      name: Routes.SEARCH,
      page: () => const SearchView(),
      binding: FoodBinding(),
      transition: defaultTransition,
      transitionDuration: transitionDuration,
    ),
  ];
}
