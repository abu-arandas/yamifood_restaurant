import '/exports.dart';

class Bind implements Bindings {
  @override
  void dependencies() {
    Get.put(AddressServices());
    Get.put(MessageServices());
    Get.put(UserServices());
    Get.put(CategoryServices());
    Get.put(ProductServices());
    Get.put(OrderServices());
  }
}
