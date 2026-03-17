import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MiniCommerceApp(),
    ),
  );
}

class MiniCommerceApp extends StatelessWidget {
  const MiniCommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'N7-TH4-CommerceApp',
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
