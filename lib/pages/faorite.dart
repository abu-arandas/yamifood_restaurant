import '/exports.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Favorite Products',
      body: ListView.builder(
        itemCount: favorite.length,
        itemBuilder: (context, index) {
          return ProductContainer(
            name: favorite[index].name,
            price: favorite[index].price,
            image: favorite[index].image,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Product(productModel: favorite[index]))),
          );
        },
      ),
    );
  }
}
