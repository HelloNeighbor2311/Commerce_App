import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'config/app_data_config.dart';
import 'firebase_options.dart';
import 'providers/cart_provider.dart';
import 'providers/order_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  if (AppDataConfig.useFirebase) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final cartProvider = CartProvider();
  final orderProvider = OrderProvider();

  runApp(
    MiniCommerceApp(cartProvider: cartProvider, orderProvider: orderProvider),
  );
}

class MiniCommerceApp extends StatelessWidget {
  const MiniCommerceApp({
    super.key,
    required this.cartProvider,
    required this.orderProvider,
  });

  final CartProvider cartProvider;
  final OrderProvider orderProvider;

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Mini Commerce App',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
