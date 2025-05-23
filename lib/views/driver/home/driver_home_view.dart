import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../controllers/driver_controller.dart';

class DriverHomeView extends StatelessWidget {
  final DriverController driverController = Get.put(DriverController());

  DriverHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Get.toNamed('/driver/history');
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Get.toNamed('/driver/profile');
            },
          ),
        ],
      ),
      body: Obx(() {
        if (driverController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Map Section
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: driverController.currentLocation.value != null
                          ? LatLng(
                              driverController.currentLocation.value!.latitude,
                              driverController.currentLocation.value!.longitude,
                            )
                          : const LatLng(0, 0),
                      zoom: 15,
                    ),
                    onMapCreated: driverController.onMapCreated,
                    markers: driverController.markers.value,
                    polylines: driverController.polylines.value,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                  // Current Status Card
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Current Status',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      driverController.currentStatus.value,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    driverController.currentStatus.value.name.toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            if (driverController.currentOrder.value != null) ...[
                              const Divider(),
                              const SizedBox(height: 8),
                              Text(
                                'Order #${driverController.currentOrder.value!.id}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${driverController.currentOrder.value!.items.length} items',
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Total: \$${driverController.currentOrder.value!.totalAmount.toStringAsFixed(2)}',
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Action Buttons
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.directions_car,
                    label: 'Start Shift',
                    onPressed: driverController.startShift,
                    color: Colors.green,
                  ),
                  _buildActionButton(
                    icon: Icons.delivery_dining,
                    label: 'Accept Order',
                    onPressed: () async {
                      final order = await driverController.getNextOrder();
                      if (order != null) {
                        driverController.acceptOrder(order);
                      }
                    },
                    color: Colors.blue,
                  ),
                  _buildActionButton(
                    icon: Icons.check_circle,
                    label: 'Complete Delivery',
                    onPressed: driverController.completeDelivery,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Color _getStatusColor(DriverStatus status) {
    switch (status) {
      case DriverStatus.offline:
        return Colors.grey;
      case DriverStatus.available:
        return Colors.green;
      case DriverStatus.busy:
        return Colors.orange;
      case DriverStatus.delivering:
        return Colors.blue;
    }
  }
}
