class Product {
  final String? id;
  final String categoryId;
  final String categoryName;
  final String sku;
  final String name;
  final String description;
  final int weight;
  final int width;
  final int length;
  final int height;
  final String image;
  final int price;

  Product({
    this.id,
    required this.categoryId,
    required this.categoryName,
    required this.sku,
    required this.name,
    required this.description,
    required this.weight,
    required this.width,
    required this.length,
    required this.height,
    required this.image,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] as String?,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      sku: json['sku'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      weight: json['weight'] as int,
      width: json['width'] as int,
      length: json['length'] as int,
      height: json['height'] as int,
      image: json['image'] as String,
      price: json['price'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'sku': sku,
      'name': name,
      'description': description,
      'weight': weight,
      'width': width,
      'length': length,
      'height': height,
      'image': image,
      'price': price,
    };
  }
}
