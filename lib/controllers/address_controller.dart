import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/address_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'addresses';

  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);
  final RxBool isLoading = false.obs;

  // Form controllers
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  @override
  void onClose() {
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    super.onClose();
  }

  Future<void> loadAddresses() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('isDefault', descending: true)
          .get();

      addresses.value = snapshot.docs.map((doc) => AddressModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load addresses: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
  }

  Future<void> addAddress(AddressModel address) async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      if (address.isDefault) {
        // Update all other addresses to not be default
        final batch = _firestore.batch();
        final addresses = await _firestore
            .collection(_collection)
            .where('userId', isEqualTo: userId)
            .where('isDefault', isEqualTo: true)
            .get();

        for (var doc in addresses.docs) {
          batch.update(doc.reference, {'isDefault': false});
        }
        await batch.commit();
      }

      await _firestore.collection(_collection).add(address.toFirestore());
      await loadAddresses();
      Get.snackbar('Success', 'Address added successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add address: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAddress(AddressModel address) async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      if (address.isDefault) {
        // Update all other addresses to not be default
        final batch = _firestore.batch();
        final addresses = await _firestore
            .collection(_collection)
            .where('userId', isEqualTo: userId)
            .where('isDefault', isEqualTo: true)
            .get();

        for (var doc in addresses.docs) {
          if (doc.id != address.id) {
            batch.update(doc.reference, {'isDefault': false});
          }
        }
        await batch.commit();
      }

      await _firestore.collection(_collection).doc(address.id).update(address.toFirestore());
      await loadAddresses();
      Get.snackbar('Success', 'Address updated successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteAddress(String addressId) async {
    try {
      isLoading.value = true;
      await _firestore.collection(_collection).doc(addressId).delete();
      await loadAddresses();
      Get.snackbar('Success', 'Address deleted successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete address: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      // Update all addresses to not be default
      final batch = _firestore.batch();
      final addresses = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .get();

      for (var doc in addresses.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }

      // Set the selected address as default
      batch.update(_firestore.collection(_collection).doc(addressId), {'isDefault': true});
      await batch.commit();

      await loadAddresses();
      Get.snackbar('Success', 'Default address updated successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update default address: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
