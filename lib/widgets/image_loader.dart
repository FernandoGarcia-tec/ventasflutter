import 'package:flutter/material.dart';
import '../helpers/image_utils.dart';

class ImageLoader extends StatelessWidget {
  final String imageUrl;

  const ImageLoader({required this.imageUrl, super.key});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('data:image')) {
      return buildBase64Image(imageUrl);
    } else {
      return buildNetworkImage(imageUrl);
    }
  }
}
