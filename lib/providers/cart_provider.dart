import 'package:flutter/foundation.dart';

import '../models/cart_line_item.dart';

class CartProvider extends ChangeNotifier {
  static const String _storageKey = 'cart_line_items_v2';

  final Map<String, CartLineItem> _items = <String, CartLineItem>{};

  List<CartLineItem> get items =>
      List<CartLineItem>.unmodifiable(_items.values);

  int get distinctItemCount => _items.length;

  bool get allSelected =>
      _items.isNotEmpty && _items.values.every((CartLineItem e) => e.selected);

  int get selectedTotalAmount => 0;

  List<CartLineItem> get selectedItems => _items.values
      .where((CartLineItem e) => e.selected)
      .toList(growable: false);
}
