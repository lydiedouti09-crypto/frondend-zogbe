import 'dish.dart';

class CartItem {
  final String id;
  final Dish dish;
  int quantity;
  final List<DishOption> selectedOptions;

  CartItem({
    required this.id,
    required this.dish,
    this.quantity = 1,
    List<DishOption>? selectedOptions,
  }) : selectedOptions = selectedOptions ?? [];

  double get unitPrice {
    double base = dish.prix;
    double optionsTotal = selectedOptions.fold(0.0, (sum, opt) => sum + opt.prix);
    return base + optionsTotal;
  }

  double get totalPrice => unitPrice * quantity;

  String get formattedTotalPrice {
    String priceInt = totalPrice.toInt().toString();
    if (priceInt.length > 3) {
      String formatted = '${priceInt.substring(0, priceInt.length - 3)} ${priceInt.substring(priceInt.length - 3)}';
      return '$formatted FCFA';
    }
    return '$priceInt FCFA';
  }
}
