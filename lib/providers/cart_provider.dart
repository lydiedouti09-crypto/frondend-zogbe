import 'package:flutter/foundation.dart';
import '../models/dish.dart';
import '../models/cart_item.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotalAmount => _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get deliveryFee => _items.isEmpty ? 0.0 : 500.0;

  double get totalAmount => subtotalAmount + deliveryFee;

  String get formattedSubtotal {
    String priceInt = subtotalAmount.toInt().toString();
    if (priceInt.length > 3) {
      String formatted = '${priceInt.substring(0, priceInt.length - 3)} ${priceInt.substring(priceInt.length - 3)}';
      return '$formatted FCFA';
    }
    return '$priceInt FCFA';
  }

  String get formattedTotal {
    String priceInt = totalAmount.toInt().toString();
    if (priceInt.length > 3) {
      String formatted = '${priceInt.substring(0, priceInt.length - 3)} ${priceInt.substring(priceInt.length - 3)}';
      return '$formatted FCFA';
    }
    return '$priceInt FCFA';
  }

  CartProvider() {
    // Initialisons avec les 2 articles de la maquette (badge "2")
    _items['demo_1'] = CartItem(
      id: 'demo_1',
      dish: Dish(
        id: 1,
        nom: 'PÂTE SAUCE GRAINE',
        description: 'Pâte maison avec sauce graine',
        prix: 2500.0,
        categorie: 'Pâte',
        image: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
      ),
      quantity: 1,
    );
    _items['demo_2'] = CartItem(
      id: 'demo_2',
      dish: Dish(
        id: 4,
        nom: 'POULET BRAISÉ',
        description: 'Poulet mariné et braisé',
        prix: 3000.0,
        categorie: 'Grillades',
        image: 'https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80',
      ),
      quantity: 1,
    );
  }

  void addItem(Dish dish, {int quantity = 1, List<DishOption>? options}) {
    String key = '${dish.id}_${(options ?? []).map((o) => o.id).join('_')}';

    if (_items.containsKey(key)) {
      _items[key]!.quantity += quantity;
    } else {
      _items[key] = CartItem(
        id: key,
        dish: dish,
        quantity: quantity,
        selectedOptions: options ?? [],
      );
    }
    notifyListeners();
  }

  void updateQuantity(String cartItemId, int newQuantity) {
    if (_items.containsKey(cartItemId)) {
      if (newQuantity <= 0) {
        _items.remove(cartItemId);
      } else {
        _items[cartItemId]!.quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeItem(String cartItemId) {
    _items.remove(cartItemId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
