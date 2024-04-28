import '/exports.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  DateTime day = DateTime.now();

  @override
  Widget build(BuildContext context) => AdminScaf(
        body: FB5Row(
          children: [
            // Orders
            FB5Col(
              classNames: 'col-lg-6 col-md-6 col-sm-12 col-xs-12',
              child: StreamBuilder<List<OrderModel>>(
                stream: OrderServices.instance.orders(false),
                builder: (context, ordersSnapshot) {
                  if (ordersSnapshot.hasData) {
                    List<OrderModel> orders = ordersSnapshot.data!
                        .where((element) =>
                            DateTime(
                                element.startTime.year,
                                element.startTime.month,
                                element.startTime.day) ==
                            DateTime(day.year, day.month, day.day))
                        .toList();

                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(dPadding),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                  child: Text('New Orders',
                                      style: title(
                                          context: context, color: primary))),
                              TextButton(
                                onPressed: () => showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now()
                                      .subtract(const Duration(days: 5)),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 5)),
                                ).then((value) => value != null
                                    ? setState(() => day = value)
                                    : {}),
                                child: Text(DateFormat.yMMMd().format(day)),
                              ),
                            ],
                          ),
                        ),

                        // Orders
                        FB5Row(
                          children: List.generate(
                            orders.length,
                            (index) => FB5Col(
                              classNames:
                                  'col-lg-4 col-md-6 col-sm-12 col-xs-12 p-3',
                              child: OrderWidget(order: orders[index]),
                            ),
                          ),
                        ),

                        // Empty
                        if (orders.isEmpty)
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
                    );
                  } else if (ordersSnapshot.hasError) {
                    return Center(child: Text(ordersSnapshot.error.toString()));
                  } else if (ordersSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return waitContainer();
                  } else {
                    return Container();
                  }
                },
              ),
            ),

            // Drivers
            FB5Col(
              classNames: 'col-lg-6 col-md-6 col-sm-12 col-xs-12 p-3',
              child: StreamBuilder<List<UserModel>>(
                stream: UserServices.instance.drivers(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SizedBox(
                      height: webScreen(context) ? screenHeight(context) : 300,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(App.address['latitude'],
                              App.address['longitude']),
                          initialZoom: 15,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'com.arandas.yamifood_restaurant',
                          ),
                          MarkerLayer(
                            markers: List.generate(
                              snapshot.data!.length,
                              (index) => Marker(
                                point: LatLng(
                                  snapshot.data![index].address!.latitude,
                                  snapshot.data![index].address!.longitude,
                                ),
                                child: ListTile(
                                  title: const Icon(Icons.location_pin,
                                      color: Colors.red),
                                  subtitle: Flexible(
                                      child: Text(
                                          snapshot.data![index].name.name())),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return waitContainer();
                  } else {
                    return Container();
                  }
                },
              ),
            ),
          ],
        ),
      );
}
