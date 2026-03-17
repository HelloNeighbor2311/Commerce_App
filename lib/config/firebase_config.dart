import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Quản lý Firebase configuration từ environment variables
class FirebaseConfig {
  const FirebaseConfig._();

  /// Load environment variables từ .env file
  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }

  // Web Configuration
  static String get webApiKey => dotenv.env['FIREBASE_WEB_API_KEY'] ?? '';
  static String get webAppId => dotenv.env['FIREBASE_WEB_APP_ID'] ?? '';
  static String get webMessagingSenderId =>
      dotenv.env['FIREBASE_WEB_MESSAGING_SENDER_ID'] ?? '';
  static String get webProjectId => dotenv.env['FIREBASE_WEB_PROJECT_ID'] ?? '';
  static String get webAuthDomain =>
      dotenv.env['FIREBASE_WEB_AUTH_DOMAIN'] ?? '';
  static String get webStorageBucket =>
      dotenv.env['FIREBASE_WEB_STORAGE_BUCKET'] ?? '';
  static String get webMeasurementId =>
      dotenv.env['FIREBASE_WEB_MEASUREMENT_ID'] ?? '';

  // Android Configuration
  static String get androidApiKey =>
      dotenv.env['FIREBASE_ANDROID_API_KEY'] ?? '';
  static String get androidAppId => dotenv.env['FIREBASE_ANDROID_APP_ID'] ?? '';
  static String get androidMessagingSenderId =>
      dotenv.env['FIREBASE_ANDROID_MESSAGING_SENDER_ID'] ?? '';
  static String get androidProjectId =>
      dotenv.env['FIREBASE_ANDROID_PROJECT_ID'] ?? '';
  static String get androidStorageBucket =>
      dotenv.env['FIREBASE_ANDROID_STORAGE_BUCKET'] ?? '';
}
