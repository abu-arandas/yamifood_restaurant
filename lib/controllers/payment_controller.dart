import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/payment_method.dart';
import '../models/payment_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'payments';
  late final CollectionReference _paymentsRef;
  late final CollectionReference _paymentMethodsRef;

  final RxList<PaymentModel> payments = <PaymentModel>[].obs;
  final RxList<PaymentMethod> paymentMethods = <PaymentMethod>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isProcessing = false.obs;

  final Rx<PaymentMethod?> selectedPaymentMethod = Rx<PaymentMethod?>(null);

  // Form controllers
  final cardNumberController = TextEditingController();
  final expiryController = TextEditingController();
  final cvvController = TextEditingController();
  final cardholderNameController = TextEditingController();

  Rxn<PaymentModel> selectedPayment = Rxn<PaymentModel>();

  @override
  void onInit() {
    super.onInit();
    _paymentsRef = _firestore.collection('payments');
    _paymentMethodsRef = _firestore.collection('payment_methods');
    fetchPayments();
    fetchPaymentMethods();
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    expiryController.dispose();
    cvvController.dispose();
    cardholderNameController.dispose();
    super.onClose();
  }

  Future<void> fetchPayments() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      payments.value = snapshot.docs.map((doc) => PaymentModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch payments: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPaymentMethods() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      final QuerySnapshot snapshot = await _firestore
          .collection('payment_methods')
          .where('userId', isEqualTo: userId)
          .orderBy('isDefault', descending: true)
          .get();

      paymentMethods.value = snapshot.docs.map((doc) => PaymentMethod.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch payment methods: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<PaymentModel?> getPayment(String paymentId) async {
    try {
      final doc = await _paymentsRef.doc(paymentId).get();
      if (!doc.exists) {
        Get.snackbar('Error', 'Payment not found');
        return null;
      }
      return PaymentModel.fromFirestore(doc);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get payment: $e', snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  Future<bool> createPayment(PaymentModel payment) async {
    try {
      isProcessing.value = true;
      final docRef = await _paymentsRef.add(payment.toFirestore());
      final createdPayment = payment.copyWith(id: docRef.id);
      payments.insert(0, createdPayment);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to create payment: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<bool> updatePayment(String paymentId, PaymentModel payment) async {
    try {
      isProcessing.value = true;
      await _paymentsRef.doc(paymentId).update(payment.toFirestore());
      final index = payments.indexWhere((p) => p.id == paymentId);
      if (index != -1) {
        payments[index] = payment;
      }
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update payment: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<bool> deletePayment(String paymentId) async {
    try {
      isProcessing.value = true;
      await _paymentsRef.doc(paymentId).delete();
      payments.removeWhere((p) => p.id == paymentId);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete payment: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<bool> addPaymentMethod({
    required PaymentMethodType type,
    required String lastFourDigits,
    required String cardholderName,
    required String expiryMonth,
    required String expiryYear,
    bool isDefault = false,
  }) async {
    try {
      isProcessing.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'User not authenticated');
        return false;
      }

      final method = PaymentMethod(
        id: '',
        userId: userId,
        type: type,
        lastFourDigits: lastFourDigits,
        cardholderName: cardholderName,
        expiryMonth: expiryMonth,
        expiryYear: expiryYear,
        isDefault: isDefault,
        createdAt: DateTime.now(),
      );

      // If this is the first payment method or marked as default, update other methods
      if (method.isDefault) {
        final batch = _firestore.batch();
        final existingMethods =
            await _paymentMethodsRef.where('userId', isEqualTo: userId).where('isDefault', isEqualTo: true).get();

        for (var doc in existingMethods.docs) {
          batch.update(doc.reference, {'isDefault': false});
        }
        await batch.commit();
      }

      final docRef = await _paymentMethodsRef.add(method.toFirestore());
      final createdMethod = method.copyWith(id: docRef.id);
      paymentMethods.add(createdMethod);
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add payment method: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<bool> updatePaymentMethod(String methodId, PaymentMethod method) async {
    try {
      isProcessing.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'User not authenticated');
        return false;
      }

      // If setting as default, update other methods
      if (method.isDefault) {
        final batch = _firestore.batch();
        final existingMethods =
            await _paymentMethodsRef.where('userId', isEqualTo: userId).where('isDefault', isEqualTo: true).get();

        for (var doc in existingMethods.docs) {
          if (doc.id != methodId) {
            batch.update(doc.reference, {'isDefault': false});
          }
        }
        await batch.commit();
      }

      await _paymentMethodsRef.doc(methodId).update(method.toFirestore());
      final index = paymentMethods.indexWhere((m) => m.id == methodId);
      if (index != -1) {
        paymentMethods[index] = method;
      }
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update payment method: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<bool> removePaymentMethod(String methodId) async {
    try {
      isProcessing.value = true;
      await _paymentMethodsRef.doc(methodId).delete();
      paymentMethods.removeWhere((m) => m.id == methodId);
      if (selectedPaymentMethod.value?.id == methodId) {
        selectedPaymentMethod.value = paymentMethods.isNotEmpty ? paymentMethods.first : null;
      }
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete payment method: $e', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isProcessing.value = false;
    }
  }

  Future<PaymentMethod?> getDefaultPaymentMethod() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'User not authenticated');
        return null;
      }

      final QuerySnapshot snapshot = await _firestore
          .collection('payment_methods')
          .where('userId', isEqualTo: userId)
          .where('isDefault', isEqualTo: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        return null;
      }

      return PaymentMethod.fromFirestore(snapshot.docs.first);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get default payment method: $e', snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  void selectPaymentMethod(PaymentMethod method) {
    selectedPaymentMethod.value = method;
  }

  Future<void> processPayment({
    required String orderId,
    required double amount,
    required String currency,
    Map<String, dynamic>? paymentDetails,
  }) async {
    try {
      isProcessing.value = true;
      if (selectedPaymentMethod.value == null) {
        Get.snackbar('Error', 'Please select a payment method');
        return;
      }

      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        Get.snackbar('Error', 'User not authenticated');
        return;
      }

      final payment = PaymentModel(
        id: '',
        userId: userId,
        orderId: orderId,
        amount: amount,
        currency: currency,
        status: PaymentStatus.pending,
        paymentMethod: selectedPaymentMethod.value!.id,
        paymentDetails: paymentDetails ?? {},
        createdAt: DateTime.now(),
      );

      // Create the payment record
      final success = await createPayment(payment);
      if (!success) {
        Get.snackbar('Error', 'Failed to process payment');
        return;
      }

      Get.snackbar('Success', 'Payment processed successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to process payment: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isProcessing.value = false;
    }
  }

  Future<void> refundPayment(PaymentModel payment) async {
    try {
      isLoading.value = true;
      // TODO: Implement refund logic
      await updatePayment(
        payment.id,
        payment.copyWith(
          status: PaymentStatus.refunded,
          updatedAt: DateTime.now(),
        ),
      );
      await fetchPayments();
      Get.snackbar('Success', 'Payment refunded successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to refund payment: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<PaymentModel>> getCustomerPayments() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => PaymentModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get customer payments: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get customer payments: $e');
    }
  }

  Future<List<PaymentModel>> getRestaurantPayments() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('restaurantId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => PaymentModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get restaurant payments: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get restaurant payments: $e');
    }
  }

  Future<List<PaymentModel>> getDriverPayments() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('driverId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => PaymentModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get driver payments: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get driver payments: $e');
    }
  }

  Future<List<PaymentModel>> getAdminPayments() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final QuerySnapshot snapshot =
          await _firestore.collection(_collection).orderBy('createdAt', descending: true).get();

      return snapshot.docs.map((doc) => PaymentModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get admin payments: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get admin payments: $e');
    }
  }

  Stream<List<PaymentModel>> streamCustomerPayments() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return _firestore
        .collection(_collection)
        .where('customerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => PaymentModel.fromFirestore(doc)).toList());
  }

  Stream<List<PaymentModel>> streamRestaurantPayments() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return _firestore
        .collection(_collection)
        .where('restaurantId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => PaymentModel.fromFirestore(doc)).toList());
  }
}
