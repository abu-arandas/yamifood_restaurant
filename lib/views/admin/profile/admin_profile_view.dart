import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/restaurant_controller.dart';
import '../../../models/restaurant_model.dart';

class AdminProfileController extends GetxController {
  final RestaurantController _restaurantController = Get.find<RestaurantController>();
  final RxBool isSaving = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool showImagePreview = false.obs;
  final RxString previewImageUrl = ''.obs;

  void showPreview(String imageUrl) {
    previewImageUrl.value = imageUrl;
    showImagePreview.value = true;
  }

  void hidePreview() {
    showImagePreview.value = false;
  }

  Future<void> updateRestaurant(RestaurantModel updatedRestaurant) async {
    try {
      isSaving.value = true;
      errorMessage.value = '';

      // Validate required fields
      if (updatedRestaurant.name.isEmpty) {
        throw 'Restaurant name is required';
      }
      if (updatedRestaurant.description.isEmpty) {
        throw 'Description is required';
      }
      if (updatedRestaurant.cuisine.isEmpty) {
        throw 'Cuisine is required';
      }
      if (updatedRestaurant.location['address']?.isEmpty ?? true) {
        throw 'Address is required';
      }
      if (updatedRestaurant.location['city']?.isEmpty ?? true) {
        throw 'City is required';
      }
      if (updatedRestaurant.location['state']?.isEmpty ?? true) {
        throw 'State is required';
      }
      if (updatedRestaurant.location['zipCode']?.isEmpty ?? true) {
        throw 'Zip code is required';
      }

      await _restaurantController.updateRestaurant(updatedRestaurant);
      Get.snackbar(
        'Success',
        'Restaurant updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSaving.value = false;
    }
  }
}

class AdminProfileView extends StatelessWidget {
  final RestaurantController _restaurantController = Get.find<RestaurantController>();
  final AdminProfileController _profileController = Get.put(AdminProfileController());

  AdminProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Settings'),
      ),
      body: Obx(() {
        if (_restaurantController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final restaurant = _restaurantController.restaurant.value;
        if (restaurant == null) {
          return const Center(
            child: Text('Restaurant information not found'),
          );
        }

        return Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_profileController.errorMessage.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.all(8),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.red),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _profileController.errorMessage.value,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                  _buildSection(
                    title: 'Basic Information',
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Restaurant Name',
                          value: restaurant.name,
                          onChanged: (value) => _profileController.updateRestaurant(
                            restaurant.copyWith(name: value),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Description',
                          value: restaurant.description,
                          maxLines: 3,
                          onChanged: (value) => _profileController.updateRestaurant(
                            restaurant.copyWith(description: value),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Cuisine',
                          value: restaurant.cuisine,
                          onChanged: (value) => _profileController.updateRestaurant(
                            restaurant.copyWith(cuisine: value),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Images',
                    child: Column(
                      children: [
                        _buildImageField(
                          label: 'Profile Image URL',
                          value: restaurant.imageUrl,
                          onChanged: (value) => _profileController.updateRestaurant(
                            restaurant.copyWith(imageUrl: value),
                          ),
                          onPreview: () => _profileController.showPreview(restaurant.imageUrl),
                        ),
                        const SizedBox(height: 16),
                        _buildImageField(
                          label: 'Cover Image URL',
                          value: restaurant.coverImage,
                          onChanged: (value) => _profileController.updateRestaurant(
                            restaurant.copyWith(coverImage: value),
                          ),
                          onPreview: () => _profileController.showPreview(restaurant.coverImage),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Delivery Settings',
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Estimated Delivery Time (minutes)',
                          value: restaurant.estimatedDeliveryTime.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => _updateRestaurant(
                            restaurant.copyWith(
                              estimatedDeliveryTime: int.tryParse(value) ?? 30,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Delivery Fee',
                          value: restaurant.deliveryFee.toString(),
                          keyboardType: TextInputType.number,
                          prefixText: '\$',
                          onChanged: (value) => _updateRestaurant(
                            restaurant.copyWith(
                              deliveryFee: double.tryParse(value) ?? 0.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Minimum Order',
                          value: restaurant.minOrder.toString(),
                          keyboardType: TextInputType.number,
                          prefixText: '\$',
                          onChanged: (value) => _updateRestaurant(
                            restaurant.copyWith(
                              minOrder: double.tryParse(value) ?? 0.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Location',
                    child: Column(
                      children: [
                        _buildTextField(
                          label: 'Address',
                          value: restaurant.location['address'] ?? '',
                          onChanged: (value) {
                            final updatedLocation = Map<String, dynamic>.from(restaurant.location);
                            updatedLocation['address'] = value;
                            _profileController.updateRestaurant(
                              restaurant.copyWith(location: updatedLocation),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'City',
                          value: restaurant.location['city'] ?? '',
                          onChanged: (value) {
                            final updatedLocation = Map<String, dynamic>.from(restaurant.location);
                            updatedLocation['city'] = value;
                            _profileController.updateRestaurant(
                              restaurant.copyWith(location: updatedLocation),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'State',
                          value: restaurant.location['state'] ?? '',
                          onChanged: (value) {
                            final updatedLocation = Map<String, dynamic>.from(restaurant.location);
                            updatedLocation['state'] = value;
                            _profileController.updateRestaurant(
                              restaurant.copyWith(location: updatedLocation),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          label: 'Zip Code',
                          value: restaurant.location['zipCode'] ?? '',
                          onChanged: (value) {
                            final updatedLocation = Map<String, dynamic>.from(restaurant.location);
                            updatedLocation['zipCode'] = value;
                            _profileController.updateRestaurant(
                              restaurant.copyWith(location: updatedLocation),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    title: 'Business Hours',
                    child: Column(
                      children: [
                        _buildTimeRangeField(
                          label: 'Monday',
                          startTime: restaurant.openingHours?['monday']?['open'],
                          endTime: restaurant.openingHours?['monday']?['close'],
                          onChanged: (start, end) => _updateRestaurantHours(
                            restaurant,
                            'monday',
                            start,
                            end,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimeRangeField(
                          label: 'Tuesday',
                          startTime: restaurant.openingHours?['tuesday']?['open'],
                          endTime: restaurant.openingHours?['tuesday']?['close'],
                          onChanged: (start, end) => _updateRestaurantHours(
                            restaurant,
                            'tuesday',
                            start,
                            end,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimeRangeField(
                          label: 'Wednesday',
                          startTime: restaurant.openingHours?['wednesday']?['open'],
                          endTime: restaurant.openingHours?['wednesday']?['close'],
                          onChanged: (start, end) => _updateRestaurantHours(
                            restaurant,
                            'wednesday',
                            start,
                            end,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimeRangeField(
                          label: 'Thursday',
                          startTime: restaurant.openingHours?['thursday']?['open'],
                          endTime: restaurant.openingHours?['thursday']?['close'],
                          onChanged: (start, end) => _updateRestaurantHours(
                            restaurant,
                            'thursday',
                            start,
                            end,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimeRangeField(
                          label: 'Friday',
                          startTime: restaurant.openingHours?['friday']?['open'],
                          endTime: restaurant.openingHours?['friday']?['close'],
                          onChanged: (start, end) => _updateRestaurantHours(
                            restaurant,
                            'friday',
                            start,
                            end,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimeRangeField(
                          label: 'Saturday',
                          startTime: restaurant.openingHours?['saturday']?['open'],
                          endTime: restaurant.openingHours?['saturday']?['close'],
                          onChanged: (start, end) => _updateRestaurantHours(
                            restaurant,
                            'saturday',
                            start,
                            end,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTimeRangeField(
                          label: 'Sunday',
                          startTime: restaurant.openingHours?['sunday']?['open'],
                          endTime: restaurant.openingHours?['sunday']?['close'],
                          onChanged: (start, end) => _updateRestaurantHours(
                            restaurant,
                            'sunday',
                            start,
                            end,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            if (_profileController.showImagePreview.value)
              GestureDetector(
                onTap: _profileController.hidePreview,
                child: Container(
                  color: Colors.black87,
                  child: Center(
                    child: Image.network(
                      _profileController.previewImageUrl.value,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const CircularProgressIndicator();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error_outline, color: Colors.white, size: 50);
                      },
                    ),
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        child,
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? prefixText,
  }) {
    return TextField(
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixText: prefixText,
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      onChanged: onChanged,
    );
  }

  Widget _buildImageField({
    required String label,
    required String value,
    required Function(String) onChanged,
    required VoidCallback onPreview,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: value),
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: onPreview,
            ),
          ),
          onChanged: onChanged,
        ),
        if (value.isNotEmpty) ...[
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              value,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 100,
                  width: 100,
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
                  height: 100,
                  width: 100,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error_outline),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeRangeField({
    required String label,
    required String? startTime,
    required String? endTime,
    required Function(String?, String?) onChanged,
  }) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(label),
        ),
        Expanded(
          flex: 3,
          child: TextField(
            controller: TextEditingController(text: startTime),
            decoration: const InputDecoration(
              labelText: 'Open',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => onChanged(value, endTime),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 3,
          child: TextField(
            controller: TextEditingController(text: endTime),
            decoration: const InputDecoration(
              labelText: 'Close',
              border: OutlineInputBorder(),
            ),
            onChanged: (value) => onChanged(startTime, value),
          ),
        ),
      ],
    );
  }

  void _updateRestaurant(RestaurantModel updatedRestaurant) {
    _profileController.updateRestaurant(updatedRestaurant);
  }

  void _updateRestaurantHours(
    RestaurantModel restaurant,
    String day,
    String? startTime,
    String? endTime,
  ) {
    final updatedHours = Map<String, Map<String, String>>.from(restaurant.openingHours ?? {});
    updatedHours[day] = {
      'open': startTime ?? '',
      'close': endTime ?? '',
    };

    _profileController.updateRestaurant(restaurant.copyWith(openingHours: updatedHours));
  }
}
