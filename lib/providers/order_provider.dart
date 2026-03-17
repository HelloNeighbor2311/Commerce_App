import 'package:flutter/foundation.dart';

import '../models/order_item.dart';
import '../services/firestore_order_service.dart';

class OrderProvider extends ChangeNotifier {
  OrderProvider({FirestoreOrderService? firestoreOrderService})
    : _firestoreOrderService = firestoreOrderService ?? FirestoreOrderService();

  final FirestoreOrderService _firestoreOrderService;
  final List<OrderItem> _orders = <OrderItem>[];
  final bool _isLoading = false;

  List<OrderItem> get orders => List<OrderItem>.unmodifiable(_orders);
  bool get isLoading => _isLoading;
}
