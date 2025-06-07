import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../data/demo_products.dart' as demo_products;
import '../models/product.dart';
import '../widgets/image_carousel.dart';
import '../widgets/search_bar.dart';
import '../widgets/product_grid.dart';
import 'cart_page.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../widgets/category_list.dart';
import 'dart:collection';

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
  List<String> _categories = [];
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _productsFuture = demo_products.fetchProducts();
    _productsFuture.then((products) {
      // Extrae categorías únicas de los productos
      final categoriesSet = SplayTreeSet<String>();
      for (var product in products) {
        if (product.category != null && product.category.isNotEmpty) {
          categoriesSet.add(product.category);
        }
      }
      setState(() {
        _allProducts = products;
        _categories = categoriesSet.toList();
        _filteredProducts = _allProducts;
      });
    });
  }

  void _filterProducts({String? category, String? query}) {
    setState(() {
      _selectedCategory = category ?? _selectedCategory;
      _searchQuery = query ?? _searchQuery;
      _filteredProducts =
          _allProducts.where((product) {
            final matchesCategory =
                _selectedCategory == null ||
                _selectedCategory!.isEmpty ||
                product.category == _selectedCategory;
            final matchesQuery =
                _searchQuery.isEmpty ||
                product.name.toLowerCase().contains(_searchQuery);
            return matchesCategory && matchesQuery;
          }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 4.0,
        title: SearchBarWidget(
          onChanged: (query) {
            _filterProducts(query: query.toLowerCase());
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
            // Ya se cargaron los productos y categorías en initState
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
                  CategoryList(
                    categories: _categories,
                    onCategorySelected: (category) {
                      _filterProducts(category: category);
                    },
                  ),
                  ProductGrid(products: _filteredProducts, cart: cart),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
