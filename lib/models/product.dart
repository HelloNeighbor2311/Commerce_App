class Product {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.imageUrls,
    required this.tags,
    required this.soldCount,
  });

  final String id;
  final String name;
  final int price;
  final int originalPrice;
  final List<String> imageUrls;
  final List<String> tags;
  final int soldCount;
}
