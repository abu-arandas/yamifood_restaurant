// ignore_for_file: prefer_collection_literals

import '/exports.dart';

class OrderWidget extends StatefulWidget {
  final OrderModel order;
  const OrderWidget({super.key, required this.order});

  @override
  State<OrderWidget> createState() => _OrderWidgetState();
}

class _OrderWidgetState extends State<OrderWidget> {
  Completer<GoogleMapController> mapController = Completer();

  @override
  void dispose() {
    mapController = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel>(
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
                      UserModel customer = snapshot.data!
                          .singleWhere((element) => element.email == widget.order.customerEmail);

                      UserModel? driver = widget.order.driverEmail != null
                          ? snapshot.data!
                              .singleWhere((element) => element.email == widget.order.driverEmail)
                          : null;

                      List<LatLng> polylineCoordinates = [];
                      void getPolyPoints() async {
                        PolylinePoints polylinePoints = PolylinePoints();
                        PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
                          'AIzaSyB-wRvfz3hvj_8gvyahQMoJXb0_Dpjsvxs',
                          PointLatLng(customer.address!.latitude, customer.address!.longitude),
                          PointLatLng(userSnapshot.data!.address!.latitude,
                              userSnapshot.data!.address!.longitude),
                        );
                        if (result.points.isNotEmpty) {
                          for (var point in result.points) {
                            polylineCoordinates.add(
                              LatLng(point.latitude, point.longitude),
                            );
                          }
                          setState(() {});
                        }
                      }

                      if (userSnapshot.data!.role == 'Driver') getPolyPoints();

                      return Container(
                        width: double.maxFinite,
                        height: webScreen(context) ? 400 : 200,
                        color: Theme.of(Get.context!).cardColor,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12.5),
                            topRight: Radius.circular(12.5),
                          ),
                          child: GoogleMap(
                            onMapCreated: (controller) {
                              if (!mapController.isCompleted) {
                                mapController.complete(controller);
                              }
                            },
                            initialCameraPosition: CameraPosition(
                              target: userSnapshot.data!.address != null
                                  ? LatLng(
                                      userSnapshot.data!.address!.latitude,
                                      userSnapshot.data!.address!.longitude,
                                    )
                                  : LatLng(
                                      App.address['latitude'],
                                      App.address['longitude'],
                                    ),
                              zoom: 15,
                            ),
                            myLocationEnabled: true,
                            myLocationButtonEnabled: true,
                            scrollGesturesEnabled: true,
                            zoomGesturesEnabled: true,
                            gestureRecognizers: Set()
                              ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                            markers: {
                              Marker(
                                markerId: const MarkerId('My Location'),
                                position: LatLng(
                                  customer.address!.latitude,
                                  customer.address!.longitude,
                                ),
                                infoWindow: InfoWindow(
                                  title:
                                      '${customer.name['firstName']} ${customer.name['lastName']}',
                                  snippet: customer.phone.international,
                                  onTap: () async => await launchUrl(
                                      Uri.parse('tel:${customer.phone.international}')),
                                ),
                              ),
                              if (driver != null)
                                Marker(
                                  markerId: const MarkerId('Driver'),
                                  position: LatLng(
                                    driver.address!.latitude,
                                    driver.address!.longitude,
                                  ),
                                  infoWindow: InfoWindow(
                                    title: '${driver.name['firstName']} ${driver.name['lastName']}',
                                    snippet: driver.phone.international,
                                    onTap: () async => await launchUrl(
                                        Uri.parse('tel:${driver.phone.international}')),
                                  ),
                                ),
                            },
                            polylines: {
                              Polyline(
                                polylineId: const PolylineId("route"),
                                points: polylineCoordinates,
                                color: const Color(0xFF7B61FF),
                                width: 6,
                              ),
                            },
                          ),
                        ),
                      );
                    } else {
                      return waitContainer();
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
                      BootstrapHeading.h4(text: 'Products :', color: white),
                      BootstrapRow(
                        children: List.generate(
                          widget.order.products.length,
                          (productsOndex) => BootstrapCol(
                            sizes: 'col-lg-6 col-md-6 col-sm-12',
                            child: Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.all(dPadding / 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.5),
                                boxShadow: [primaryShadow],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  Container(
                                    width: double.maxFinite,
                                    height: 150,
                                    margin: EdgeInsets.only(bottom: dPadding),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: MemoryImage(base64Decode(
                                            widget.order.products[productsOndex].image)),
                                        fit: BoxFit.fill,
                                        colorFilter: overlay,
                                      ),
                                      borderRadius: BorderRadius.circular(12.5),
                                    ),
                                  ),

                                  // Informations
                                  Padding(
                                    padding: EdgeInsets.all(dPadding / 2),
                                    child: Column(
                                      children: [
                                        // Name
                                        BootstrapHeading.h4(
                                          text: widget.order.products[productsOndex].name,
                                          color: white,
                                        ),

                                        // Price && Count
                                        Padding(
                                          padding: EdgeInsets.all(dPadding / 2),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              // Price
                                              Text(
                                                  '${widget.order.products[productsOndex].price} JD'),

                                              // Count
                                              Text(
                                                  '* ${widget.order.products[productsOndex].cartQuantity}'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                            style: TextStyle(
                              fontSize: 18,
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: dPadding),
                          Text(widget.order.progress),
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
                            style: TextStyle(
                              fontSize: 18,
                              color: white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: dPadding),
                          Text('${OrderServices.instance.price(widget.order)} JD'),
                        ],
                      ),
                    ],
                  ),
                ),

                // Admin Buttons
                if (userSnapshot.data!.role == 'Admin' && widget.order.progress != 'Done')
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                      color: danger,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12.5),
                        bottomRight: Radius.circular(12.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (widget.order.progress != 'Acepted' && widget.order.progress != 'Done')
                          Expanded(
                            child: InkWell(
                              onTap: () => OrderServices.instance.acceptOrder(widget.order),
                              borderRadius:
                                  const BorderRadius.only(bottomLeft: Radius.circular(12.5)),
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(dPadding),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: success,
                                  borderRadius: widget.order.progress != 'Acepted' &&
                                          widget.order.progress != 'Done'
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
                            onTap: () => OrderServices.instance.rejectOrder(widget.order),
                            borderRadius:
                                const BorderRadius.only(bottomRight: Radius.circular(12.5)),
                            child: Container(
                              width: double.maxFinite,
                              padding: EdgeInsets.all(dPadding),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: danger,
                                borderRadius:
                                    const BorderRadius.only(bottomRight: Radius.circular(12.5)),
                              ),
                              child: const Text('Reject'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Delete Button
                if (userSnapshot.data!.role == 'Customer' && widget.order.progress != 'Done')
                  InkWell(
                    onTap: () => OrderServices.instance.deleteOrder(widget.order),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12.5),
                      bottomRight: Radius.circular(12.5),
                    ),
                    child: Container(
                      width: double.maxFinite,
                      padding: EdgeInsets.all(dPadding),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: danger,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(12.5),
                          bottomRight: Radius.circular(12.5),
                        ),
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
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12.5),
                        bottomRight: Radius.circular(12.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (widget.order.progress == 'Acepted')
                          Expanded(
                            child: InkWell(
                              onTap: () => OrderServices.instance.doneOrder(widget.order),
                              borderRadius:
                                  const BorderRadius.only(bottomLeft: Radius.circular(12.5)),
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(dPadding),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: success,
                                  borderRadius:
                                      const BorderRadius.only(bottomLeft: Radius.circular(12.5)),
                                ),
                                child: const Text('Done'),
                              ),
                            ),
                          ),
                        if (widget.order.progress == 'Acepted' && widget.order.progress != 'Done')
                          Expanded(
                            child: InkWell(
                              onTap: () => OrderServices.instance.rejectOrder(widget.order),
                              borderRadius:
                                  const BorderRadius.only(bottomRight: Radius.circular(12.5)),
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.all(dPadding),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: danger,
                                  borderRadius:
                                      const BorderRadius.only(bottomRight: Radius.circular(12.5)),
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
        } else {
          return waitContainer();
        }
      },
    );
  }
}
