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
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return ProductContainer(
            name: categoryModel.subcategory[index].name,
            price: categoryModel.subcategory[index].price,
            image: categoryModel.subcategory[index].image,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Product(
                        productModel: categoryModel.subcategory[index]))),
          );
        },
      ),
    );
  }
}
