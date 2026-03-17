import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product.dart';

class MockProductService {
  static const List<String> bannerImages = <String>[
    'https://images.unsplash.com/photo-1555529669-e69e7aa0ba9a?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1200&q=80',
    'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?auto=format&fit=crop&w=1200&q=80',
  ];

  static const List<Map<String, String>> categories = <Map<String, String>>[
    {'title': 'Điện thoại', 'icon': 'smartphone', 'tag': 'smartphones'},
    {'title': 'Laptop', 'icon': 'laptop_mac', 'tag': 'laptops'},
    {'title': 'Mỹ phẩm', 'icon': 'face_retouching_natural', 'tag': 'beauty'},
    {'title': 'Trang trí', 'icon': 'home', 'tag': 'home-decoration'},
    {'title': 'Đồ nữ', 'icon': 'checkroom', 'tag': 'womens-dresses'},
    {'title': 'Đồ nam', 'icon': 'dry_cleaning', 'tag': 'mens-shirts'},
    {'title': 'Giày dép', 'icon': 'directions_run', 'tag': 'mens-shoes'},
    {'title': 'Đồng hồ', 'icon': 'watch', 'tag': 'mens-watches'},
    {'title': 'Trang sức', 'icon': 'diamond', 'tag': 'womens-jewellery'},
    {'title': 'Xe cộ', 'icon': 'directions_car', 'tag': 'automotive'},
  ];

  // Map từ API category -> Tiếng Việt
  static const Map<String, String> _categoryVietnameseMap = <String, String>{
    'smartphones': 'Điện thoại',
    'laptops': 'Laptop',
    'skincare': 'Mỹ phẩm',
    'home-decoration': 'Trang trí',
    'womens-dresses': 'Đồ nữ',
    'mens-shirts': 'Đồ nam',
    'mens-shoes': 'Giày dép',
    'mens-watches': 'Đồng hồ',
    'womens-jewellery': 'Trang sức',
    'automotive': 'Xe cộ',
  };

  String _getCategoryVietnamse(String category) {
    return _categoryVietnameseMap[category] ?? category;
  }

  Future<List<Product>> fetchProducts({
    required int page,
    required int pageSize,
    String? categoryFilter,
    String? searchKeyword,
  }) async {
    try {
      // Tính toán vị trí bỏ qua (skip) cho tính năng cuộn tải thêm
      final int skip = (page - 1) * pageSize;
      String url;
      
      if (searchKeyword != null && searchKeyword.isNotEmpty) {
        // Ưu tiên 1: Nếu người dùng đang gõ tìm kiếm -> Gọi API Search
        url = 'https://dummyjson.com/products/search?q=$searchKeyword&limit=$pageSize&skip=$skip';
      } else if (categoryFilter != null && categoryFilter != 'all') {
        // Ưu tiên 2: Lọc theo danh mục (nếu không tìm kiếm)
        url = 'https://dummyjson.com/products/category/$categoryFilter?limit=$pageSize&skip=$skip';
      } else {
        // Mặc định: Lấy tất cả
        url = 'https://dummyjson.com/products?limit=$pageSize&skip=$skip';
      }

      final response = await http.get(Uri.parse(url)).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Request timeout');
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> productsList = data['products'] ?? [];

        return productsList.map((json) {
          double usdPrice = json['price'].toDouble();
          int vndPrice = (usdPrice * 24000).toInt();
          
          double discount = json['discountPercentage'].toDouble();
          int originalPrice = (vndPrice / (1 - (discount / 100))).toInt();

          final String apiCategory = json['category'].toString().toLowerCase();
          final String vietnameseCategory = _getCategoryVietnamse(apiCategory);

          return Product(
            id: json['id'].toString(),
            name: json['title'], 
            price: vndPrice,
            originalPrice: originalPrice,
            imageUrls: List<String>.from(json['images'] ?? []), 
            tags: [
              vietnameseCategory,
              'Giảm ${discount.toInt()}%'
            ], 
            soldCount: json['stock'] * 12,
          );
        }).toList();
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      print('Lỗi fetch DummyJSON API: $e');
    }
    return <Product>[];
  }
}

