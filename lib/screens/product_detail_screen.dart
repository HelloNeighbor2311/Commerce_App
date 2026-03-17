import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/variation_bottom_sheet.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  State<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final PageController _controller = PageController();
  int _pageIndex = 0;
  bool _expanded = false;

  String _formatPrice(int value) {
    return "${value.toString()}đ";
  }

  void _openBottomSheet({bool buyNow = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) {
        return VariationBottomSheet(
          product: widget.product,
          buyNow: buyNow,
          onConfirm: (size, color, quantity) {
            context.read<CartProvider>().addProduct(
                  widget.product,
                  size: size,
                  color: color,
                  quantity: quantity,
                );

            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Thêm thành công")),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      bottomNavigationBar: _buildBottomBar(),
      body: CustomScrollView(
        slivers: [
          /// APPBAR + SLIDER
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    controller: _controller,
                    itemCount: product.imageUrls.length,
                    onPageChanged: (i) {
                      setState(() => _pageIndex = i);
                    },
                    itemBuilder: (_, index) {
                      return Hero(
                        tag: 'product-hero-${product.id}',
                        child: Image.network(
                          product.imageUrls[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),

                  /// DOT
                  Positioned(
                    bottom: 12,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: _pageIndex,
                        count: product.imageUrls.length,
                        effect: const WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// CONTENT
          SliverToBoxAdapter(
            child: Column(
              children: [
                /// BOX WHITE
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// PRICE
                      Row(
                        children: [
                          Text(
                            _formatPrice(product.price),
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _formatPrice(product.originalPrice),
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// NAME
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                /// VARIATION
                Container(
                  color: Colors.white,
                  child: ListTile(
                    title: const Text("Chọn Size, Màu"),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _openBottomSheet(),
                  ),
                ),

                const SizedBox(height: 8),

                /// DESCRIPTION
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Mô tả sản phẩm",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),

                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: _expanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        firstChild: const Text(
                          "Đây là mô tả sản phẩm rất dài. Đây là mô tả sản phẩm rất dài. Đây là mô tả sản phẩm rất dài. Đây là mô tả sản phẩm rất dài...",
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        secondChild: const Text(
                          "Đây là mô tả sản phẩm rất dài. Đây là mô tả sản phẩm rất dài. Đây là mô tả sản phẩm rất dài. Đây là mô tả sản phẩm rất dài. Đây là mô tả sản phẩm rất dài. Đây là mô tả sản phẩm rất dài.",
                        ),
                      ),

                      GestureDetector(
                        onTap: () {
                          setState(() => _expanded = !_expanded);
                        },
                        child: Text(
                          _expanded ? "Thu gọn" : "Xem thêm",
                          style: const TextStyle(color: Colors.orange),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.chat),
                Icon(Icons.shopping_cart),
              ],
            ),
          ),

          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _openBottomSheet(),
                    child: const Text("Thêm vào giỏ"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        _openBottomSheet(buyNow: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text("Mua ngay"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}