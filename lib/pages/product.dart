import '/exports.dart';

class Product extends StatefulWidget {
  final ProductModel productModel;
  const Product({super.key, required this.productModel});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      // AppBar
      title: widget.productModel.name,
      appBarActions: [
        widget.productModel.isFavorite == true
            ? IconButton(
                onPressed: () {
                  setState(() {
                    widget.productModel.isFavorite = false;
                  });
                },
                icon: const Icon(
                  FontAwesomeIcons.heartCircleMinus,
                ))
            : IconButton(
                onPressed: () {
                  setState(() {
                    widget.productModel.isFavorite = true;
                    favorite.add(widget.productModel);
                  });
                },
                icon: const Icon(
                  FontAwesomeIcons.heart,
                ))
      ],

      // Body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(widget.productModel.image),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.productModel.name,
                  style: TextStyle(
                      color: white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
                Text(
                  widget.productModel.price,
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
              widget.productModel.description,
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
