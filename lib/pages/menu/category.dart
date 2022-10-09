import '/exports.dart';

class Category extends StatelessWidget {
  final CategoryModel categoryModel;
  const Category({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: categoryModel.name,
      body: ListView.builder(
        itemCount: categoryModel.subcategory.length,
        itemBuilder: (context, index) {
          final singleProduct = ProductModel(
            name: categoryModel.subcategory[index].name,
            description: categoryModel.subcategory[index].description,
            price: categoryModel.subcategory[index].price,
            image: categoryModel.subcategory[index].image,
          );

          return ProductContainer(
            name: singleProduct.name,
            price: singleProduct.price,
            image: singleProduct.image,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Product(productModel: singleProduct))),
          );
        },
      ),
    );
  }
}
