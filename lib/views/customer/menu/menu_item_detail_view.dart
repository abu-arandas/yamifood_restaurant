import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/menu_item_model.dart';
import '../../../controllers/cart_controller.dart';
import '../../../models/cart_item_model.dart';
import '../../../controllers/restaurant_controller.dart';

class MenuItemDetailController extends GetxController {
  final RxBool isAdding = false.obs;
  final RxInt quantity = 1.obs;
  final RxString errorMessage = ''.obs;
  final RxList<String> selectedOptions = <String>[].obs;
  final RxString specialInstructions = ''.obs;

  void incrementQuantity() {
    if (quantity.value < 99) quantity.value++;
  }

  void decrementQuantity() {
    if (quantity.value > 1) quantity.value--;
  }

  void toggleOption(String option) {
    if (selectedOptions.contains(option)) {
      selectedOptions.remove(option);
    } else {
      selectedOptions.add(option);
    }
  }

  void updateSpecialInstructions(String instructions) {
    specialInstructions.value = instructions;
  }

  void reset() {
    quantity.value = 1;
    selectedOptions.clear();
    specialInstructions.value = '';
    errorMessage.value = '';
  }
}

class MenuItemDetailView extends StatelessWidget {
  final MenuItemModel menuItem;
  final CartController _cartController = Get.find<CartController>();
  final MenuItemDetailController _controller = Get.put(MenuItemDetailController());

  MenuItemDetailView({Key? key, required this.menuItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RestaurantController restaurantController = Get.find<RestaurantController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          _buildContent(restaurantController),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(restaurantController),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (menuItem.imageUrl.isNotEmpty)
              Image.network(
                menuItem.imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Loading image...',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 40, color: Colors.red),
                        const SizedBox(height: 8),
                        Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Please try again later',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  );
                },
              )
            else
              Container(
                color: Colors.grey[300],
                child: const Icon(Icons.fastfood, size: 50),
              ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(RestaurantController restaurantController) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    menuItem.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (menuItem.isSpicy || menuItem.isVegetarian || menuItem.isVegan)
                  Wrap(
                    spacing: 8,
                    children: [
                      if (menuItem.isSpicy)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.red[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_fire_department, size: 16, color: Colors.red[700]),
                              const SizedBox(width: 4),
                              Text(
                                'Spicy',
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (menuItem.isVegetarian)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.eco, size: 16, color: Colors.green[700]),
                              const SizedBox(width: 4),
                              Text(
                                'Vegetarian',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (menuItem.isVegan)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.eco, size: 16, color: Colors.green[700]),
                              const SizedBox(width: 4),
                              Text(
                                'Vegan',
                                style: TextStyle(
                                  color: Colors.green[700],
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${menuItem.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              menuItem.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            if (menuItem.categories.isNotEmpty) ...[
              const Text(
                'Categories',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: menuItem.categories.map((category) => Chip(label: Text(category))).toList(),
              ),
              const SizedBox(height: 16),
            ],
            if (menuItem.ingredients.isNotEmpty) ...[
              const Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: menuItem.ingredients.map((ingredient) => Chip(label: Text(ingredient))).toList(),
              ),
              const SizedBox(height: 16),
            ],
            if (menuItem.nutritionalInfo.isNotEmpty) ...[
              const Text(
                'Nutritional Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: menuItem.nutritionalInfo.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  entry.key,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Text(
                                  entry.value.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ],
            if (menuItem.hasOptions) ...[
              const SizedBox(height: 16),
              const Text(
                'Options',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Obx(() => Column(
                    children: menuItem.options!.map((option) {
                      return Card(
                        child: CheckboxListTile(
                          title: Text(option.name),
                          subtitle: option.price > 0 ? Text('+\$${option.price.toStringAsFixed(2)}') : null,
                          value: _controller.selectedOptions.contains(option.name),
                          onChanged: (bool? value) {
                            if (value == true) {
                              _controller.toggleOption(option.name);
                            } else {
                              _controller.selectedOptions.remove(option.name);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  )),
            ],
            const SizedBox(height: 16),
            const Text(
              'Special Instructions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: _controller.updateSpecialInstructions,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add any special instructions or preferences...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(RestaurantController restaurantController) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: _controller.decrementQuantity,
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Text(
                      '${_controller.quantity.value}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: _controller.incrementQuantity,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                )),
            const SizedBox(height: 8),
            Obx(() {
              if (_controller.errorMessage.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    _controller.errorMessage.value,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            Obx(() => ElevatedButton(
                  onPressed: _controller.isAdding.value
                      ? null
                      : () async {
                          _controller.isAdding.value = true;
                          _controller.errorMessage.value = '';
                          try {
                            final restaurant = await restaurantController.getRestaurant(menuItem.restaurantId);
                            final cartItem = CartItemModel(
                              id: menuItem.id,
                              name: menuItem.name,
                              imageUrl: menuItem.imageUrl,
                              price: menuItem.price,
                              quantity: _controller.quantity.value,
                              restaurantId: menuItem.restaurantId,
                              restaurantName: restaurant.name,
                              options: _controller.selectedOptions,
                              specialInstructions: _controller.specialInstructions.value,
                            );
                            await _cartController.addToCart(cartItem);
                            Get.back();
                            Get.snackbar(
                              'Success',
                              'Added to cart',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } catch (e) {
                            _controller.errorMessage.value = 'Failed to add to cart: ${e.toString()}';
                          } finally {
                            _controller.isAdding.value = false;
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: _controller.isAdding.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Add to Cart',
                          style: TextStyle(fontSize: 16),
                        ),
                )),
          ],
        ),
      ),
    );
  }
}
