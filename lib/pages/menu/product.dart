import '/exports.dart';

class Product extends StatelessWidget {
  final ProductModel productModel;
  const Product({super.key, required this.productModel});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      // AppBar
      title: productModel.name,
      appBarActions: [
        /*
        productModel.isFavorite == true
            ? IconButton(
                onPressed: () {
                  setState(() {
                    productModel.isFavorite = false;
                  });
                },
                icon: const Icon(
                  FontAwesomeIcons.heartCircleMinus,
                ))
            : IconButton(
                onPressed: () {
                  setState(() {
                    productModel.isFavorite = true;
                    favorite.add(productModel);
                  });
                },
                icon: const Icon(
                  FontAwesomeIcons.heart,
                ))
        */
        IconButton(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.heartCircleMinus,
            ))
      ],

      // Body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(productModel.image),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productModel.name,
                  style: TextStyle(
                      color: white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  productModel.price.toString(),
                  style: TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Text(
              productModel.description,
              style: TextStyle(
                color: grey,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
