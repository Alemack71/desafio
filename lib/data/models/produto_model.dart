class ProdutoModel {
  final String title;
  final String description;
  final String category;
  final double price;
  final String brand;
  final double rating;
  final List<String> images;
  final String thumbnail;

  ProdutoModel({
    required this.title, 
    required this.description, 
    required this.category, 
    required this.price, 
    required this.brand, 
    required this.rating, 
    required this.images, 
    required this.thumbnail,
  });

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
  return ProdutoModel(
    title: map['title'] ?? 'Sem título', 
    description: map['description'] ?? 'Sem descrição', 
    category: map['category'] ?? 'Sem categoria', 
    price: (map['price'] ?? 0) * 1.0, 
    brand: map['brand'] ?? 'Sem marca', 
    rating: (map['rating'] ?? 0) * 1.0, 
    images: map['images'] != null 
    ? List<String>.from(map['images'].whereType<String>()) 
    : [],
    thumbnail: map['thumbnail'] ?? '',
  );
  }
}