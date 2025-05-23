import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/delivery_model.dart';

class DeliveryController extends GetxController {
  final CollectionReference _deliveriesRef = FirebaseFirestore.instance.collection('deliveries');

  RxList<DeliveryModel> deliveries = <DeliveryModel>[].obs;
  Rxn<DeliveryModel> selectedDelivery = Rxn<DeliveryModel>();
  RxBool isLoading = false.obs;

  Future<void> fetchDeliveriesByDriver(String driverId) async {
    try {
      isLoading.value = true;
      final query = await _deliveriesRef.where('driverId', isEqualTo: driverId).get();
      deliveries.value = query.docs.map((doc) => DeliveryModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch deliveries: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDeliveryById(String id) async {
    try {
      isLoading.value = true;
      final doc = await _deliveriesRef.doc(id).get();
      if (doc.exists) {
        selectedDelivery.value = DeliveryModel.fromFirestore(doc);
      } else {
        selectedDelivery.value = null;
        Get.snackbar(
          'Not Found',
          'Delivery not found',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch delivery: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createDelivery(DeliveryModel delivery) async {
    try {
      isLoading.value = true;
      await _deliveriesRef.doc(delivery.id).set(delivery.toFirestore());
      await fetchDeliveriesByDriver(delivery.driverId);
      Get.snackbar(
        'Success',
        'Delivery created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create delivery: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDelivery(DeliveryModel delivery) async {
    try {
      isLoading.value = true;
      await _deliveriesRef.doc(delivery.id).update(delivery.toFirestore());
      await fetchDeliveriesByDriver(delivery.driverId);
      Get.snackbar(
        'Success',
        'Delivery updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update delivery: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteDelivery(String id, String driverId) async {
    try {
      isLoading.value = true;
      await _deliveriesRef.doc(id).delete();
      await fetchDeliveriesByDriver(driverId);
      Get.snackbar(
        'Success',
        'Delivery deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete delivery: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
