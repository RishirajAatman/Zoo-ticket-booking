import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cart_item.dart';

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super(const []);

  static int calculateGst(int ticketTotal, {double rate = 0.05}) {
    return (ticketTotal * rate).round();
  }

  void addItem(CartItem item) {
    final index = state.indexWhere((entry) => entry.title == item.title);
    if (index == -1) {
      state = [...state, item];
      return;
    }

    final existing = state[index];
    final updated = CartItem(
      title: existing.title,
      price: existing.price,
      quantity: existing.quantity + item.quantity,
    );

    final updatedList = [...state];
    updatedList[index] = updated;
    state = updatedList;
  }

  void removeItem(String title) {
    state = state.where((entry) => entry.title != title).toList();
  }

  void clear() {
    state = const [];
  }

  void incrementQuantity(String title) {
    _updateQuantity(title, 1);
  }

  void decrementQuantity(String title) {
    _updateQuantity(title, -1);
  }

  int get totalPrice {
    return state.fold(0, (total, item) => total + item.price * item.quantity);
  }

  int get gstAmount => calculateGst(totalPrice);

  void _updateQuantity(String title, int delta) {
    final index = state.indexWhere((entry) => entry.title == title);
    if (index == -1) return;

    final item = state[index];
    final newQuantity = item.quantity + delta;
    if (newQuantity < 0) return;

    if (newQuantity == 0) {
      removeItem(title);
      return;
    }

    final updated = CartItem(
      title: item.title,
      price: item.price,
      quantity: newQuantity,
    );

    final updatedList = [...state];
    updatedList[index] = updated;
    state = updatedList;
  }
}
