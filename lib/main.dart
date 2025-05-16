import 'exports.dart';

Future<void> main() async {
  // Initialize app services and dependencies
  await AppInitializer.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeService>();
    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      themeMode: themeService.theme,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
      defaultTransition: AppPages.defaultTransition,
      initialBinding: AppBinding(),
    );
  }
}

// Global bindings for the app
class AppBinding extends Bindings {
  @override
  void dependencies() {
    // These controllers are already initialized in AppInitializer
    // This is just to ensure they're available for GetX dependency injection
  }
}

/*
flutter run -d edge --web-renderer html
flutter build web --web-renderer html
firebase deploy
*/
