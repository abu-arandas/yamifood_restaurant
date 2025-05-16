import '../../exports.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final RxInt currentIndex = 0.obs;
  final RxInt currentTabIndex = 0.obs;
  final PageController pageController = PageController();
  final PageController tabPageController = PageController();

  // For banners
  final List<String> bannerImages = [
    'asset/images/slider-01.jpg',
    'asset/images/slider-02.jpg',
    'asset/images/slider-03.jpg',
  ];

  // For quick menu access
  final RxBool isFavoritesLoading = false.obs;
  final RxList<FoodModel> favoriteFoods = <FoodModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    initFavorites();
  }

  @override
  void onClose() {
    pageController.dispose();
    tabPageController.dispose();
    super.onClose();
  }

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void changeTab(int index) {
    currentTabIndex.value = index;

    // Handle specific actions based on tab selection
    switch (index) {
      case 0: // Home
        Get.toNamed(Routes.HOME);
        break;
      case 1: // Menu - Navigate to categories
        Get.toNamed(Routes.CATEGORIES);
        break;
      case 2: // Cart
        Get.toNamed(Routes.CART);
        break;
      case 3: // Favorites
        Get.toNamed(Routes.FAVORITES);
        break;
      case 4: // Profile
        final authController = Get.find<AuthController>();
        if (authController.isLoggedIn) {
          Get.toNamed(Routes.PROFILE);
        } else {
          Get.toNamed(Routes.LOGIN);
        }
        break;
    }
  }

  // Favorites management
  void initFavorites() {
    // Initialize favorites (could be stored in SharedPreferences or Firebase)
    loadFavorites();
  }

  void loadFavorites() {
    isFavoritesLoading.value = true;

    // In a real app, this would load from storage or DB
    // For now we'll just simulate with a delay
    Future.delayed(const Duration(milliseconds: 800), () {
      final foodController = Get.find<FoodController>();

      // Simulate user's favorites (random selection for demo)
      if (foodController.allFoods.isNotEmpty) {
        favoriteFoods.value = foodController.allFoods
            .where((food) => food.name.length > 5) // Just a random condition
            .take(4)
            .toList();
      }

      isFavoritesLoading.value = false;
    });
  }

  void toggleFavorite(FoodModel food) {
    if (isFoodFavorite(food)) {
      favoriteFoods.remove(food);
    } else {
      favoriteFoods.add(food);
    }
  }

  bool isFoodFavorite(FoodModel food) {
    return favoriteFoods.any((f) => f.id == food.id);
  }
}
