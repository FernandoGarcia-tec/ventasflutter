import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/product.dart'; // Import the Product model

class ImageCarousel extends StatelessWidget {
  final List<Product> products; // Change from imageUrls to products
  final CarouselOptions options; // Add options parameter

  const ImageCarousel({Key? key, required this.products, required this.options})
    : super(key: key); // Update constructor

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: options, // Use the provided options
      items:
          products.map((product) {
            // Iterate over products
            return Builder(
              builder: (BuildContext context) {
                Widget imageWidget;
                if (product.imageUrl.startsWith('data:image')) {
                  // Use product.imageUrl
                  // Handle base64 data URI
                  String base64Clean = product.imageUrl.split(',').last;
                  try {
                    Uint8List bytes = base64Decode(base64Clean);
                    imageWidget = Image.memory(bytes, fit: BoxFit.cover);
                  } catch (e) {
                    // Handle potential decoding errors
                    print('Error decoding base64 image: $e');
                    imageWidget = Icon(Icons.error); // Or any other placeholder
                  }
                } else {
                  // Handle regular network image URL
                  imageWidget = Image.network(
                    product.imageUrl, // Use product.imageUrl
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      // Add error handling for network images as well
                      print('Error loading network image: $error');
                      return Icon(Icons.error); // Or any other placeholder
                    },
                  );
                }

                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(color: Colors.grey),
                  child: imageWidget,
                );
              },
            );
          }).toList(),
    );
  }
}
