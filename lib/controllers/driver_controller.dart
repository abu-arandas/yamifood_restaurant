import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/driver_model.dart';

enum DriverStatus {
  offline,
  available,
  busy,
  delivering,
}

class DriverController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'drivers';
  final String _ordersCollection = 'orders';
  final Rx<DriverStatus> currentStatus = DriverStatus.offline.obs;
  final Rx<Position?> currentLocation = Rx<Position?>(null);
  final Rx<Set<Marker>> markers = Rx<Set<Marker>>({});
  final Rx<Set<Polyline>> polylines = Rx<Set<Polyline>>({});
  final Rx<OrderModel?> currentOrder = Rx<OrderModel?>(null);
  final RxBool isLoading = false.obs;
  final RxList<OrderModel> deliveryHistory = <OrderModel>[].obs;
  GoogleMapController? mapController;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final Rx<DriverModel?> profile = Rx<DriverModel?>(null);

  @override
  void onInit() {
    super.onInit();
    _initializeLocation();
    _loadDeliveryHistory();
    loadProfile();
    loadOrders();
  }

  Future<void> _initializeLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestPermission = await Geolocator.requestPermission();
        if (requestPermission == LocationPermission.denied) {
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      currentLocation.value = position;
      _updateCurrentLocationMarker();
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize location: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _updateCurrentLocationMarker();
  }

  void _updateCurrentLocationMarker() {
    if (currentLocation.value != null) {
      final marker = Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(
          currentLocation.value!.latitude,
          currentLocation.value!.longitude,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      );
      markers.value = {marker};
    }
  }

  Future<void> startShift() async {
    try {
      isLoading.value = true;
      await updateDriverStatus(DriverStatus.available);
      currentStatus.value = DriverStatus.available;
    } catch (e) {
      Get.snackbar('Error', 'Failed to start shift: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> acceptOrder(OrderModel order) async {
    try {
      isLoading.value = true;
      currentOrder.value = order;
      currentStatus.value = DriverStatus.delivering;
      _updateOrderMarkers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to accept order: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeDelivery() async {
    try {
      isLoading.value = true;
      if (currentOrder.value != null) {
        await completeOrder(currentOrder.value!.id);
        deliveryHistory.add(currentOrder.value!);
        currentOrder.value = null;
        currentStatus.value = DriverStatus.available;
        markers.value = {};
        polylines.value = {};
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete delivery: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void _updateOrderMarkers() {
    if (currentOrder.value != null) {
      final restaurantMarker = Marker(
        markerId: const MarkerId('restaurant'),
        position: LatLng(
          currentOrder.value!.restaurantLocation['latitude'],
          currentOrder.value!.restaurantLocation['longitude'],
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );

      final deliveryMarker = Marker(
        markerId: const MarkerId('delivery'),
        position: currentOrder.value!.deliveryAddress,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );

      markers.value = {restaurantMarker, deliveryMarker};
      _updateRoutePolyline();
    }
  }

  void _updateRoutePolyline() {
    if (currentOrder.value != null && currentLocation.value != null) {
      final polyline = Polyline(
        polylineId: const PolylineId('delivery_route'),
        points: [
          LatLng(
            currentLocation.value!.latitude,
            currentLocation.value!.longitude,
          ),
          LatLng(
            currentOrder.value!.restaurantLocation['latitude'],
            currentOrder.value!.restaurantLocation['longitude'],
          ),
          currentOrder.value!.deliveryAddress
        ],
        color: Colors.blue,
        width: 3,
      );

      polylines.value = {polyline};
    }
  }

  Future<void> _loadDeliveryHistory() async {
    try {
      isLoading.value = true;
      final history = await getDeliveryHistory();
      deliveryHistory.value = history;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load delivery history: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<OrderModel?> getNextOrder() async {
    try {
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('status', isEqualTo: 'ready')
          .where('driverId', isNull: true)
          .orderBy('createdAt')
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return null;
      }

      final doc = querySnapshot.docs.first;
      final order = OrderModel.fromFirestore(doc);

      // Assign order to driver
      await doc.reference.update({
        'driverId': driverId,
        'status': 'on_the_way',
        'updatedAt': FieldValue.serverTimestamp(),
      });

      return order;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get next order: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get next order: $e');
    }
  }

  Future<void> updateDriverStatus(DriverStatus status) async {
    try {
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      await _firestore.collection(_collection).doc(driverId).update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update driver status: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to update driver status: $e');
    }
  }

  Future<void> completeOrder(String orderId) async {
    try {
      isLoading.value = true;
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      await _firestore.collection('orders').doc(orderId).update({
        'status': 'completed',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await loadOrders();
      Get.snackbar('Success', 'Order completed successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete order: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    try {
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      await _firestore.collection(_collection).doc(driverId).update({
        'location': GeoPoint(latitude, longitude),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to update location: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<List<OrderModel>> getDeliveryHistory() async {
    try {
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      final querySnapshot = await _firestore
          .collection(_ordersCollection)
          .where('driverId', isEqualTo: driverId)
          .where('status', whereIn: ['delivered', 'cancelled'])
          .orderBy('updatedAt', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get delivery history: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get delivery history: $e');
    }
  }

  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      final DocumentSnapshot doc = await _firestore.collection(_collection).doc(driverId).get();
      if (doc.exists) {
        profile.value = DriverModel.fromFirestore(doc);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      final QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('driverId', isEqualTo: driverId)
          .orderBy('createdAt', descending: true)
          .get();

      orders.value = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(DriverModel driver) async {
    try {
      isLoading.value = true;
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      await _firestore.collection(_collection).doc(driverId).update(driver.toMap());
      profile.value = driver;
      Get.snackbar('Success', 'Profile updated successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAvailability(bool isAvailable) async {
    try {
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      await _firestore.collection(_collection).doc(driverId).update({
        'isAvailable': isAvailable,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      if (profile.value != null) {
        profile.value = profile.value!.copyWith(isAvailable: isAvailable);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update availability: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Filter the delivery history based on time period and status
  Future<void> filterDeliveryHistory({required DateTime startDate, String? status}) async {
    try {
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      // Build query
      Query query = _firestore.collection(_ordersCollection).where('driverId', isEqualTo: driverId);

      // Add status filter if provided
      if (status != null && status != 'All') {
        status = status.toLowerCase();
        query = query.where('status', isEqualTo: status);
      } else {
        query = query.where('status', whereIn: ['delivered', 'cancelled', 'completed']);
      }

      // Add time filter
      query = query
          .where('updatedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
          .orderBy('updatedAt', descending: true);

      final querySnapshot = await query.get();

      deliveryHistory.value = querySnapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to filter delivery history: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
