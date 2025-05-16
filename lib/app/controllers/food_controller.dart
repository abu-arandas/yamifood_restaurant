import '../../exports.dart';

class FoodController extends GetxController {
  static FoodController get to => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<FoodModel> allFoods = <FoodModel>[].obs;
  RxList<FoodModel> featuredFoods = <FoodModel>[].obs;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  Rx<FoodModel?> selectedFood = Rx<FoodModel?>(null);
  RxString selectedCategory = 'All'.obs;

  RxBool isLoading = false.obs;
  RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
    fetchAllFoods();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    error.value = '';

    await ErrorHandler.to.handleDatabaseOperation(
      operation: () async {
        final querySnapshot =
            await _firestore.collection('categories').where('isActive', isEqualTo: true).orderBy('name').get();

        categories.value = querySnapshot.docs
            .map((doc) => CategoryModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList();
        return querySnapshot;
      },
      errorMessage: 'Failed to fetch categories',
    );

    isLoading.value = false;
  }

  Future<void> fetchAllFoods() async {
    isLoading.value = true;
    error.value = '';

    await ErrorHandler.to.handleDatabaseOperation(
      operation: () async {
        final querySnapshot =
            await _firestore.collection('foods').where('isAvailable', isEqualTo: true).orderBy('name').get();

        allFoods.value = querySnapshot.docs
            .map((doc) => FoodModel.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList();

        featuredFoods.value = allFoods.where((food) => food.isFeatured).toList();
        return querySnapshot;
      },
      errorMessage: 'Failed to fetch food items',
    );

    isLoading.value = false;
  }

  List<FoodModel> getFoodsByCategory(String category) {
    if (category == 'All') {
      return allFoods;
    } else {
      return allFoods.where((food) => food.category == category).toList();
    }
  }

  void setSelectedFood(FoodModel food) {
    selectedFood.value = food;
  }

  void clearSelectedFood() {
    selectedFood.value = null;
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }
}
