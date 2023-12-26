import '/exports.dart';

class ProductServices extends GetxController {
  static ProductServices instance = Get.find();

  RxList<ProductModel> cart = <ProductModel>[].obs;

  /* ====== Stream ====== */
  Stream<List<ProductModel>> products() => productsCollection.snapshots().map(
        (query) => query.docs.map((item) => ProductModel.fromJson(item)).toList(),
      );

  /* ====== Cart ======*/
  Widget cartButton({required ProductModel productData}) => GetBuilder<ProductServices>(
        builder: (controller) {
          ProductModel product = controller.cart.any((element) => element.id == productData.id)
              ? controller.cart.singleWhere((element) => element.id == productData.id)
              : productData;

          return Container(
            decoration: BoxDecoration(
              color: transparent.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12.5),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Add
                if (product.cartQuantity < 5)
                  IconButton(
                    onPressed: () {
                      if (controller.cart.contains(product)) {
                        controller.cart[controller.cart.indexOf(product)].cartQuantity++;
                      } else {
                        product.cartQuantity++;
                        controller.cart.add(product);
                      }
                      controller.update();
                    },
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.add, size: 18, color: white),
                  ),

                // Quantity
                if (product.cartQuantity > 0)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: product.cartQuantity > 0 && product.cartQuantity < 5 ? 0 : dPadding,
                    ),
                    child: Text(product.cartQuantity.toString(), style: TextStyle(color: white)),
                  ),

                // Remove
                if (product.cartQuantity > 0)
                  IconButton(
                    onPressed: () {
                      if (controller.cart[controller.cart.indexOf(product)].cartQuantity == 1) {
                        if (controller.cart.length > 1) {
                          product.cartQuantity--;
                          controller.cart.remove(product);
                        } else {
                          product.cartQuantity--;
                          controller.cart.clear();
                        }
                      } else {
                        controller.cart[controller.cart.indexOf(product)].cartQuantity--;
                      }

                      controller.update();
                    },
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.remove, size: 18, color: white),
                  ),
              ],
            ),
          );
        },
      );

  /* ====== Add ======*/
  addProduct(ProductModel product) async {
    try {
      await productsCollection.doc().set(product.toJson()).then((value) => succesSnackBar('Added')).then((value) => page(const AdminHome()));
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }

  /* ====== Update ======*/
  updateProduct(ProductModel product) async {
    try {
      await productsCollection
          .doc(product.id)
          .update(product.toJson())
          .then((value) => succesSnackBar('Updated'))
          .then((value) => page(const AdminHome()));
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }

  /* ====== Delete ======*/
  deleteProduct(String id) async {
    try {
      await productsCollection.doc(id).delete().then((value) => succesSnackBar('Deleted')).then((value) => page(const AdminHome()));
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }
}
