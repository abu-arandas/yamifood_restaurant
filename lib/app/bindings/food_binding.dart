import '../../exports.dart';

class FoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodController>(() => FoodController());
  }
}
