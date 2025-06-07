import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

Widget buildBase64Image(String base64String) {
  String base64Clean = base64String.split(',').last;
  try {
    Uint8List bytes = base64Decode(base64Clean);
    return Image.memory(bytes, fit: BoxFit.cover);
  } catch (e) {
    print('Error decoding base64 image: $e');
    return Icon(Icons.error);
  }
}

Widget buildNetworkImage(String imageUrl) {
  return Image.network(
    imageUrl,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      print('Error loading network image: $error');
      return Icon(Icons.error);
    },
  );
}
