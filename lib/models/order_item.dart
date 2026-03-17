import 'cart_line_item.dart';

enum OrderStatus { pending, shipping, delivered, cancelled }

class OrderItem {
  const OrderItem({
    required this.id,
    required this.createdAt,
    required this.address,
    required this.paymentMethod,
    required this.status,
    required this.items,
  });

  final String id;
  final DateTime createdAt;
  final String address;
  final String paymentMethod;
  final OrderStatus status;
  final List<CartLineItem> items;
}
