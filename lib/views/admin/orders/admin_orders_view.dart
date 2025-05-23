import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/admin_controller.dart';
import '../../../models/order_model.dart';

class AdminOrdersView extends StatelessWidget {
  final AdminController _controller = Get.find<AdminController>();

  AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Obx(() {
        if (_controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_controller.recentOrders.isEmpty) {
          return const Center(
            child: Text('No orders found'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _controller.recentOrders.length,
          itemBuilder: (context, index) {
            final order = _controller.recentOrders[index];
            return _buildOrderCard(context, order);
          },
        );
      }),
    );
  }

  Widget _buildOrderCard(BuildContext context, OrderModel order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.substring(0, 8)}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                _buildStatusChip(
                    context,
                    OrderStatus.values.firstWhere(
                      (e) => e == order.status,
                      orElse: () => OrderStatus.pending,
                    )),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Items',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.name}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                )),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '\$${order.totalAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Payment Method',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  order.paymentMethod,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Address',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Expanded(
                  child: Text(
                    'Lat: ${order.deliveryAddress.latitude}, Lng: ${order.deliveryAddress.longitude}',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _controller.viewOrderDetails(order),
                  child: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                if (order.status == OrderStatus.pending)
                  ElevatedButton(
                    onPressed: () => _showStatusUpdateDialog(context, order),
                    child: const Text('Update Status'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, OrderStatus status) {
    Color color;
    String text;

    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case OrderStatus.confirmed:
        color = Colors.blue;
        text = 'Confirmed';
        break;
      case OrderStatus.preparing:
        color = Colors.purple;
        text = 'Preparing';
        break;
      case OrderStatus.ready:
        color = Colors.indigo;
        text = 'Ready';
        break;
      case OrderStatus.onTheWay:
        color = Colors.teal;
        text = 'On the way';
        break;
      case OrderStatus.delivered:
        color = Colors.green;
        text = 'Delivered';
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        break;
    }

    return Chip(
      label: Text(
        text.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: color,
    );
  }

  void _showStatusUpdateDialog(BuildContext context, OrderModel order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Preparing'),
              onTap: () {
                Navigator.pop(context);
                _controller.updateOrderStatus(order.id, OrderStatus.preparing);
              },
            ),
            ListTile(
              title: const Text('Ready'),
              onTap: () {
                Navigator.pop(context);
                _controller.updateOrderStatus(order.id, OrderStatus.ready);
              },
            ),
            ListTile(
              title: const Text('On the way'),
              onTap: () {
                Navigator.pop(context);
                _controller.updateOrderStatus(order.id, OrderStatus.onTheWay);
              },
            ),
            ListTile(
              title: const Text('Delivered'),
              onTap: () {
                Navigator.pop(context);
                _controller.updateOrderStatus(order.id, OrderStatus.delivered);
              },
            ),
            ListTile(
              title: const Text('Cancelled'),
              onTap: () {
                Navigator.pop(context);
                _controller.updateOrderStatus(order.id, OrderStatus.cancelled);
              },
            ),
          ],
        ),
      ),
    );
  }
}
