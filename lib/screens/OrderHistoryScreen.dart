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
            ? const Center(
                child: Text(
                  'No orders yet',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              )
            : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final total = order.fold<double>(
                    0,
                    (sum, item) => sum + item.price * item.quantity,
                  );

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A56DB).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.receipt_long,
                          color: Color(0xFF1A56DB),
                        ),
                      ),
                      title: Text(
                        'Order #${index + 1}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A56DB),
                        ),
                      ),
                      subtitle: Text(
                        '${order.length} items • \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.black87),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/order-details',
                          arguments: order,
                        );
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
