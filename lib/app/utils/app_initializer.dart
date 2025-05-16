import '../../exports.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    ); // Initialize services first
    await _initServices();

    // Then initialize controllers
    _initControllers();
  }

  static void _initControllers() {
    // Inject global controllers
    Get.put(AuthController(), permanent: true);
    Get.put(HomeController(), permanent: true);
    Get.put(FoodController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(OrderController(), permanent: true);
  }

  static Future<void> _initServices() async {
    // Initialize GetStorage for persistent storage
    await GetStorage.init();

    // Initialize theme service
    Get.put(ThemeService(), permanent: true);

    // Initialize error handler service
    Get.put(await ErrorHandler().init(), permanent: true);

    // Here we can initialize services differently for web vs mobile
    if (kIsWeb) {
      // Web-specific initializations
      _initWebServices();
    } else {
      // Mobile-specific initializations
      _initMobileServices();
    }
  }

  static void _initWebServices() {
    // Web-specific services
    // For example, configure analytics differently for web
    print('Initializing web services');
  }

  static void _initMobileServices() {
    // Mobile-specific services
    // For example, configure local notifications
    print('Initializing mobile services');
  }
}
