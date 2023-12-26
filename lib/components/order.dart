import '/exports.dart';

class OrderWidget extends StatelessWidget {
  final OrderModel order;
  const OrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) => StreamBuilder<UserModel>(
        stream: UserServices.instance.user(auth.currentUser!.email),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasData) {
            return Container(
              width: double.maxFinite,
              margin: EdgeInsets.all(dPadding / 2),
              decoration: BoxDecoration(
                color: secondary,
                borderRadius: BorderRadius.circular(12.5),
                boxShadow: [blackShadow],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Map
                  StreamBuilder<List<UserModel>>(
                    stream: UserServices.instance.users(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        UserModel customer = snapshot.data!.singleWhere((element) => element.email == order.customerEmail);

                        UserModel? driver =
                            order.driverEmail != null ? snapshot.data!.singleWhere((element) => element.email == order.driverEmail) : null;

                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(12.5)),
                            child: FlutterMap(
                              options: MapOptions(
                                initialCenter: order.driverEmail != null
                                    ? driver!.address != null
                                        ? LatLng(driver.address!.latitude, driver.address!.longitude)
                                        : LatLng(App.address['latitude'], App.address['longitude'])
                                    : LatLng(customer.address!.latitude, customer.address!.longitude),
                                initialZoom: 15,
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.arandas.yamifood_restaurant',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(customer.address!.latitude, customer.address!.longitude),
                                      child: ListTile(
                                        title: const Icon(Icons.location_pin, color: Colors.red),
                                        subtitle: Text(customer.name.name()),
                                      ),
                                    ),
                                    if (order.driverEmail != null && (order.progress != 'Done' || order.progress != 'Done'))
                                      Marker(
                                        point: LatLng(driver!.address!.latitude, driver.address!.longitude),
                                        child: ListTile(
                                          title: const Icon(Icons.directions_car, color: Colors.blue),
                                          subtitle: Text(driver.name.name()),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
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

                  // Products
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.all(dPadding / 2),
                    padding: EdgeInsets.all(dPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(Get.context!).cardColor,
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title
                        Text(
                          'Products :',
                          style: TextStyle(fontSize: h3, color: primary, fontWeight: FontWeight.bold),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: order.products.length,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, productsOndex) => Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.all(dPadding / 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.5),
                              boxShadow: [primaryShadow],
                            ),
                            child: Container(
                              width: double.maxFinite,
                              height: 150,
                              padding: EdgeInsets.all(dPadding / 2),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(base64Decode(order.products[productsOndex].image)),
                                  fit: BoxFit.fill,
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.75), BlendMode.darken),
                                ),
                                borderRadius: BorderRadius.circular(12.5),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Name
                                  Text(
                                    order.products[productsOndex].name,
                                    style: TextStyle(fontSize: h4, color: white),
                                  ),

                                  // Price && Count
                                  Padding(
                                    padding: EdgeInsets.all(dPadding / 2),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        // Price
                                        Text('${order.products[productsOndex].price} JD'),
                                        SizedBox(width: dPadding / 2),

                                        // Count
                                        Text('* ${order.products[productsOndex].cartQuantity}'),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Informations
                  Container(
                    width: double.maxFinite,
                    margin: EdgeInsets.all(dPadding / 2).copyWith(top: 0),
                    padding: EdgeInsets.all(dPadding),
                    decoration: BoxDecoration(
                      color: Theme.of(Get.context!).cardColor,
                      borderRadius: BorderRadius.circular(12.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Progress
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Progress :',
                              style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: dPadding),
                            Text(order.progress),
                          ],
                        ),

                        // Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Price :',
                              style: TextStyle(fontSize: 18, color: white, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: dPadding),
                            Text('${OrderServices.instance.price(order)} JD'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Admin Buttons
                  if (userSnapshot.data!.role == 'Admin' && order.progress != 'Done')
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: danger,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12.5)),
                      ),
                      child: Row(
                        children: [
                          if (order.progress != 'Acepted' && order.progress != 'Done')
                            Expanded(
                              child: InkWell(
                                onTap: () => OrderServices.instance.acceptOrder(order),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12.5)),
                                child: Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(dPadding),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: success,
                                    borderRadius: order.progress != 'Acepted' && order.progress != 'Done'
                                        ? const BorderRadius.only(bottomLeft: Radius.circular(12.5))
                                        : const BorderRadius.only(
                                            bottomLeft: Radius.circular(12.5),
                                            bottomRight: Radius.circular(12.5),
                                          ),
                                  ),
                                  child: const Text('Accept'),
                                ),
                              ),
                            ),
                          Expanded(
                            child: InkWell(
                              onTap: () => OrderServices.instance.rejectOrder(order),
                              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12.5)),
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(dPadding),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: danger,
                                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12.5)),
                                ),
                                child: const Text('Reject'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Delete Button
                  if (userSnapshot.data!.role == 'Customer' && order.progress != 'Done')
                    InkWell(
                      onTap: () => OrderServices.instance.deleteOrder(order),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12.5)),
                      child: Container(
                        width: double.maxFinite,
                        padding: EdgeInsets.all(dPadding),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: danger,
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12.5)),
                        ),
                        child: const Text('Delete'),
                      ),
                    ),

                  // Driver
                  if (userSnapshot.data!.role == 'Driver')
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: danger,
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12.5)),
                      ),
                      child: Row(
                        children: [
                          if (order.progress == 'Acepted')
                            Expanded(
                              child: InkWell(
                                onTap: () => OrderServices.instance.doneOrder(order),
                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12.5)),
                                child: Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(dPadding),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: success,
                                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(12.5)),
                                  ),
                                  child: const Text('Done'),
                                ),
                              ),
                            ),
                          if (order.progress == 'Acepted' && order.progress != 'Done')
                            Expanded(
                              child: InkWell(
                                onTap: () => OrderServices.instance.rejectOrder(order),
                                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12.5)),
                                child: Container(
                                  width: double.maxFinite,
                                  padding: EdgeInsets.all(dPadding),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: danger,
                                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(12.5)),
                                  ),
                                  child: const Text('Reject'),
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                ],
              ),
            );
          } else if (userSnapshot.hasError) {
            return Center(child: Text(userSnapshot.error.toString()));
          } else if (userSnapshot.connectionState == ConnectionState.waiting) {
            return waitContainer();
          } else {
            return Container();
          }
        },
      );
}
