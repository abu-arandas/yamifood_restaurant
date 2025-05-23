import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<UserRole> userRole = UserRole.customer.obs;

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
      if (user != null) {
        _fetchUserRole(user.uid);
      }
    });
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> _fetchUserRole(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        final userData = doc.data() as Map<String, dynamic>;
        userRole.value = UserRole.values.firstWhere(
          (role) => role.toString() == userData['role'],
          orElse: () => UserRole.customer,
        );
        _navigateBasedOnRole();
      }
    } catch (e) {
      errorMessage.value = 'Failed to fetch user role: $e';
    }
  }

  void _navigateBasedOnRole() {
    switch (userRole.value) {
      case UserRole.admin:
        Get.offAllNamed('/admin/dashboard');
        break;
      case UserRole.driver:
        Get.offAllNamed('/driver/home');
        break;
      case UserRole.customer:
        Get.offAllNamed('/customer/home');
        break;
    }
  }

  Future<void> signIn() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        errorMessage.value = 'Please fill in all fields';
        return;
      }

      final userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        await _fetchUserRole(userCredential.user!.uid);
      }

      // Clear form
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'An error occurred during sign in';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(UserRole role) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (emailController.text.isEmpty || passwordController.text.isEmpty || nameController.text.isEmpty) {
        errorMessage.value = 'Please fill in all required fields';
        return;
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (userCredential.user != null) {
        final now = DateTime.now();
        final user = UserModel(
          id: userCredential.user!.uid,
          email: emailController.text.trim(),
          name: nameController.text.trim(),
          userRole: role,
          phoneNumber: phoneController.text.trim(),
          createdAt: now,
          updatedAt: now,
        );

        await _firestore.collection('users').doc(user.id).set(user.toMap());
        userRole.value = role;
        _navigateBasedOnRole();
      }

      // Clear form
      emailController.clear();
      passwordController.clear();
      nameController.clear();
      phoneController.clear();
      addressController.clear();
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'An error occurred during sign up';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (emailController.text.isEmpty) {
        errorMessage.value = 'Please enter your email';
        return;
      }

      await _auth.sendPasswordResetEmail(email: emailController.text.trim());
      Get.snackbar(
        'Success',
        'Password reset email sent',
        snackPosition: SnackPosition.BOTTOM,
      );
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? 'An error occurred while resetting password';
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (currentUser.value == null) {
        errorMessage.value = 'No user is currently signed in';
        return;
      }

      final userData = {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
      };

      await _firestore.collection('users').doc(currentUser.value!.uid).update(userData);

      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
