import '/exports.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel productData;
  const ProductWidget({super.key, required this.productData});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          // Image
          leading: Container(
            width: 75,
            height: 75,
            padding: EdgeInsets.all(dPadding),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(base64Decode(productData.image)),
                fit: BoxFit.fill,
                colorFilter: overlay,
              ),
              borderRadius: BorderRadius.circular(12.5),
              boxShadow: [blackShadow],
            ),
          ),

          // Title
          title: Text(productData.name, style: const TextStyle(fontWeight: FontWeight.bold)),

          // Price & Cart
          subtitle: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Price
                Text('${productData.price} JD'),

                // Cart
                ProductServices.instance.cartButton(productData: productData),
              ],
            ),
          ),
        ),
      );
}
