import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/order_model.dart';

class AdminAnalyticsView extends StatelessWidget {
  final AdminController _adminController = Get.find<AdminController>();

  AdminAnalyticsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRevenueChart(context),
            const SizedBox(height: 24),
            _buildOrderStatistics(),
            const SizedBox(height: 24),
            _buildPopularItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: Obx(() {
                if (_adminController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Here you would normally use a chart library like fl_chart or charts_flutter
                // For this implementation, we'll use a placeholder
                return Center(
                  child: Image.network(
                    'https://via.placeholder.com/800x200?text=Revenue+Chart+Placeholder',
                    fit: BoxFit.cover,
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final totalRevenue = _adminController.recentOrders
                  .where((order) => order.status == OrderStatus.delivered)
                  .fold<double>(0, (sum, order) => sum + order.totalAmount);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatCard('Today', '\$${(totalRevenue * 0.3).toStringAsFixed(2)}'),
                  _buildStatCard('This Week', '\$${(totalRevenue * 0.7).toStringAsFixed(2)}'),
                  _buildStatCard('This Month', '\$${totalRevenue.toStringAsFixed(2)}'),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderStatistics() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (_adminController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final orders = _adminController.recentOrders;
              final totalOrders = orders.length;
              final completedOrders = orders.where((order) => order.status == OrderStatus.delivered).length;
              final pendingOrders = orders.where((order) => order.status == OrderStatus.pending).length;
              final cancelledOrders = orders.where((order) => order.status == OrderStatus.cancelled).length;

              final completionRate = totalOrders > 0 ? (completedOrders / totalOrders * 100).toStringAsFixed(1) : '0';

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatColumn('Total Orders', totalOrders.toString()),
                      _buildStatColumn('Completion Rate', '$completionRate%'),
                      _buildStatColumn('Avg. Order Value',
                          '\$${totalOrders > 0 ? (orders.fold<double>(0, (sum, order) => sum + order.totalAmount) / totalOrders).toStringAsFixed(2) : '0.00'}'),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildOrderBar('Pending', pendingOrders, totalOrders, Colors.orange),
                        _buildOrderBar('Preparing', orders.where((o) => o.status == OrderStatus.preparing).length,
                            totalOrders, Colors.blue),
                        _buildOrderBar('Completed', completedOrders, totalOrders, Colors.green),
                        _buildOrderBar('Cancelled', cancelledOrders, totalOrders, Colors.red),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItems() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Popular Items',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Navigate to detailed menu analytics
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (_adminController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              // Get all items from all orders
              final allItems = _adminController.recentOrders.expand((order) => order.items).toList();

              // Count occurrences of each item by name
              final itemCounts = <String, int>{};
              for (final item in allItems) {
                itemCounts[item.name] = (itemCounts[item.name] ?? 0) + item.quantity;
              }

              // Sort by count (descending)
              final sortedItems = itemCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

              // Take top 5
              final topItems = sortedItems.take(5).toList();

              if (topItems.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: topItems.length,
                itemBuilder: (context, index) {
                  final item = topItems[index];
                  final percentage = itemCounts.values.fold(0, (sum, count) => sum + count) > 0
                      ? (item.value / itemCounts.values.fold(0, (sum, count) => sum + count) * 100).toStringAsFixed(1)
                      : '0';

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(
                            item.key,
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Stack(
                                children: [
                                  Container(
                                    height: 20,
                                    width: constraints.maxWidth,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  Container(
                                    height: 20,
                                    width: constraints.maxWidth * (double.parse(percentage) / 100),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 60,
                          child: Text(
                            '$percentage%',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderBar(String label, int count, int total, Color color) {
    // Calculate height percentage (min 10% for visibility even when 0)
    final double percentage = total > 0 ? (count / total) : 0;
    final double height = 120 * (percentage > 0.1 ? percentage : (count > 0 ? 0.1 : 0));

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 30,
          height: height,
          color: color,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          count.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
