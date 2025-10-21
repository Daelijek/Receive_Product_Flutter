import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/order_provider.dart';
import 'package:flutter_application_1/widgets/MainLayout.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = context.watch<OrderProvider>();
    final orders = orderProvider.orderHistory;

    return MainLayout(
      title: 'Order History',
      currentIndex: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: orders.isEmpty
            ? const Center(child: Text('No orders yet'))
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final total = order.fold<double>(
                    0,
                    (sum, item) => sum + item.price * item.quantity,
                  );

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Order #${index + 1}'),
                      subtitle: Text(
                        '${order.length} items — Total: \$${total.toStringAsFixed(2)}',
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    ),
                  );
                },
              ),
      ),
    );
  }
}