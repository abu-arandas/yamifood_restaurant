import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _auth.currentUser;
    _auth.authStateChanges().listen((User? user) {
      currentUser.value = user;
    });
  }

  Future<UserModel?> getCurrentUser() async {
    if (currentUser.value == null) return null;
    try {
      final doc = await _firestore.collection('users').doc(currentUser.value!.uid).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get current user: $e', snackPosition: SnackPosition.BOTTOM);
      return null;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> signUp(String email, String password, String name, UserRole role) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        userRole: role,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(user.id).set(user.toMap());
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign up: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      Get.snackbar('Error', 'Failed to reset password: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }
}
