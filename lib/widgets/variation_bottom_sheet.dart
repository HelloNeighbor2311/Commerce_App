import 'package:flutter/material.dart';

import '../models/product.dart';

class VariationBottomSheet extends StatefulWidget {
  const VariationBottomSheet({
    super.key,
    required this.product,
    required this.buyNow,
    required this.onConfirm,
  });

  final Product product;
  final bool buyNow;
  final void Function(String size, String color, int quantity) onConfirm;

  @override
  State<VariationBottomSheet> createState() => _VariationBottomSheetState();
}

class _VariationBottomSheetState extends State<VariationBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
