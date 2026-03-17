# 🔐 Firebase + Environment Variables Setup Guide

## ✅ Đã Hoàn Tất

Ứng dụng của bạn đã được configure với **kết hợp 2 cách bảo mật tối ưu**:

### **Cách 1️⃣: Environment Variables** (.env)

- ✅ Tạo file `.env` chứa Firebase keys
- ✅ Cài dependencies `flutter_dotenv` trong `pubspec.yaml`
- ✅ Tạo `lib/config/firebase_config.dart` để load keys
- ✅ Cập nhật `lib/firebase_options.dart` dùng FirebaseConfig
- ✅ Cập nhật `.gitignore` để bảo vệ `.env`

### **Cách 2️⃣: Firestore Security Rules**

- ✅ Tạo `FIRESTORE_RULES.js` với quy tắc bảo mật
- ✅ Cho phép public đọc sản phẩm
- ✅ Cho phép user chỉ truy cập dữ liệu của chính mình
- ✅ Cho phép admin quản lý tất cả

---

## 🚀 Cách Sử Dụng Ngay

### **1️⃣ Chạy App Bình Thường**

```bash
cd d:\PTUD\commerce_app
flutter pub get
flutter run
```

**Lưu ý:** File `.env` đã có sẵn keys thực của bạn, không cần làm gì thêm.

---

### **2️⃣ Configure Firestore Security Rules** (Quan Trọng!)

#### **Bước A: Vào Firebase Console**

```
https://console.firebase.google.com/
→ Chọn project: commerceapp-30c05
→ Firestore Database → Rules tab
```

#### **Bước B: Copy Security Rules**

1. Mở file `FIRESTORE_RULES.js` (trong thư mục root)
2. Copy toàn bộ nội dung (từ `rules_version` đến `}`)
3. Paste vào Firebase Console (thay thế tất cả)
4. Click **Publish**

✅ **Xong! Dữ liệu của bạn bây giờ được bảo vệ.**

---

## 📁 Các File Quan Trọng

| File                              | Mục Đích                | Commit? |
| --------------------------------- | ----------------------- | ------- |
| `.env`                            | Chứa Firebase keys thực | ❌ NO   |
| `.env.example`                    | Template cho team       | ✅ YES  |
| `FIRESTORE_RULES.js`              | Security rules          | ✅ YES  |
| `FIREBASE_SECURITY_SETUP.md`      | Hướng dẫn chi tiết      | ✅ YES  |
| `lib/config/firebase_config.dart` | Load env variables      | ✅ YES  |

---

## 🔍 Cách Hoạt Động

### **Quá trình Initialization:**

```
main.dart
  ↓
await FirebaseConfig.load()  (Load từ .env)
  ↓
Firebase.initializeApp() (Dùng FirebaseConfig)
  ↓
Firestore Security Rules kiểm tra quyền
  ↓
✅ App chạy an toàn
```

---

## 🛡️ Bảo Mật

### **Keys Công Khai Nhưng An Toàn**

- Firebase Web keys **bản chất là public** (không thể giấu)
- Nhưng **Firestore Security Rules** sẽ chặn tất cả truy cập không hợp lệ
- Vì vậy: **Keys công khai + Rules bảo vệ = An toàn**

### **Ví Dụ:**

```javascript
// Rule: User A cố gắng đọc đơn hàng của User B
match /orders/{orderId} {
  allow read: if isOwner(resource.data.userId);  // ❌ DENY!
}
```

---

## 🚫 KHÔNG ĐƯỢC LÀM

```bash
# ❌ SAI - Sẽ lộ keys lên GitHub
git add .env
git commit -m "Add Firebase keys"
git push

# ❌ SAI - Hardcode keys trong code
const apiKey = "REDACTED_GOOGLE_API_KEY";

# ❌ SAI - Commit firebase_options.dart nếu có keys
git add lib/firebase_options.dart
```

---

## ✅ NÊN LÀM

```bash
# ✅ ĐÚNG - .env sẽ tự động bị ignore
git add .
git commit -m "Setup Firebase with env variables"
git push

# ✅ ĐÚNG - Chia sẻ .env.example cho team
git add .env.example

# ✅ ĐÚNG - Commit Firebase config files
git add lib/config/firebase_config.dart
git add FIRESTORE_RULES.js
```

---

## 🔄 Team Collaboration

### **Khi Có Teammate Mới:**

1. **Teammate Clone Project:**

```bash
git clone <repository>
cd commerce_app
flutter pub get
```

2. **Teammate Tạo `.env` File:**

```bash
# Copy từ .env.example
cp .env.example .env

# Yêu cầu bạn cấp đúng Firebase keys
# Paste keys vào .env
```

3. **Chạy App:**

```bash
flutter run
```

**⚠️ LƯU Ý:** Mỗi developer cần `.env` riêng, KHÔNG chia sẻ file này!

---

## 🆘 Troubleshooting

### **Q: "firebase_options.dart not found"**

```
A: Đã được fix - file này sẽ tạo động từ FirebaseConfig
```

### **Q: ".env file not found"**

```
A: File .env đã tạo sẵn. Nếu bị mất:
   1. Tham khảo .env.example
   2. Tạo .env mới: copy anh .env.example
   3. Paste keys thực vào
```

### **Q: "Firestore rules error"**

```
A: 1. Vào Firebase Console
   2. Vào Firestore → Rules
   3. Xem error message
   4. Chỉnh sửa rules theo error
   5. Test rules trước khi publish
```

### **Q: "Permission Denied" khi truy cập Firestore**

```
A: Kiểm tra:
   1. User đã login chưa? (isAuthenticated())
   2. Data của user này đã được save chưa?
   3. Security Rules có match không?

   Debug: Thêm dòng này vào Rules
   allow read, write: if true;  // ⚠️ TEMP ONLY FOR TESTING
```

---

## 📚 Tài Liệu Thêm

- **Hướng dẫn Chi Tiết:** [FIREBASE_SECURITY_SETUP.md](FIREBASE_SECURITY_SETUP.md)
- **Firebase Rules Syntax:** [Firebase Docs](https://firebase.google.com/docs/firestore/security/start)
- **Flutter Dotenv:** [Pub.dev](https://pub.dev/packages/flutter_dotenv)

---

## 🎉 Bạn Đã Sẵn Sàng!

**Chúc mừng!** Ứng dụng của bạn bây giờ:

- ✅ Sử dụng Firebase một cách an toàn
- ✅ Không lộ keys lên GitHub
- ✅ Dữ liệu được bảo vệ bởi Security Rules
- ✅ Có thể dễ dàng chia sẻ code với team

**Tiếp theo:** Implement logic ứng dụng theo nhu cầu! 🚀

---

**Tổng hợp bởi:** AI Assistant
**Ngày:** 2026-03-17
**Status:** ✅ Production Ready
