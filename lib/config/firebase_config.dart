class FirebaseConfig {
  const FirebaseConfig._();

  static String _env(String key, String fallback) {
    // No runtime env loader configured. Trả về fallback cố định.
    // Nếu bạn muốn dùng dotenv, thêm package flutter_dotenv vào pubspec và gọi dotenv.load tại main.
    return fallback;
  }

  static String get webApiKey =>
      _env('FIREBASE_WEB_API_KEY', 'AIzaSyBVbDgIG3ah9PByiVpS3N3_IaiA1W6ceuI');
  static String get webAppId =>
      _env('FIREBASE_WEB_APP_ID', '1:131409528913:web:0f817d2e389f6e5a1dd070');
  static String get webMessagingSenderId =>
      _env('FIREBASE_WEB_MESSAGING_SENDER_ID', '131409528913');
  static String get webProjectId =>
      _env('FIREBASE_WEB_PROJECT_ID', 'commerceapp-30c05');
  static String get webAuthDomain =>
      _env('FIREBASE_WEB_AUTH_DOMAIN', 'commerceapp-30c05.firebaseapp.com');
  static String get webStorageBucket => _env(
    'FIREBASE_WEB_STORAGE_BUCKET',
    'commerceapp-30c05.firebasestorage.app',
  );
  static String get webMeasurementId =>
      _env('FIREBASE_WEB_MEASUREMENT_ID', 'G-41E5VQT08V');

  static String get androidApiKey => _env(
    'FIREBASE_ANDROID_API_KEY',
    'AIzaSyC4AxkQRvwn2GRrfkGPlpO1GnDzzGWKWJw',
  );
  static String get androidAppId => _env(
    'FIREBASE_ANDROID_APP_ID',
    '1:131409528913:android:646f00ccc94723dd1dd070',
  );
  static String get androidMessagingSenderId =>
      _env('FIREBASE_ANDROID_MESSAGING_SENDER_ID', '131409528913');
  static String get androidProjectId =>
      _env('FIREBASE_ANDROID_PROJECT_ID', 'commerceapp-30c05');
  static String get androidStorageBucket => _env(
    'FIREBASE_ANDROID_STORAGE_BUCKET',
    'commerceapp-30c05.firebasestorage.app',
  );
}
