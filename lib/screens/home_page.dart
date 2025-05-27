import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/demo_products.dart';
import '../providers/cart_provider.dart';
import '../screens/cart_page.dart';

class HomePage extends StatelessWidget {
  @override
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
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: demoProducts.length,
        itemBuilder: (context, index) {
          final product = demoProducts[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            child: Column(
              children: [
                Expanded(
                  child: Image.network(product.imageUrl, fit: BoxFit.cover),
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
      ),
    );
  }
}
