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
  State<VariationBottomSheet> createState() =>
      _VariationBottomSheetState();
}

class _VariationBottomSheetState extends State<VariationBottomSheet> {
  String size = "M";
  String color = "Xanh";
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 350,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            children: [
              Image.network(widget.product.imageUrls.first,
                  width: 60, height: 60),
              const SizedBox(width: 10),
              Text(
                "${widget.product.price}đ",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// SIZE
          const Text("Size"),
          Wrap(
            children: ["S", "M", "L"].map((s) {
              return GestureDetector(
                onTap: () => setState(() => size = s),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: size == s ? Colors.orange : Colors.grey),
                  ),
                  child: Text(s),
                ),
              );
            }).toList(),
          ),

          /// COLOR
          const Text("Màu"),
          Wrap(
            children: ["Xanh", "Đỏ"].map((c) {
              return GestureDetector(
                onTap: () => setState(() => color = c),
                child: Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: color == c ? Colors.orange : Colors.grey),
                  ),
                  child: Text(c),
                ),
              );
            }).toList(),
          ),

          /// QUANTITY
          Row(
            children: [
              IconButton(
                onPressed: () {
                  if (quantity > 1) setState(() => quantity--);
                },
                icon: const Icon(Icons.remove),
              ),
              Text(quantity.toString()),
              IconButton(
                onPressed: () => setState(() => quantity++),
                icon: const Icon(Icons.add),
              ),
            ],
          ),

          const Spacer(),

          ElevatedButton(
            onPressed: () {
              widget.onConfirm(size, color, quantity);
            },
            child: const Text("Xác nhận"),
          ),
        ],
      ),
    );
  }
}