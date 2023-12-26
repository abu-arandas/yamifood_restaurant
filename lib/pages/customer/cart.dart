import '/exports.dart';

class Cart extends GetView<ProductModel> {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) => GetBuilder<ProductServices>(
        init: ProductServices(),
        builder: (controller) {
          double total = 0;

          for (ProductModel product in controller.cart) {
            total = total + (product.price * product.cartQuantity);
          }

          return CustomerScaf(
            pageName: 'Cart',
            body: StreamBuilder<User?>(
              stream: auth.authStateChanges(),
              builder: (context, snapshot) => Wrap(
                children: [
                  // Title
                  Container(
                    width: double.maxFinite,
                    alignment: Alignment.centerLeft,
                    child: Text('Cart Products', style: TextStyle(fontSize: h2)),
                  ),

                  // Products
                  for (ProductModel product in controller.cart)
                    Div(
                      lg: Col.col4,
                      md: Col.col6,
                      sm: Col.col12,
                      child: Card(
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
                              padding: EdgeInsets.only(top: dPadding, left: dPadding),
                              child: Text(product.name, style: TextStyle(fontSize: h4)),
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
                                  Text('${product.price} JD'),

                                  // Cart
                                  controller.cartButton(productData: product),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  // Empty
                  if (controller.cart.isEmpty)
                    Card(
                      child: Container(
                        width: double.maxFinite,
                        height: 200,
                        margin: EdgeInsets.all(dPadding),
                        padding: EdgeInsets.all(dPadding),
                        alignment: Alignment.center,
                        child: Text('Cart is Empty', style: TextStyle(fontSize: h3, color: white)),
                      ),
                    ),

                  // Price
                  priceInfo(context, 'Items Price', '${total.toStringAsFixed(1)} JD'),
                  if (snapshot.hasData)
                    StreamBuilder<UserModel>(
                      stream: UserServices.instance.user(auth.currentUser!.email),
                      builder: (context, userSnapshot) {
                        if (userSnapshot.hasData) {
                          String deliver = (AddressServices.instance.calculateDistance(
                                    LatLng(App.address['latitude'], App.address['longitude']),
                                    LatLng(userSnapshot.data!.address!.latitude, userSnapshot.data!.address!.longitude),
                                  ) +
                                  1)
                              .toStringAsFixed(2);

                          return Column(
                            children: [
                              priceInfo(context, 'Deliver', '$deliver JD'),
                              priceInfo(context, 'Total', '${(num.parse(deliver) + total).toStringAsFixed(1)} JD'),
                            ],
                          );
                        } else {
                          return priceInfo(context, 'Total', 'Must be Logged In');
                        }
                      },
                    ),

                  // Button
                  if (controller.cart.isNotEmpty)
                    ElevatedButton(
                      onPressed: () => snapshot.hasData
                          ? OrderServices.instance.addOrder()
                          : showDialog(
                              context: Get.context!,
                              builder: (BuildContext context) {
                                return BootstrapModal(
                                  dismissble: true,
                                  title: 'Please Sign in to complete!',
                                  actions: [
                                    ElevatedButton(
                                      onPressed: () => page(const SignIn()),
                                      child: const Text('Shop More'),
                                    )
                                  ],
                                );
                              },
                            ),
                      child: const Text('Submit'),
                    ),
                ],
              ),
            ),
          );
        },
      );

  Widget priceInfo(context, String title, String data) => Padding(
        padding: EdgeInsets.only(bottom: dPadding / 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(data),
          ],
        ),
      );
}
