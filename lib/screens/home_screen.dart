import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../services/mock_product_service.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/category_grid_scroller.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MockProductService _productService = MockProductService();
  late TextEditingController _searchController;
  late ScrollController _scrollController;

  List<Product> _products = <Product>[];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String _selectedCategory = 'all';
  int _currentPage = 1;
  String _searchKeyword = '';
  bool _hasMoreProducts = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore && _hasMoreProducts) {
        _loadMoreProducts();
      }
    }
  }

  Future<void> _loadProducts({String? categoryFilter, String? searchKeyword, bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMoreProducts = true;
    }

    setState(() {
      if (refresh) _isLoading = true;
    });

    try {
      final List<Product> products = await _productService.fetchProducts(
        page: 1,
        pageSize: 20,
        categoryFilter: categoryFilter ?? _selectedCategory,
        searchKeyword: searchKeyword ?? _searchKeyword,
      );
      setState(() {
        _products = products;
        _currentPage = 1;
        _hasMoreProducts = products.length >= 20;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải dữ liệu: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    setState(() {
      _isLoadingMore = true;
    });

    try {
      final List<Product> moreProducts = await _productService.fetchProducts(
        page: _currentPage + 1,
        pageSize: 20,
        categoryFilter: _selectedCategory,
        searchKeyword: _searchKeyword,
      );
      setState(() {
        _products.addAll(moreProducts);
        _currentPage++;
        _hasMoreProducts = moreProducts.length >= 20;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải thêm dữ liệu: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _onCategorySelected(String tag) {
    setState(() {
      _selectedCategory = tag;
      _searchKeyword = '';
      _searchController.clear();
    });
    _loadProducts(categoryFilter: tag, refresh: true);
  }

  void _onSearchChanged(String keyword) {
    setState(() {
      _searchKeyword = keyword;
      _selectedCategory = 'all';
    });
    if (keyword.isEmpty) {
      _loadProducts(refresh: true);
    } else {
      _loadProducts(searchKeyword: keyword, refresh: true);
    }
  }

  void _onAddToCart(Product product) {
    context.read<CartProvider>().addProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã thêm vào giỏ hàng'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => _loadProducts(refresh: true),
        color: const Color(0xFFFF5722),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: <Widget>[
            // Sticky AppBar với màu cam
            SliverAppBar(
              pinned: true,
              elevation: 2,
              backgroundColor: const Color(0xFFFF5722),
              title: const Text(
                'N7-TH4-CommerceApp',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              actions: [
                // Icon giỏ hàng với badge
                Consumer<CartProvider>(
                  builder: (context, cartProvider, child) {
                    final int cartCount = cartProvider.distinctItemCount;
                    return Stack(
                      children: [
                        IconButton(
                          onPressed: () {
                            // TODO: Navigate to cart screen
                          },
                          icon: const Icon(Icons.shopping_cart, color: Colors.white),
                        ),
                        if (cartCount > 0)
                          Positioned(
                            right: 6,
                            top: 8,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  cartCount > 99 ? '99+' : cartCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.account_circle, color: Colors.white),
                ),
              ],
            ),

            // Sticky Search Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchBarDelegate(_searchController, _onSearchChanged, _searchKeyword),
            ),

            // Body content
            SliverToBoxAdapter(
              child: _isLoading && _products.isEmpty
                  ? const SizedBox(
                      height: 200,
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Column(
                      children: <Widget>[
                        // Banner carousel (ẩn khi đang search)
                        if (_searchKeyword.isEmpty)
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: BannerCarousel(
                                  images: MockProductService.bannerImages,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),

                        // Category grid scroller (ẩn khi đang search)
                        if (_searchKeyword.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: CategoryGridScroller(
                              categories: MockProductService.categories,
                              selectedCategoryTag: _selectedCategory,
                              onCategorySelected: _onCategorySelected,
                            ),
                          ),
                        if (_searchKeyword.isEmpty)
                          const SizedBox(height: 12),

                        // Title "Sản phẩm nổi bật"
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _searchKeyword.isNotEmpty
                                    ? 'Kết quả tìm kiếm (${_products.length})'
                                    : 'Sản phẩm nổi bật',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Product grid
                        if (_products.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 12,
                                crossAxisSpacing: 12,
                                childAspectRatio: 0.56,
                              ),
                              itemCount: _products.length,
                              itemBuilder: (BuildContext context, int index) {
                                final Product product = _products[index];
                                return ProductCard(
                                  product: product,
                                  onTap: () {
                                    // TODO: Navigate to product detail
                                  },
                                  onAddToCart: () {
                                    _onAddToCart(product);
                                  },
                                );
                              },
                            ),
                          )
                        else if (!_isLoading)
                          const Padding(
                            padding: EdgeInsets.all(32),
                            child: Text('Không có sản phẩm'),
                          ),

                        // Loading more indicator
                        if (_isLoadingMore)
                          const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          ),

                        const SizedBox(height: 24),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBarDelegate extends SliverPersistentHeaderDelegate {
  _SearchBarDelegate(this.searchController, this.onChanged, this.searchKeyword);

  final TextEditingController searchController;
  final Function(String) onChanged;
  final String searchKeyword;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: TextField(
        controller: searchController,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Tìm kiếm sản phẩm...',
          hintStyle: TextStyle(color: Colors.grey[400]),
          prefixIcon: const Icon(Icons.search, color: Color(0xFFFF5722)),
          suffixIcon: searchKeyword.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    searchController.clear();
                    onChanged('');
                  },
                  child: const Icon(Icons.close, color: Color(0xFFFF5722)),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF5722), width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 68;

  @override
  double get minExtent => 68;

  @override
  bool shouldRebuild(_SearchBarDelegate oldDelegate) {
    return oldDelegate.searchKeyword != searchKeyword;
  }
}
