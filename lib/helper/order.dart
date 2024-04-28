// ignore_for_file: prefer_collection_literals

import '/exports.dart';

class OrderServices extends GetxController {
  static OrderServices instance = Get.find();

  /* ====== Stream ====== */
  Stream<List<OrderModel>> orders(bool limited) {
    if (limited) {
      return ordersCollection
          .orderBy('startTime', descending: true)
          .limit(5)
          .snapshots()
          .map((query) =>
              query.docs.map((item) => OrderModel.fromJson(item)).toList());
    } else {
      return ordersCollection
          .orderBy('startTime', descending: true)
          .snapshots()
          .map((query) =>
              query.docs.map((item) => OrderModel.fromJson(item)).toList());
    }
  }

  Stream<List<OrderModel>> driverOrders() => ordersCollection
      .where('driverEmail', isEqualTo: auth.currentUser!.email)
      .snapshots()
      .map((query) =>
          query.docs.map((item) => OrderModel.fromJson(item)).toList());

  /* ====== Add ======*/
  addOrder() {
    try {
      usersCollection.doc(auth.currentUser!.email).get().then(
        (value) {
          UserModel user = UserModel.fromJson(value);

          showDialog(
            context: Get.context!,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Chose your Address'),
              content: user.address != null
                  ? SizedBox(
                      height: 300,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: user.address != null
                              ? LatLng(user.address!.latitude,
                                  user.address!.longitude)
                              : LatLng(App.address['latitude'],
                                  App.address['longitude']),
                          initialZoom: 15,
                          onMapEvent: (event) {
                            user.address = GeoPoint(
                                event.camera.center.latitude,
                                event.camera.center.longitude);
                            update();
                          },
                          onTap: (tapPosition, point) {
                            user.address =
                                GeoPoint(point.latitude, point.longitude);
                            update();
                          },
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'com.arandas.yamifood_restaurant',
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point: user.address != null
                                    ? LatLng(user.address!.latitude,
                                        user.address!.longitude)
                                    : LatLng(App.address['latitude'],
                                        App.address['longitude']),
                                child: const Icon(Icons.location_pin,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      ordersCollection
                          .doc()
                          .set(
                            OrderModel(
                              id: '',
                              customerEmail: user.email,
                              startTime: DateTime.now(),
                              products: ProductServices.instance.cart,
                              endTime: null,
                              progress: 'New',
                            ).toJson(),
                          )
                          .then((value) => usersCollection.get().then((value) {
                                for (var element in value.docs) {
                                  if (element['role'] == 'Admin') {
                                    MessageServices.instance.sendMessage(
                                      token: element['token'],
                                      title: 'New Order',
                                      body: 'Check the new Order',
                                    );
                                  }
                                }
                              }))
                          .then((value) => page(const Home()))
                          .then(
                              (value) => ProductServices.instance.cart.clear())
                          .then((value) => succesSnackBar('Added'));
                    },
                    child: const Text('Submit')),
              ],
            ),
          );
        },
      );
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }

  /* ====== Accept ======*/
  acceptOrder(OrderModel order) async {
    try {
      List<UserModel> drivers = [];

      await usersCollection
          .where('role', isEqualTo: 'Driver')
          .get()
          .then((value) {
        for (var element in value.docs) {
          if (element['role'] != null) {
            drivers.add(UserModel.fromJson(element));
          }
        }
      });

      showDialog(
        context: Get.context!,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('Chose your Address'),
          content: StreamBuilder<UserModel>(
            stream: UserServices.instance.user(order.customerEmail),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: drivers.length,
                  itemBuilder: (context, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image
                      Container(
                        width: 75,
                        height: 75,
                        margin: EdgeInsets.all(dPadding),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(
                                  base64Decode(drivers[index].image)),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(12.5),
                        ),
                      ),

                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            drivers[index].name.name(),
                            style: TextStyle(fontSize: h4),
                          ),

                          // Distance
                          Text(
                            AddressServices.instance
                                .calculateDistance(
                                  LatLng(snapshot.data!.address!.latitude,
                                      snapshot.data!.address!.longitude),
                                  LatLng(drivers[index].address!.latitude,
                                      drivers[index].address!.longitude),
                                )
                                .toStringAsFixed(2),
                            style: TextStyle(fontSize: h4),
                          ),
                        ],
                      ),
                      const Spacer(),

                      // Chose
                      IconButton(
                        onPressed: () async => await ordersCollection
                            .doc(order.id)
                            .update({
                              'progress': 'Acepted',
                              'driverEmail': drivers[index].email
                            })
                            .then(
                                (value) => MessageServices.instance.sendMessage(
                                      token: snapshot.data!.token,
                                      title: 'Order Acepted',
                                      body: 'Wait the Driver',
                                    ))
                            .then(
                                (value) => MessageServices.instance.sendMessage(
                                      token: drivers[index].token,
                                      title: 'Order Acepted',
                                      body: 'Wait the Driver',
                                    ))
                            .then((value) => succesSnackBar('Acepted'))
                            .then((value) => page(const Home())),
                        icon: const Icon(Icons.check, size: 18),
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
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }

  /* ====== Reject ======*/
  rejectOrder(OrderModel order) async {
    try {
      await ordersCollection
          .doc(order.id)
          .update({'progress': 'Rejected', 'endTime': DateTime.now()})
          .then((value) => usersCollection
              .doc(order.customerEmail)
              .get()
              .then((value) => MessageServices.instance.sendMessage(
                    token: value['token'],
                    title: 'Order Rejected',
                    body: 'Check the rejected Order',
                  )))
          .then((value) => null)
          .then((value) => succesSnackBar('Rejected'));
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }

  /* ====== Done ======*/
  doneOrder(OrderModel order) async {
    try {
      await ordersCollection
          .doc(order.id)
          .update({'progress': 'Done', 'endTime': DateTime.now()})
          .then((value) => usersCollection
              .doc(order.customerEmail)
              .get()
              .then((value) => MessageServices.instance.sendMessage(
                    token: value['token'],
                    title: 'Order Rejected',
                    body: 'Check the rejected Order',
                  )))
          .then((value) => null)
          .then((value) => succesSnackBar('Done'));
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }

  /* ====== Delete ======*/
  deleteOrder(OrderModel order) {
    try {
      ordersCollection
          .doc(order.id)
          .delete()
          .then((value) => usersCollection.get().then((value) {
                for (var element in value.docs) {
                  if (element['role'] == 'Admin') {
                    MessageServices.instance.sendMessage(
                      token: element['token'],
                      title: 'Order Deleted',
                      body: 'Check the deleted Order',
                    );
                  }
                }
              }))
          .then((value) => succesSnackBar('Deleted'))
          .then((value) => page(const Home()));
    } on FirebaseException catch (error) {
      errorSnackBar(error.message!);
    }
  }

  /* ====== Price ====== */
  String price(OrderModel order) {
    LatLng app = LatLng(App.address['latitude'], App.address['longitude']);

    double productsPrice = 0.0;

    for (var product in order.products) {
      productsPrice = productsPrice + (product.price * product.cartQuantity);
    }

    usersCollection.doc(order.customerEmail).get().then((value) {
      productsPrice = productsPrice +
          AddressServices.instance.calculateDistance(
            LatLng(value['address'].latitude, value['address'].longitude),
            app,
          );
    });

    return (productsPrice + 1).toStringAsFixed(1);
  }
}
