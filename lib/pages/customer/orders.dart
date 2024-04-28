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
  Widget build(BuildContext context) => CustomerScaf(
        pageName: 'Orders',
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: dPadding),
          child: StreamBuilder<List<OrderModel>>(
            stream: OrderServices.instance.orders(false),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.all(dPadding),
                  child: Wrap(
                    children: [
                      Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(dPadding),
                        child: Text(
                          'Last order',
                          style: title(context: context, color: primary),
                        ),
                      ),

                      // Orders
                      if (snapshot.data!.isNotEmpty)
                        for (var order in snapshot.data!)
                          FB5Col(
                            classNames: 'col-lg-4 col-md-6 col-sm-12 col-xs-12',
                            child: OrderWidget(order: order),
                          ),

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
                          child: Text(
                            'No new Orders',
                            style: TextStyle(fontSize: h3),
                          ),
                        ),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return waitContainer();
              } else {
                return Container();
              }
            },
          ),
        ),
      );
}
