import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/customer_controller.dart';
import '../../../models/restaurant_model.dart';

class CustomerHomeController extends GetxController {
  final CustomerController _customerController = Get.find<CustomerController>();
  final RxString searchQuery = ''.obs;
  final RxString selectedCuisine = 'All'.obs;
  final RxBool showOnlyOpen = false.obs;
  final RxList<String> cuisines = <String>['All'].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isSearching = false.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 1000.0.obs;
  final RxDouble minRating = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCuisines();
    _loadRestaurants();
  }

  Future<void> _loadRestaurants() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await _customerController.fetchRestaurants();
      _loadCuisines(); // Reload cuisines after fetching restaurants
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _loadCuisines() {
    try {
      final uniqueCuisines = _customerController.restaurants.map((r) => r.cuisine).toSet().toList()..sort();
      cuisines.value = ['All', ...uniqueCuisines];
    } catch (e) {
      errorMessage.value = 'Failed to load cuisines: $e';
    }
  }

  List<RestaurantModel> get filteredRestaurants {
    return _customerController.restaurants.where((restaurant) {
      final matchesSearch = searchQuery.value.isEmpty ||
          restaurant.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          restaurant.description.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          restaurant.cuisine.toLowerCase().contains(searchQuery.value.toLowerCase());

      final matchesCuisine = selectedCuisine.value == 'All' || restaurant.cuisine == selectedCuisine.value;
      final matchesOpenStatus = !showOnlyOpen.value || restaurant.isOpen;
      final matchesPriceRange = restaurant.minOrder >= minPrice.value && restaurant.minOrder <= maxPrice.value;
      final matchesRating = restaurant.rating >= minRating.value;

      return matchesSearch && matchesCuisine && matchesOpenStatus && matchesPriceRange && matchesRating;
    }).toList();
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    isSearching.value = query.isNotEmpty;
  }

  void updateSelectedCuisine(String cuisine) {
    selectedCuisine.value = cuisine;
  }

  void toggleShowOnlyOpen() {
    showOnlyOpen.value = !showOnlyOpen.value;
  }

  void updatePriceRange(double min, double max) {
    minPrice.value = min;
    maxPrice.value = max;
  }

  void updateMinRating(double rating) {
    minRating.value = rating;
  }

  void resetFilters() {
    searchQuery.value = '';
    selectedCuisine.value = 'All';
    showOnlyOpen.value = false;
    minPrice.value = 0.0;
    maxPrice.value = 1000.0;
    minRating.value = 0.0;
    isSearching.value = false;
  }

  Future<void> refreshRestaurants() async {
    await _loadRestaurants();
  }
}

class CustomerHomeView extends StatelessWidget {
  final CustomerHomeController _controller = Get.put(CustomerHomeController());

  CustomerHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurants'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _controller.refreshRestaurants,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _controller.refreshRestaurants,
        child: Column(
          children: [
            _buildSearchBar(),
            _buildFilterChips(),
            Expanded(
              child: Obx(() {
                if (_controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (_controller.errorMessage.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          _controller.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _controller.refreshRestaurants,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                final restaurants = _controller.filteredRestaurants;
                if (restaurants.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 48, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          _controller.isSearching.value ? 'No restaurants match your search' : 'No restaurants found',
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (_controller.isSearching.value) ...[
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: _controller.resetFilters,
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear Filters'),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: restaurants.length,
                  itemBuilder: (context, index) {
                    final restaurant = restaurants[index];
                    return _buildRestaurantCard(restaurant);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: _controller.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search restaurants...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(() => _controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _controller.updateSearchQuery(''),
                )
              : const SizedBox.shrink()),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            FilterChip(
              label: const Text('Open Now'),
              selected: _controller.showOnlyOpen.value,
              onSelected: (value) => _controller.toggleShowOnlyOpen(),
              avatar: Icon(
                Icons.access_time,
                size: 16,
                color: _controller.showOnlyOpen.value ? Colors.white : Colors.grey,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(20),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _controller.selectedCuisine.value,
                  items: _controller.cuisines.map((cuisine) {
                    return DropdownMenuItem(
                      value: cuisine,
                      child: Text(cuisine),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      _controller.updateSelectedCuisine(value);
                    }
                  },
                ),
              ),
            ),
            if (_controller.isSearching.value) ...[
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Clear Filters'),
                onSelected: (_) => _controller.resetFilters(),
                avatar: const Icon(Icons.clear, size: 16),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildRestaurantCard(RestaurantModel restaurant) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => Get.toNamed('/customer/restaurant/${restaurant.id}'),
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    restaurant.coverImage,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 150,
                        color: Colors.grey[200],
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              'Failed to load image',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: restaurant.isOpen ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      restaurant.isOpen ? 'Open' : 'Closed',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.cuisine,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          restaurant.location['address'] ?? 'No address available',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${restaurant.estimatedDeliveryTime} min',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.delivery_dining, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '\$${restaurant.deliveryFee.toStringAsFixed(2)} delivery',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Restaurants'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Price Range'),
              Obx(() => RangeSlider(
                    values: RangeValues(_controller.minPrice.value, _controller.maxPrice.value),
                    min: 0,
                    max: 1000,
                    divisions: 20,
                    labels: RangeLabels(
                      '\$${_controller.minPrice.value.toStringAsFixed(0)}',
                      '\$${_controller.maxPrice.value.toStringAsFixed(0)}',
                    ),
                    onChanged: (values) {
                      _controller.updatePriceRange(values.start, values.end);
                    },
                  )),
              const SizedBox(height: 16),
              const Text('Minimum Rating'),
              Obx(() => Slider(
                    value: _controller.minRating.value,
                    min: 0,
                    max: 5,
                    divisions: 10,
                    label: _controller.minRating.value.toStringAsFixed(1),
                    onChanged: (value) {
                      _controller.updateMinRating(value);
                    },
                  )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _controller.resetFilters();
              Navigator.pop(context);
            },
            child: const Text('Reset'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
