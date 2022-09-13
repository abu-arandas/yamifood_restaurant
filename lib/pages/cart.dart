import '/exports.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Cart Products',
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          return ProductContainer(
            name: cart[index].name,
            price: cart[index].price,
            image: cart[index].image,
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Product(productModel: cart[index]))),
          );
        },
      ),
    );
  }
}
