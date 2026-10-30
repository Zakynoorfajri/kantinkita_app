import 'package:flutter/material.dart';
import 'screens/profile_screen.dart';
import 'state/cart_controller.dart';
import 'theme/app_theme.dart';

void main() => runApp(const FoodApp());

class FoodApp extends StatefulWidget {
  const FoodApp({super.key});

  @override
  State<FoodApp> createState() => _FoodAppState();
}

class _FoodAppState extends State<FoodApp> {
  final _cart = CartController();

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CartScope(
      controller: _cart,
      child: MaterialApp(
        title: 'Kantin kita',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        // Di web/tablet, tampilan dibatasi selebar layar ponsel agar mirip desain.
        builder: (context, child) => ColoredBox(
          color: AppColors.background,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: child ?? const SizedBox.shrink(),
            ),
          ),
        ),
        home: const ProfileScreen(),
      ),
    );
  }
}
