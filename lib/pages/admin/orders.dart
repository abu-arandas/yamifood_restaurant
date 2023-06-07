// ignore_for_file: prefer_collection_literals

import '/exports.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  ///map controller
  Completer<GoogleMapController> mapController = Completer();

  @override
  void dispose() {
    mapController = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaf(
      body: BootstrapContainer(
        children: [
          // Orders
          BootstrapCol(
            sizes: 'col-lg-6 col-md-6 col-sm-12',
            child: StreamBuilder<List<OrderModel>>(
              stream: OrderServices.instance.orders(false),
              builder: (context, ordersSnapshot) {
                if (ordersSnapshot.hasData) {
                  return Column(
                    children: [
                      const BootstrapHeading.h2(text: 'New Orders'),
                      Column(
                        children: List.generate(
                          ordersSnapshot.data!.length,
                          (index) => OrderWidget(order: ordersSnapshot.data![index]),
                        ),
                      ),
                    ],
                  );
                } else {
                  return waitContainer();
                }
              },
            ),
          ),

          // Drivers
          BootstrapCol(
            sizes: 'col-lg-6 col-md-6 col-sm-12',
            child: StreamBuilder<List<UserModel>>(
              stream: UserServices.instance.drivers(),
              builder: (context, snapshot) => !snapshot.hasData
                  ? waitContainer()
                  : SizedBox(
                      height: webScreen(context) ? screenHeight(context) : 300,
                      child: GoogleMap(
                        onMapCreated: (controller) {
                          if (!mapController.isCompleted) {
                            mapController.complete(controller);
                          }
                        },
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                            App.address['latitude'],
                            App.address['longitude'],
                          ),
                          zoom: 15,
                        ),
                        myLocationEnabled: false,
                        myLocationButtonEnabled: false,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        gestureRecognizers: Set()
                          ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                        markers: {
                          for (var driver in snapshot.data!)
                            Marker(
                              markerId: MarkerId(
                                  '${driver.name['firstName']} ${driver.name['lastName']}'),
                              position: LatLng(
                                driver.address!.latitude,
                                driver.address!.longitude,
                              ),
                            )
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
