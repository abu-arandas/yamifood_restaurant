import '/exports.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel productData;
  const ProductWidget({super.key, required this.productData});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductServices>(
      init: ProductServices(),
      builder: (controller) {
        ProductModel product = controller.cart.any((element) => element.id == productData.id)
            ? controller.cart.singleWhere((element) => element.id == productData.id)
            : productData;

        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Container(
                width: double.maxFinite,
                height: 150,
                padding: EdgeInsets.all(dPadding),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: MemoryImage(base64Decode(product.image)),
                    fit: BoxFit.fill,
                    colorFilter: overlay,
                  ),
                  borderRadius: BorderRadius.circular(12.5),
                  boxShadow: [blackShadow],
                ),
              ),

              // Title
              Padding(
                padding: EdgeInsets.only(left: dPadding),
                child: BootstrapHeading.h3(text: product.name),
              ),

              // Price & Cart
              Padding(
                padding: EdgeInsets.all(dPadding).copyWith(top: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Price
                    BootstrapParagraph(text: '${product.price} JD'),

                    // Cart
                    controller.cartButton(product: product),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
