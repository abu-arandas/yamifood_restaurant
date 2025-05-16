import '../../exports.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  final _box = GetStorage();
  final _key = 'isDarkMode';

  final Rx<ThemeMode> themeMode = Rx<ThemeMode>(ThemeMode.light);

  ThemeMode get theme => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.read(_key) ?? false;

  _saveThemeToBox(bool isDarkMode) => _box.write(_key, isDarkMode);

  void switchTheme() {
    Get.changeThemeMode(_loadThemeFromBox() ? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemeFromBox());
    themeMode.value = Get.isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  void onInit() {
    super.onInit();
    themeMode.value = theme;
  }
}
