import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item_model.dart';

class MenuController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'menus';
  final RxList<MenuItemModel> menus = <MenuItemModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<List<MenuItemModel>> getMenus() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) => MenuItemModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get menus: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get menus: $e');
    }
  }

  Future<MenuItemModel> getMenu(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        throw Exception('Menu not found');
      }
      return MenuItemModel.fromFirestore(doc);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get menu: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get menu: $e');
    }
  }

  Future<void> updateMenu(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(id).update(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update menu: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to update menu: $e');
    }
  }

  Future<void> deleteMenu(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete menu: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to delete menu: $e');
    }
  }

  Future<void> createMenu(MenuItemModel menu) async {
    try {
      await _firestore.collection(_collection).add(menu.toFirestore());
    } catch (e) {
      Get.snackbar('Error', 'Failed to create menu: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to create menu: $e');
    }
  }

  Future<void> fetchMenus() async {
    try {
      isLoading.value = true;
      final menuList = await getMenus();
      menus.value = menuList;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch menus: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMenuById(String id) async {
    try {
      isLoading.value = true;
      final menu = await getMenu(id);
      menus.value = [menu];
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch menu: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createNewMenu(MenuItemModel menu) async {
    try {
      isLoading.value = true;
      await createMenu(menu);
      await fetchMenus();
      Get.snackbar('Success', 'Menu created successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create menu: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateExistingMenu(MenuItemModel menu) async {
    try {
      isLoading.value = true;
      await updateMenu(menu.id, menu.toFirestore());
      await fetchMenus();
      Get.snackbar('Success', 'Menu updated successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update menu: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteExistingMenu(String id) async {
    try {
      isLoading.value = true;
      await deleteMenu(id);
      await fetchMenus();
      Get.snackbar('Success', 'Menu deleted successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete menu: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
