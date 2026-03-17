# 🔐 Firebase Security Setup - Hướng Dẫn An Toàn

## 📋 Tổng Quan

Ứng dụng này sử dụng **kết hợp 2 chiến lược bảo mật**:

1. **Environment Variables** (`.env`) - Quản lý API Keys an toàn
2. **Firestore Security Rules** - Kiểm soát truy cập dữ liệu

---

## 🛠️ Cách Setup

### **Bước 1: Kiểm Tra File `.env`**

```bash
# File: .env (đã có sẵn, KHÔNG commit lên Git)
FIREBASE_WEB_API_KEY=YOUR_WEB_API_KEY_HERE
FIREBASE_WEB_APP_ID=YOUR_WEB_APP_ID_HERE
# ... các key khác
```

✅ File này **KHÔNG** sẽ được push lên GitHub (đã trong `.gitignore`)

---

### **Bước 2: Cài Dependencies**

```bash
flutter pub get
```

Điều này sẽ cài đặt `flutter_dotenv` từ `pubspec.yaml`

---

### **Bước 3: Configure Firestore Security Rules**

#### **Bước 3.1: Truy cập Firebase Console**

```
Đi tới: https://console.firebase.google.com/
Chọn project: commerceapp-30c05
Vào: Firestore Database → Rules
```

#### **Bước 3.2: Copy Security Rules**

1. Mở file `FIRESTORE_RULES.js` trong project này
2. Copy toàn bộ nội dung
3. Paste vào Firebase Console (Replace all)
4. Click **Publish**

---

## 🔒 Security Rules Explanation

### **Public Access:**

```javascript
// Mọi người có thể đọc sản phẩm
match /products/{document=**} {
  allow read: if true;        // ✅ Công khai
  allow write: if false;      // ❌ Không ai có thể ghi trực tiếp
}
```

### **User Private Data:**

```javascript
// User chỉ có thể thấy/sửa dữ liệu riêng của mình
match /users/{userId} {
  allow read: if isOwner(userId);    // ✅ Chỉ chủ sở hữu
  allow write: if isOwner(userId);   // ✅ Chỉ chủ sở hữu
}
```

### **Admin Access:**

```javascript
// Admin có thể quản lý tất cả
allow read, write: if isAdmin();   // ✅ Admin có quyền tối đa
```

---

## 📁 File Structure

```
lib/
├── config/
│   ├── app_data_config.dart       # Flag Firebase on/off
│   └── firebase_config.dart       # ⭐ Load từ .env
├── firebase_options.dart          # ⭐ Sử dụng FirebaseConfig
└── main.dart                       # ⭐ Gọi FirebaseConfig.load()

.env                                # ⭐ Quản lý keys (KHÔNG COMMIT)
.gitignore                          # ⭐ Bảo vệ .env
FIRESTORE_RULES.js                 # ⭐ Quy tắc bảo mật
```

---

## ⚠️ Lưu Ý Quan Trọng

### **1. Không Commit `.env` Lên GitHub**

```bash
# ✅ ĐÚNG - File sẽ bị ignore
git add .
git commit -m "Setup Firebase with env variables"

# ❌ SAI - Tuyệt đối không làm việc này
git add .env
git commit -m "Add API keys"
```

### **2. Cấp Quyền Cho Firebase**

- Firestore Keys là **public** (không lẽ giấu)
- Nhưng **Security Rules** sẽ kiểm soát ai có quyền truy cập
- Vì vậy Keys công khai nhưng **an toàn**

### **3. Thay Đổi Keys**

Nếu nghi ngờ keys bị lộ:

```bash
# 1. Vào Firebase Console → Vô hiệu hóa keys cũ
# 2. Tọc keys mới vào .env
# 3. Run: flutter pub get
# 4. Test ứng dụng
```

---

## 🧪 Test Setup

### **Test 1: Kiểm Tra Environment Variables**

```dart
// lib/main.dart - thêm dòng này để test
import 'config/firebase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.load();

  // Test: In ra để kiểm tra
  print('Web API Key: ${FirebaseConfig.webApiKey}');
  print('Project ID: ${FirebaseConfig.webProjectId}');

  // ...
}
```

### **Test 2: Kiểm Tra Firestore Rules**

1. Tạo user test
2. Login
3. Cố gắng đọc sản phẩm ✅ (nên thành)
4. Cố gắng sửa đơn hàng người khác ❌ (nên fail)

---

## 🔄 Production Deployment

### **Khi Deploy:**

1. **Web/Mobile**: Bản cũ của `.env` vừa đủ
2. **Backend**: Yêu cầu keys riêng (nếu có backend server)
3. **Firebase Console**: Security Rules vẫn bảo vệ dữ liệu

---

## 📚 Tài Liệu Tham Khảo

- [Flutter dotenv Package](https://pub.dev/packages/flutter_dotenv)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/start)
- [Firebase Best Practices](https://firebase.google.com/docs/guides/security-checklist)

---

## ❓ FAQ

**Q: Có nguy hiểm nếu keys bị lộ không?**

> A: Không, vì Firestore Security Rules sẽ chặn các truy cập không hợp lệ.

**Q: Nếu muốn hide keys hoàn toàn?**

> A: Sử dụng Backend Proxy (Cloud Functions), xem `FIREBASE_ADVANCED.md`

**Q: `.env` có nên commit không?**

> A: KHÔNG! Nó đã trong `.gitignore`. Thay vào đó cung cấp `.env.example`

---

## 🚀 Next Steps

1. ✅ Setup `.env` và Dependencies
2. ✅ Configure Firestore Rules
3. ✅ Test ứng dụng
4. ❌ Tuyệt đối KHÔNG commit `.env`
5. 🚀 Deploy!

---

**Bạn đã sẵn sàng để sử dụng Firebase một cách an toàn! 🎉**
