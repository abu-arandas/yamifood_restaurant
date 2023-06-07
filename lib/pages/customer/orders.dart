import '/exports.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((event) {
      if (event == null) {
        page(const Home());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomerScaf(
      pageName: 'Orders',
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: dPadding),
        child: StreamBuilder<List<OrderModel>>(
          stream: OrderServices.instance.orders(false),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BootstrapContainer(
                children: [
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.all(dPadding / 2),
                    child: BootstrapHeading.h2(text: 'Last Orders', color: primary),
                  ),

                  // Orders
                  if (snapshot.data!.isNotEmpty)
                    for (var order in snapshot.data!) OrderWidget(order: order),

                  // Empty
                  if (snapshot.data!.isEmpty)
                    Container(
                      width: double.maxFinite,
                      height: 200,
                      margin: EdgeInsets.all(dPadding),
                      padding: EdgeInsets.all(dPadding),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.5),
                        color: Theme.of(context).cardColor,
                      ),
                      child: const BootstrapHeading.h2(text: 'No New Orders'),
                    ),
                ],
              );
            } else {
              return waitContainer();
            }
          },
        ),
      ),
    );
  }
}
