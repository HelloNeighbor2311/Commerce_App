/**
 * ========================================
 * FIREBASE SECURITY RULES
 * ========================================
 * 
 * Copy các rules này vào Firebase Console:
 * Firestore Database → Rules Tab
 * 
 * Chiến lược bảo mật:
 * - Người dùng chưa xác thực: chỉ đọc danh sách sản phẩm
 * - Người dùng đã xác thực: đọc/ghi dữ liệu của riêng mình
 * - Admin: đọc/ghi tất cả dữ liệu
 */

rules_version = '2';

service cloud.firestore {
  match /databases/{database}/documents {
    
    // ========================================
    // Helper Functions
    // ========================================
    
    /// Kiểm tra user đã xác thực
    function isAuthenticated() {
      return request.auth != null;
    }
    
    /// Kiểm tra user là chủ sở hữu dữ liệu
    function isOwner(userId) {
      return isAuthenticated() && request.auth.uid == userId;
    }
    
    /// Kiểm tra user là admin
    function isAdmin() {
      return isAuthenticated() && 
             get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    /// Kiểm tra dữ liệu hợp lệ khi tạo order
    function isValidOrder() {
      let data = request.resource.data;
      return data.keys().hasAll(['createdAt', 'address', 'paymentMethod', 'items', 'status']) &&
             data.createdAt is timestamp &&
             data.address is string && data.address.size() > 0 &&
             data.paymentMethod is string &&
             data.items is list && data.items.size() > 0 &&
             data.status in ['pending', 'shipping', 'delivered', 'cancelled'];
    }
    
    // ========================================
    // PRODUCTS Collection
    // ========================================
    
    /// Mọi người có thể đọc danh sách sản phẩm
    match /products/{document=**} {
      allow read: if true;
      allow write: if false; // Chỉ Firebase (backend) có thể ghi
    }
    
    // ========================================
    // USERS Collection
    // ========================================
    
    match /users/{userId} {
      /// User chỉ có thể đọc/ghi thông tin của chính mình
      allow read: if isOwner(userId);
      allow write: if isOwner(userId);
      
      /// Sub-collection: User preferences
      match /preferences/{document=**} {
        allow read: if isOwner(userId);
        allow write: if isOwner(userId);
      }
    }
    
    // ========================================
    // ORDERS Collection
    // ========================================
    
    match /orders/{orderId} {
      /// User chỉ có thể đọc đơn hàng của chính mình
      allow read: if isOwner(resource.data.userId);
      
      /// User có thể tạo đơn hàng cho chính mình
      allow create: if isAuthenticated() &&
                       request.resource.data.userId == request.auth.uid &&
                       isValidOrder();
      
      /// User có thể cập nhật đơn hàng của chính mình (nhưng không sửa userId)
      allow update: if isOwner(resource.data.userId) &&
                       request.resource.data.userId == resource.data.userId;
      
      /// Admin có thể đọc/ghi tất cả đơn hàng
      allow read, write: if isAdmin();
    }
    
    // ========================================
    // CART Collection
    // ========================================
    
    match /carts/{userId} {
      /// User chỉ có thể đọc/ghi giỏ hàng của chính mình
      allow read, write: if isOwner(userId);
      
      /// Admin có thể quản lý tất cả giỏ hàng
      allow read, write: if isAdmin();
      
      /// Sub-collection: Giỏ hàng items
      match /items/{itemId} {
        allow read, write: if isOwner(userId);
        allow read, write: if isAdmin();
      }
    }
    
    // ========================================
    // REVIEWS Collection
    // ========================================
    
    match /reviews/{reviewId} {
      /// Mọi người có thể đọc review
      allow read: if true;
      
      /// User đã xác thực có thể tạo review
      allow create: if isAuthenticated() &&
                       request.resource.data.userId == request.auth.uid &&
                       request.resource.data.createdAt == request.time;
      
      /// User chỉ có thể sửa review của chính mình
      allow update: if isOwner(resource.data.userId) &&
                       request.resource.data.userId == resource.data.userId;
      
      /// User chỉ có thể xóa review của chính mình
      allow delete: if isOwner(resource.data.userId);
      
      /// Admin có thể quản lý tất cả review
      allow read, write, delete: if isAdmin();
    }
    
    // ========================================
    // DEFAULT: Từ chối tất cả
    // ========================================
    
    match /{document=**} {
      allow read, write: if false;
    }
  }
}
