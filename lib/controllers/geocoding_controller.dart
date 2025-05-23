import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class GeocodingController extends GetxController {
  Future<LatLng> getLatLngFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
      throw Exception('No location found for address: $address');
    } catch (e) {
      Get.snackbar('Error', 'Failed to get location from address: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get location from address: $e');
    }
  }

  Future<String> getAddressFromLatLng(LatLng latLng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );
      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.street}, ${place.locality}, ${place.administrativeArea} ${place.postalCode}';
      }
      throw Exception('No address found for coordinates: $latLng');
    } catch (e) {
      Get.snackbar('Error', 'Failed to get address from coordinates: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get address from coordinates: $e');
    }
  }
}
