import 'package:flutter/material.dart';
import '../models/product.dart';
import '../state/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/currency.dart';
import '../widgets/custom_button.dart';
import '../widgets/food_illustration.dart';
import '../widgets/quantity_selector.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});
  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  static const double _headerHeight = 290;
  int _qty = 1;
  final _noteCtrl = TextEditingController();

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _addAndOpenCart() {
    CartScope.of(context).add(widget.product, quantity: _qty, note: _noteCtrl.text.trim());
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final cart = CartScope.of(context);
    final fav = cart.isFavorite(p.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, box) {
              return Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: _headerHeight + 40,
                    child: FoodIllustration(product: p),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: _headerHeight),
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(minHeight: box.maxHeight - _headerHeight),
                          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.sheet)),
                          ),
                          child: _content(p),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RoundIconButton(
                            icon: Icons.arrow_back,
                            circle: true,
                            size: 46,
                            onTap: () => Navigator.pop(context),
                          ),
                          RoundIconButton(
                            icon: fav ? Icons.favorite : Icons.favorite_border,
                            iconColor: fav ? AppColors.danger : AppColors.textPrimary,
                            circle: true,
                            size: 46,
                            onTap: () => cart.toggleFavorite(p.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.only(bottom: 16),
              child: CustomButton(
                label: 'Tambah  •  ${rupiah(p.price * _qty)}',
                onPressed: _addAndOpenCart,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _content(Product p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.category == 'Makanan' ? 'MAKANAN UTAMA' : p.category.toUpperCase(),
          style: const TextStyle(
            fontSize: 12,
            letterSpacing: 1.6,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(p.name, style: AppText.contentTitle),
        const SizedBox(height: AppSpacing.md),
        Row(children: [
          const Icon(Icons.star_rounded, color: AppColors.star, size: 20),
          const SizedBox(width: 6),
          Text('${p.rating}', style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(width: 6),
          Text('· ${p.reviews} ulasan',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        ]),
        const SizedBox(height: AppSpacing.md),
        Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [
          Text(rupiah(p.price),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
          if (p.oldPrice != null) ...[
            const SizedBox(width: 10),
            Text(rupiah(p.oldPrice!),
                style: const TextStyle(
                  fontSize: 15,
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.lineThrough,
                )),
          ],
        ]),
        const SizedBox(height: 12),
        Text(p.description,
            style: AppText.body.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.lg),
        const Divider(color: AppColors.border, height: 1),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Porsi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            QuantitySelector(
              value: _qty,
              onMinus: () => setState(() {
                if (_qty > 1) _qty--;
              }),
              onPlus: () => setState(() => _qty++),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const Text('Catatan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _noteCtrl,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Contoh: tanpa bawang, sambal dipisah',
            hintStyle: const TextStyle(color: Color(0xFFA9B1C3), fontSize: 14),
            filled: true,
            fillColor: const Color(0xFFFAFAFC),
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
      ],
    );
  }
}
