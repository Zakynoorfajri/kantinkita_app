import 'product.dart';

class CartItem {
  CartItem({required this.product, this.quantity = 1, this.note = ''});

  final Product product;
  int quantity;
  String note;

  int get total => product.price * quantity;
}
