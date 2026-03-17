import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/variation_bottom_sheet.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late final PageController _pageController;
  int _currentImage = 0;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  String _fmt(int v) =>
      '${NumberFormat('#,##0', 'vi_VN').format(v)}đ';

  void _openSheet({required bool buyNow}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => VariationBottomSheet(
        product: widget.product,
        buyNow: buyNow,
        onConfirm: (size, color, qty) async {
          await context.read<CartProvider>().addProduct(
                widget.product,
                size: size,
                color: color,
                quantity: qty,
              );

          if (!mounted) return;
          Navigator.pop(context);

          if (buyNow) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartScreen()),
            );
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Thêm thành công")),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,

      /// ================= BOTTOM BAR =================
      bottomNavigationBar: _BottomBar(
        onAdd: () => _openSheet(buyNow: false),
        onBuy: () => _openSheet(buyNow: true),
      ),

      body: CustomScrollView(
        slivers: [
          /// ================= APPBAR + HERO =================
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            actions: [
              Consumer<CartProvider>(
                builder: (_, cart, __) {
                  return Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.shopping_cart),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CartScreen()),
                          );
                        },
                      ),
                      if (cart.distinctItemCount > 0)
                        Positioned(
                          right: 6,
                          top: 6,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              cart.distinctItemCount.toString(),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 10),
                            ),
                          ),
                        )
                    ],
                  );
                },
              )
            ],
          ),

          /// ================= SLIDER =================
          SliverToBoxAdapter(
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: p.imageUrls.length,
                    onPageChanged: (i) =>
                        setState(() => _currentImage = i),
                    itemBuilder: (_, i) {
                      Widget img = Image.network(
                        p.imageUrls[i],
                        fit: BoxFit.cover,
                      );

                      if (i == 0) {
                        img = Hero(
                          tag: 'product-hero-${p.id}',
                          child: img,
                        );
                      }

                      return img;
                    },
                  ),

                  /// DOT
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        p.imageUrls.length,
                        (i) => Container(
                          margin:
                              const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _currentImage ? 14 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: i == _currentImage
                                ? Colors.orange
                                : Colors.white70,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          /// ================= PRICE =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        _fmt(p.price),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _fmt(p.originalPrice),
                        style: const TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    p.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),

          /// ================= VARIATION =================
          SliverToBoxAdapter(
            child: InkWell(
              onTap: () => _openSheet(buyNow: false),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Chọn Kích cỡ, Màu sắc",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 16)
                  ],
                ),
              ),
            ),
          ),

          /// ================= DESCRIPTION =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AnimatedCrossFade(
                    firstChild: Text(
                      "Mô tả sản phẩm rất dài... " * 5,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    secondChild: Text(
                      "Mô tả sản phẩm rất dài... " * 10,
                    ),
                    crossFadeState: _expanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 200),
                  ),
                  TextButton(
                    onPressed: () =>
                        setState(() => _expanded = !_expanded),
                    child: Text(_expanded ? "Thu gọn" : "Xem thêm"),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// ================= BOTTOM BAR =================
class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onAdd, required this.onBuy});

  final VoidCallback onAdd;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Colors.black12)),
        color: Colors.white,
      ),
      child: Row(
        children: [
          /// LEFT (ICON)
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.chat, color: Colors.grey),
                Icon(Icons.shopping_cart, color: Colors.grey),
              ],
            ),
          ),

          /// RIGHT (BUTTON)
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAdd,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    child: const Text("Thêm"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onBuy,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red),
                    child: const Text("Mua ngay"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}