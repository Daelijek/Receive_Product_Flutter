import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/MainLayout.dart';
import 'package:flutter_application_1/widgets/ProductCard/ProductCard.dart';
import 'package:flutter_application_1/services/ApiService.dart';
import 'package:flutter_application_1/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ApiService.fetchProducts();
  }

  // Функция для обновления списка продуктов
  void _refreshProducts() {
    setState(() {
      _productsFuture = ApiService.fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: 'Home',
      currentIndex: 0,
      child: RefreshIndicator(
        onRefresh: () async {
          _refreshProducts();
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              // Показываем загрузку
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Показываем ошибку
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text(
                        'Error: ${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _refreshProducts,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              // Показываем список продуктов
              final products = snapshot.data ?? [];

              if (products.isEmpty) {
                return const Center(
                  child: Text(
                    'No products available',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    title: product.title,
                    description: product.description,
                    imageUrl: product.imageUrl,
                    price: product.price,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}