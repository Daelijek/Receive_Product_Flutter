import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/MainLayout.dart';
import 'package:flutter_application_1/widgets/ProductCard/ProductCard.dart';
import 'package:flutter_application_1/data/products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home',
      currentIndex: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              title: product['title'],
              description: product['description'],
              imageUrl: product['imageUrl'],
              price: product['price'],
            );
          },
        ),
      ),
    );
  }
}
