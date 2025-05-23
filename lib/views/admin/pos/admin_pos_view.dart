import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/pos_controller.dart';
import '../../../controllers/menu_controller.dart' as menu;
import '../../../models/menu_item_model.dart';
import '../../../models/cart_item_model.dart';
import '../orders/admin_orders_view.dart';

class AdminPosView extends StatelessWidget {
  final POSController _posController = Get.find<POSController>();
  final menu.MenuController _menuController = Get.find<menu.MenuController>();
  final RxString _searchQuery = ''.obs;
  final RxList<String> _selectedCategories = <String>[].obs;

  AdminPosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('POS System'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Get.to(() => AdminOrdersView()),
          ),
        ],
      ),
      body: Row(
        children: [
          // Menu Items Section
          Expanded(
            flex: 2,
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search menu items...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: Obx(
                        () => _searchQuery.value.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchQuery.value = '';
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                    ),
                    onChanged: (value) {
                      _searchQuery.value = value;
                    },
                  ),
                ),
                // Categories
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _menuController.menus.length,
                    itemBuilder: (context, index) {
                      final category = _menuController.menus[index];
                      return Obx(() => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FilterChip(
                              label: Text(category.name),
                              selected: _selectedCategories.contains(category.name),
                              onSelected: (selected) {
                                if (selected) {
                                  _selectedCategories.add(category.name);
                                } else {
                                  _selectedCategories.remove(category.name);
                                }
                              },
                              selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
                            ),
                          ));
                    },
                  ),
                ),
                // Menu Items Grid
                Expanded(
                  child: Obx(() {
                    if (_menuController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    // Filter items based on search query and selected categories
                    final filteredItems = _menuController.menus.where((item) {
                      // First check if the item matches the search query
                      final matchesSearch = _searchQuery.value.isEmpty ||
                          item.name.toLowerCase().contains(_searchQuery.value.toLowerCase()) ||
                          item.description.toLowerCase().contains(_searchQuery.value.toLowerCase());

                      // Then check if the item belongs to any selected category
                      final matchesCategory = _selectedCategories.isEmpty ||
                          item.categories.any((category) => _selectedCategories.contains(category));

                      return matchesSearch && matchesCategory;
                    }).toList();

                    if (filteredItems.isEmpty) {
                      return const Center(
                        child: Text('No items found matching your criteria'),
                      );
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = filteredItems[index];
                        return _buildMenuItemCard(item);
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          // Current Order Section
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(
                  left: BorderSide(
                    color: Colors.grey[300]!,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: [
                  // Order Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200]!,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Current Order',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () => _posController.clearOrder(),
                          icon: const Icon(Icons.clear_all),
                          label: const Text('Clear'),
                        ),
                      ],
                    ),
                  ),
                  // Order Items
                  Expanded(
                    child: Obx(() {
                      final order = _posController.currentOrder.value;
                      if (order.items.isEmpty) {
                        return const Center(
                          child: Text('No items in order'),
                        );
                      }
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: order.items.length,
                        itemBuilder: (context, index) {
                          final item = order.items[index];
                          return _buildOrderItemCard(item);
                        },
                      );
                    }),
                  ),
                  // Order Summary
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[200]!,
                          blurRadius: 4,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Obx(() {
                          final order = _posController.currentOrder.value;
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${order.total.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _posController.checkout(),
                            child: const Text('Checkout'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItemCard(MenuItemModel item) {
    return Card(
      child: InkWell(
        onTap: () => _posController.addItemToOrder(item),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                item.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItemCard(CartItemModel item) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '\$${item.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () => _posController.decrementItem(item),
                ),
                Text(
                  item.quantity.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _posController.incrementItem(item),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _posController.removeItem(item),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
