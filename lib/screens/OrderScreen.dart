import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/providers/cart_provider.dart';
import 'package:flutter_application_1/providers/order_provider.dart';
import 'package:flutter_application_1/widgets/MainLayout.dart';
import 'package:flutter_application_1/widgets/OrderCard/OrderCard.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final orderProvider = context.watch<OrderProvider>();
    final cart = cartProvider.items;
    final total = cartProvider.totalPrice;

    return MainLayout(
      title: 'Orders',
      currentIndex: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: cart.isEmpty
            ? const Center(child: Text('Your cart is empty'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: cart.length,
                      itemBuilder: (context, index) =>
                          OrderCard(item: cart[index]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (cart.isEmpty) return;

                          orderProvider.addOrder(cart);

                          cartProvider.clearCart();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order placed successfully!'),
                            ),
                          );
                        },
                        child: const Text('Place Order'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
