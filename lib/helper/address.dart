// ignore_for_file: prefer_collection_literals

import '/exports.dart';

class AddressServices extends GetxController {
  static AddressServices instance = Get.find();

  @override
  void onInit() {
    super.onInit();

    permission();
  }

  /* ====== Permission ====== */
  permission() async {
    bool serviceEnabled;
    LocationPermission permissionGranted;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
    }

    permissionGranted = await Geolocator.checkPermission();
    if (permissionGranted != LocationPermission.whileInUse ||
        permissionGranted != LocationPermission.always) {
      permissionGranted = await Geolocator.checkPermission();
    }
  }

  /* ====== Update ====== */
  updateAddress(LatLng? address) {
    Completer<GoogleMapController> mapController = Completer();

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return BootstrapModal(
          dismissble: true,
          title: 'Chose your Address',
          content: SizedBox(
            height: 300,
            child: GoogleMap(
              onMapCreated: (controller) {
                if (!mapController.isCompleted) {
                  mapController.complete(controller);
                }
                Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
                    .then((position) => address = LatLng(position.latitude, position.longitude));
              },
              onCameraMove: (position) =>
                  address = LatLng(position.target.latitude, position.target.longitude),
              initialCameraPosition: CameraPosition(
                target: address ?? LatLng(App.address['latitude'], App.address['longitude']),
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
                  position: address ?? LatLng(App.address['latitude'], App.address['longitude']),
                ),
              },
            ),
          ),
          actions: [
            BootstrapButton(
              onPressed: () async => await usersCollection
                  .doc(auth.currentUser!.email!)
                  .update({'address': GeoPoint(address!.latitude, address!.longitude)}),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  /* ====== Driver ====== */
  driverAddress() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((position) =>
        usersCollection
            .doc(auth.currentUser!.email)
            .update({'address': GeoPoint(position.latitude, position.longitude)}));
  }

  /* ====== Name ====== */
  Future<String> locationAddress(double latitude, double longitude) async {
    List<Placemark> newPlace = await placemarkFromCoordinates(latitude, longitude);
    return newPlace[0].street!;
  }

  /* ====== Distance ====== */
  double calculateDistance(LatLng first, LatLng second) =>
      Geolocator.distanceBetween(
          first.latitude, first.longitude, second.latitude, second.longitude) /
      1000;
}
