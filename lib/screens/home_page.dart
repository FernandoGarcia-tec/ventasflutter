import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../data/demo_products.dart' as demo_products;
import '../widgets/image_carousel.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/search_bar.dart'; // Ensure this file defines SearchBarWidget
import '../screens/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> _productsFuture;
  String _searchQuery = '';
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = demo_products.fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        title: SearchBarWidget(
          onChanged: (query) {
            setState(() {
              _searchQuery = query.toLowerCase();
              _filteredProducts =
                  _allProducts
                      .where(
                        (product) =>
                            product.name.toLowerCase().contains(_searchQuery),
                      )
                      .toList();
            });
          },
        ),
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
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            _allProducts = snapshot.data!;
            _filteredProducts =
                _searchQuery.isEmpty
                    ? _allProducts
                    : _allProducts
                        .where(
                          (product) =>
                              product.name.toLowerCase().contains(_searchQuery),
                        )
                        .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageCarousel(
                    products: _allProducts,
                    options: CarouselOptions(
                      height: 280.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.8,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Productos Destacados',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.65,
                          ),
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          child: Column(
                            children: [
                              Expanded(
                                flex: 3,
                                child:
                                    product.imageUrl.startsWith('data:image')
                                        ? _buildBase64Image(product.imageUrl)
                                        : _buildNetworkImage(product.imageUrl),
                              ),
                              Expanded(
                                flex: 4,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                        Text(
                                          '\$${product.price.toStringAsFixed(2)}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        SizedBox(height: 4),
                                        ElevatedButton(
                                          onPressed: () => cart.add(product),
                                          child: Text(
                                            'Agregar',
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(60, 30),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
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
