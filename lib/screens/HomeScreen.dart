import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/MainLayout.dart';
import 'package:flutter_application_1/widgets/ProductCard/ProductCard.dart';
import 'package:flutter_application_1/services/ApiService.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/data/products.dart' as sample_data;

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
          try {
            await _productsFuture;
          } catch (_) {
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: Colors.red,
                      ),
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
              final dbProducts = snapshot.data ?? [];

              if (dbProducts.isEmpty) {
                return const Center(
                  child: Text(
                    'No products available',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                );
              }

              final localList = <dynamic>[];
              try {
                localList.addAll(sample_data.products as List<dynamic>);
              } catch (_) {
              }

              return ListView.builder(
                itemCount: dbProducts.length,
                itemBuilder: (context, index) {
                  final product = dbProducts[index];

                  String description = '';
                  String imageUrl = '';

                  if (index < localList.length) {
                    final local = localList[index];
                    if (local is Map) {
                      description = (local['description'] ?? '').toString();
                      imageUrl = (local['imageUrl'] ?? local['image'] ?? '')
                          .toString();
                    } else {
                      try {
                        final dyn = local;
                        description =
                            (dyn.description ?? dyn['description'] ?? '')
                                .toString();
                      } catch (_) {
                        description = '';
                      }
                      try {
                        final dyn = local;
                        imageUrl = (dyn.imageUrl ?? dyn.image ?? '').toString();
                      } catch (_) {
                        imageUrl = '';
                      }
                    }
                  }

                  return ProductCard(
                    productId: product.id,
                    title: product.title,
                    description: description,
                    imageUrl: imageUrl,
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
