import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/ApiService.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/screens/HomeScreen.dart';

class ProductCard extends StatefulWidget {
  final dynamic productId;
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  const ProductCard({
    super.key,
    required this.productId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isAdding = false;

  Future<void> _addToCart() async {
    final pid = widget.productId;
    if (pid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot add to cart: product id is null'),
          backgroundColor: Colors.red,
        ),
      );
      print('ProductCard._addToCart: productId is null for ${widget.title}');
      return;
    }

    setState(() => _isAdding = true);

    try {
      print('ProductCard._addToCart -> productId=$pid, title=${widget.title}');
      final res = await ApiService.createOrder(productId: pid, quantity: 1);

      if (!mounted) return;

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order created'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        final dynamic raw = res['error'] ?? res['data'] ?? res;
        final String msg = raw is String
            ? raw
            : (raw != null ? raw.toString() : 'Order failed');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isAdding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            if (widget.imageUrl.isNotEmpty)
              Image.network(
                widget.imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              )
            else
              Container(width: 80, height: 80, color: Colors.grey.shade200),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${widget.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _isAdding ? null : _addToCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A56DB),
              ),
              child: _isAdding
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
