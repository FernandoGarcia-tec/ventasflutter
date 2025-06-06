class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String material;
  final String gemstones;
  final String style;
  final String occasion;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.material,
    required this.gemstones,
    required this.style,
    required this.occasion,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(), // Assuming price is a number in JSON
      imageUrl: json['imageUrl'],
      category: json['category'],
      material: json['material'],
      gemstones: json['gemstones'],
      style: json['style'],
      occasion: json['occasion'],
    );
  }
}
