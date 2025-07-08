import 'package:dummy_page/providers/theme_provider.dart';
import 'package:dummy_page/screens/cart_screen.dart';
import 'package:dummy_page/screens/login_screen.dart';
import 'package:dummy_page/screens/profile_screen.dart';
import 'package:dummy_page/screens/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dummy_page/models/cart_model.dart';
import 'package:dummy_page/models/wishlist_model.dart';
import 'package:dummy_page/screens/splash_screen.dart';
import 'package:dummy_page/screens/category_screen.dart';

import 'models/OrderModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔒 Force portrait mode
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 🔌 Initialize Firebase
  try {
    await Firebase.initializeApp();
    print("✅ Firebase connected successfully!");
  } catch (e) {
    print("❌ Firebase initialization failed: $e");
  }

  runApp(const DummyProductsApp());
}

class DummyProductsApp extends StatelessWidget {
  const DummyProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => WishlistModel()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => OrderModel(),
        ),

      ],
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Dummy Products',
            themeMode: themeProvider.currentTheme,
            theme: ThemeData(
              primarySwatch: Colors.deepPurple,
              scaffoldBackgroundColor: Colors.grey[100],
            ),
            darkTheme: ThemeData.dark(),
            home: const SplashScreen(),
            routes: {
              '/login': (_) => LoginScreen(),
              '/signup': (_) => SignupScreen(),
              '/category': (_) => const CategoryScreen(),
              '/cart': (_) => const CartScreen(),
              '/profile': (_) => const ProfileScreen(),
            },
          );
        },
      ),
    );
  }
}
