import 'package:flutter/material.dart';
import '../data/dummy_products.dart';
import '../models/product.dart';
import '../state/cart_controller.dart';
import '../theme/app_theme.dart';
import '../widgets/category_filter.dart';
import '../widgets/custom_button.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String _query = '';
  String _category = 'Semua';
  bool _showAll = false;

  List<Product> get _filtered {
    final q = _query.trim().toLowerCase();
    return dummyProducts
        .where((p) =>
            (_category == 'Semua' || p.category == _category) && p.name.toLowerCase().contains(q))
        .toList();
  }

  void _addToCart(Product p) {
    CartScope.of(context).add(p);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('${p.name} ditambahkan ke keranjang'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ));
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final all = _filtered;
    final items = _showAll ? all : all.take(6).toList();

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Menu', style: AppText.screenTitle),
                    Badge(
                      label: Text('${cart.totalQuantity}'),
                      isLabelVisible: cart.totalQuantity > 0,
                      backgroundColor: AppColors.primary,
                      child: RoundIconButton(
                        icon: Icons.shopping_cart_outlined,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                child: TextField(
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Cari menu atau minuman',
                    hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.field),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.field),
                      borderSide: const BorderSide(color: AppColors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppRadius.field),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: CategoryFilter(
                categories: categories,
                selected: _category,
                onSelected: (c) => setState(() => _category = c),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_showAll ? 'Semua menu' : 'Populer hari ini',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    GestureDetector(
                      onTap: () => setState(() => _showAll = !_showAll),
                      child: Text(_showAll ? 'Ringkas' : 'Lihat semua',
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.primary)),
                    ),
                  ],
                ),
              ),
            ),
            if (items.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text('Menu tidak ditemukan',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    mainAxisExtent: 270,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final p = items[i];
                      return ProductCard(
                        product: p,
                        onAdd: () => _addToCart(p),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p)),
                        ),
                      );
                    },
                    childCount: items.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
