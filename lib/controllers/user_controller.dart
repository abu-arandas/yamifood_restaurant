import 'package:get/get.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference usersRef;

  Rxn<UserModel> currentUser = Rxn<UserModel>();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    usersRef = _firestore.collection('users');
  }

  Future<void> fetchUser(String userId) async {
    isLoading.value = true;
    currentUser.value = await getUserById(userId);
    isLoading.value = false;
  }

  Future<UserModel?> getUserById(String userId) async {
    try {
      final doc = await usersRef.doc(userId).get();
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get user: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await usersRef.doc(user.id).update(user.toMap());
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> createUser(UserModel user) async {
    try {
      await usersRef.doc(user.id).set(user.toMap());
    } catch (e) {
      Get.snackbar('Error', 'Failed to create user: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await usersRef.doc(userId).delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to delete user: $e');
    }
  }
}
