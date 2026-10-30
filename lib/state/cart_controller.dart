import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// State keranjang + favorit, dibagikan ke seluruh halaman lewat [CartScope].
class CartController extends ChangeNotifier {
  static const serviceFee = 2000;

  final List<CartItem> _items = [];
  final Set<String> _favorites = {};
  String orderNote = '';

  List<CartItem> get items => List.unmodifiable(_items);
  int get totalQuantity => _items.fold(0, (s, i) => s + i.quantity);
  int get subtotal => _items.fold(0, (s, i) => s + i.total);
  int get total => _items.isEmpty ? 0 : subtotal + serviceFee;

  bool isFavorite(String id) => _favorites.contains(id);

  void toggleFavorite(String id) {
    _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id);
    notifyListeners();
  }

  void add(Product product, {int quantity = 1, String note = ''}) {
    final idx = _items.indexWhere((i) => i.product.id == product.id);
    if (idx >= 0) {
      _items[idx].quantity += quantity;
      if (note.isNotEmpty) _items[idx].note = note;
    } else {
      _items.add(CartItem(product: product, quantity: quantity, note: note));
    }
    notifyListeners();
  }

  void increment(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void decrement(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      _items.remove(item);
    }
    notifyListeners();
  }

  void remove(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    orderNote = '';
    notifyListeners();
  }
}

class CartScope extends InheritedNotifier<CartController> {
  const CartScope({
    super.key,
    required CartController controller,
    required super.child,
  }) : super(notifier: controller);

  static CartController of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CartScope>()!.notifier!;
  }
}
