import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../state/cart_controller.dart';
import '../theme/app_theme.dart';
import '../utils/currency.dart';
import '../widgets/custom_button.dart';
import '../widgets/food_illustration.dart';
import '../widgets/quantity_selector.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _noteCtrl = TextEditingController();
  bool _noteInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_noteInit) {
      _noteCtrl.text = CartScope.of(context).orderNote;
      _noteInit = true;
    }
  }

  @override
  void dispose() {
    _noteCtrl.dispose();
    super.dispose();
  }

  void _backToMenu() => Navigator.popUntil(context, (r) => r.settings.name == '/menu' || r.isFirst);

  Future<void> _order() async {
    final cart = CartScope.of(context);
    final total = cart.total;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Pesanan dibuat 🎉'),
        content: Text('Total pembayaran ${rupiah(total)}. Pesanan Anda sedang diproses.'),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
      ),
    );
    if (!mounted) return;
    cart.clear();
    _noteCtrl.clear();
    _backToMenu();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    final items = cart.items;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Row(children: [
                RoundIconButton(icon: Icons.arrow_back, onTap: _backToMenu),
                const SizedBox(width: 16),
                const Text('Keranjang', style: AppText.screenTitle),
              ]),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.textSecondary),
                          const SizedBox(height: 12),
                          const Text('Keranjang masih kosong',
                              style: TextStyle(color: AppColors.textSecondary)),
                          const SizedBox(height: 16),
                          TextButton(onPressed: _backToMenu, child: const Text('Lihat Menu')),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(24, 4, 24, 24),
                      children: [
                        for (final item in items) ...[
                          _CartRow(item: item, cart: cart),
                          const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 8),
                        const Text('Catatan pesanan',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _noteCtrl,
                          maxLines: 2,
                          onChanged: (v) => cart.orderNote = v,
                          decoration: InputDecoration(
                            hintText: 'Contoh: antar ke lobi, jangan pakai sedotan',
                            hintStyle: const TextStyle(color: Color(0xFFA9B1C3), fontSize: 14),
                            filled: true,
                            fillColor: Colors.white,
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
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            boxShadow: AppTheme.softShadow,
                          ),
                          child: Column(children: [
                            _SummaryRow('Subtotal', rupiah(cart.subtotal)),
                            const SizedBox(height: 8),
                            _SummaryRow('Biaya layanan', rupiah(CartController.serviceFee)),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Divider(height: 1, color: AppColors.border),
                            ),
                            _SummaryRow('Total', rupiah(cart.total), bold: true),
                          ]),
                        ),
                      ],
                    ),
            ),
            if (items.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                child: CustomButton(label: 'Buat Pesanan', onPressed: _order),
              ),
          ],
        ),
      ),
    );
  }
}

class _CartRow extends StatelessWidget {
  const _CartRow({required this.item, required this.cart});
  final CartItem item;
  final CartController cart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(width: 80, height: 80, child: FoodIllustration(product: item.product)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                if (item.note.isNotEmpty)
                  Text(item.note,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary)),
                const SizedBox(height: 4),
                Text(rupiah(item.total),
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary)),
                const SizedBox(height: 6),
                QuantitySelector(
                  compact: true,
                  value: item.quantity,
                  onMinus: () => cart.decrement(item),
                  onPlus: () => cart.increment(item),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => cart.remove(item),
            icon: const Icon(Icons.delete_outline, color: AppColors.danger),
            tooltip: 'Hapus',
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow(this.label, this.value, {this.bold = false});
  final String label;
  final String value;
  final bool bold;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 16 : 14,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      color: bold ? AppColors.textPrimary : AppColors.textSecondary,
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: bold ? style.copyWith(color: AppColors.primary) : style),
      ],
    );
  }
}
