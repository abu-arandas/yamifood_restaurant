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
    MapController mapController = MapController();
    LatLng newAddress =
        address ?? LatLng(App.address['latitude'], App.address['longitude']);

    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) =>
            address = LatLng(position.latitude, position.longitude))
        .then((value) => null);

    showDialog(
      context: Get.context!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Chose your Address'),
        content: SizedBox(
          height: 300,
          child: FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: newAddress,
              initialZoom: 15,
              onMapEvent: (event) {
                newAddress = event.camera.center;
                mapController.move(event.camera.center, 15);

                update();
              },
              onTap: (tapPosition, point) {
                newAddress = point;
                mapController.move(point, 15);

                update();
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.arandas.yamifood_restaurant',
              ),
              MarkerLayer(markers: [
                Marker(
                    point: newAddress,
                    child: const Icon(Icons.location_pin, color: Colors.red))
              ]),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async =>
                await usersCollection.doc(auth.currentUser!.email!).update(
              {'address': GeoPoint(address!.latitude, address!.longitude)},
            ),
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  /* ====== Driver ====== */
  driverAddress() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then(
        (position) => usersCollection.doc(auth.currentUser!.email).update(
            {'address': GeoPoint(position.latitude, position.longitude)}));
  }

  /* ====== Distance ====== */
  double calculateDistance(LatLng first, LatLng second) =>
      Geolocator.distanceBetween(
          first.latitude, first.longitude, second.latitude, second.longitude) /
      1000;
}
