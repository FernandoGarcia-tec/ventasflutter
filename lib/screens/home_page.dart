import 'dart:convert'; // Import for base64Decode
import 'dart:typed_data'; // Import for Uint8List
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../data/demo_products.dart';
import '../widgets/image_carousel.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Tienda Flutter'),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartPage()),
                ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<List<Product>>(
            // Wrap ImageCarousel in FutureBuilder
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading carousel: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const SizedBox.shrink(); // Hide carousel if no data
              } else {
                final products = snapshot.data!;
                return ImageCarousel(
                  products: products, // Pass the list of products
                  options: CarouselOptions(
                    height: 200.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.8,
                  ),
                );
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Productos Destacados',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No products found.'));
                } else {
                  final products = snapshot.data!;
                  return GridView.builder(
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        child: Column(
                          children: [
                            Expanded(
                              child:
                                  product.imageUrl.startsWith('data:image')
                                      ? _buildBase64Image(product.imageUrl)
                                      : _buildNetworkImage(product.imageUrl),
                            ),
                            Text(
                              product.name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text('\$${product.price.toStringAsFixed(2)}'),
                            ElevatedButton(
                              onPressed: () => cart.add(product),
                              child: Text('Agregar'),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBase64Image(String base64String) {
    String base64Clean = base64String.split(',').last;
    try {
      Uint8List bytes = base64Decode(base64Clean);
      return Image.memory(bytes, fit: BoxFit.cover);
    } catch (e) {
      print('Error decoding base64 image: $e');
      return Icon(Icons.error);
    }
  }

  Widget _buildNetworkImage(String imageUrl) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading network image: $error');
        return Icon(Icons.error);
      },
    );
  }
}
