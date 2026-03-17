import 'product.dart';

class CartLineItem {
  const CartLineItem({
    required this.key,
    required this.product,
    required this.size,
    required this.color,
    required this.quantity,
    required this.selected,
  });

  final String key;
  final Product product;
  final String size;
  final String color;
  final int quantity;
  final bool selected;
}
