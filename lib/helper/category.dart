import '/exports.dart';

class CategoryServices extends GetxController {
  static CategoryServices instance = Get.find();

  /* ====== Stream ====== */
  Stream<List<CategoryModel>> categories() => categoriesCollection
        .snapshots()
        .map((query) => query.docs.map((item) => CategoryModel.fromJson(item)).toList());

  /* ====== Add ====== */
  addCategory(CategoryModel category) async {
    try {
      await categoriesCollection
          .doc()
          .set(category.toJson())
          .then((value) => succesSnackBar('Add'))
          .then((value) => page(const AdminHome()));
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }

  /* ====== Update ====== */
  updateCategory(CategoryModel category) async {
    try {
      await categoriesCollection
          .doc(category.id)
          .update(category.toJson())
          .then((value) => succesSnackBar('Updated'))
          .then((value) => page(const AdminHome()));
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }

  /* ====== Delete ====== */
  deleteCategory(String id) async {
    try {
      await categoriesCollection.doc(id).delete();

      await productsCollection
          .get()
          .then((value) {
            for (var product
                in value.docs.where((element) => element['categoryName'].contains(id))) {
              product['categoryName'].removeWhere((element) => element == id);
            }
          })
          .then((value) => succesSnackBar('Deleted'))
          .then((value) => page(const AdminHome()));
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }
}
