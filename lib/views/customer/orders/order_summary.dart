import 'package:flutter/material.dart';
import '../../../models/cart_model.dart';

class OrderSummary extends StatelessWidget {
  final CartModel cart;

  const OrderSummary({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...cart.items.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${item.name} x${item.quantity}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      Text(
                        '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                )),
            const Divider(),
            _buildSummaryRow('Subtotal', cart.subtotal),
            _buildSummaryRow('Delivery Fee', cart.deliveryFee),
            _buildSummaryRow('Tax', cart.tax),
            const Divider(),
            _buildSummaryRow(
              'Total',
              cart.total,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {TextStyle? style}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: style ?? const TextStyle(fontSize: 16),
          ),
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: style ?? const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
