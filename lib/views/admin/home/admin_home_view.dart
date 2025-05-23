import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/order_model.dart';
import '../orders/admin_orders_view.dart';
import '../menu/admin_menu_view.dart';
import '../profile/admin_profile_view.dart';
import '../analytics/admin_analytics_view.dart';
import '../settings/admin_settings_view.dart';

class AdminHomeView extends StatelessWidget {
  final AdminController _adminController = Get.find<AdminController>();

  AdminHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Get.to(() => AdminProfileView()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildQuickActions(),
            const SizedBox(height: 24),
            _buildOrdersOverview(),
            const SizedBox(height: 24),
            _buildRecentOrders(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        _buildActionCard(
          icon: Icons.restaurant_menu,
          title: 'Menu Management',
          onTap: () => Get.to(() => AdminMenuView()),
        ),
        _buildActionCard(
          icon: Icons.shopping_bag,
          title: 'Orders',
          onTap: () => Get.to(() => AdminOrdersView()),
        ),
        _buildActionCard(
          icon: Icons.analytics,
          title: 'Analytics',
          onTap: () => Get.to(() => AdminAnalyticsView()),
        ),
        _buildActionCard(
          icon: Icons.settings,
          title: 'Settings',
          onTap: () => Get.to(() => const AdminSettingsView()),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(Get.context!).primaryColor),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrdersOverview() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Orders Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final orders = _adminController.recentOrders;
              final pendingOrders = orders.where((o) => o.status == OrderStatus.pending).length;
              final preparingOrders = orders.where((o) => o.status == OrderStatus.preparing).length;
              final readyOrders = orders.where((o) => o.status == OrderStatus.ready).length;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Pending', pendingOrders, Colors.orange),
                  _buildStatItem('Preparing', preparingOrders, Colors.blue),
                  _buildStatItem('Ready', readyOrders, Colors.green),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentOrders() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Orders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => Get.to(() => AdminOrdersView()),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (_adminController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_adminController.recentOrders.isEmpty) {
                return const Center(
                  child: Text('No recent orders'),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _adminController.recentOrders.length > 5 ? 5 : _adminController.recentOrders.length,
                itemBuilder: (context, index) {
                  final order = _adminController.recentOrders[index];
                  return ListTile(
                    title: Text('Order #${order.id.substring(0, 8)}'),
                    subtitle: Text(order.status.name),
                    trailing: Text('\$${order.totalAmount.toStringAsFixed(2)}'),
                    onTap: () => _adminController.viewOrderDetails(order),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}
