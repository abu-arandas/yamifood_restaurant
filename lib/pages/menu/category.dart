import '/exports.dart';

class Category extends StatelessWidget {
  final CategoryModel categoryModel;
  const Category({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: categoryModel.name,
      body: StreamBuilder<DocumentSnapshot>(
        stream: categoryCollection.doc(categoryModel.id).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.get('subcategory').toList();

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final singleProduct = ProductModel(
                  name: data[index]['name'],
                  description: data[index]['description'],
                  price: data[index]['price'],
                  image: data[index]['image'],
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
            );
          } else {
            return waitContainer();
          }
        },
      ),
    );
  }
}
