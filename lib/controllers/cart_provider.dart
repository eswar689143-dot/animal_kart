import 'dart:convert';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final int qty; 
  final int insuranceUnits; 

  CartItem({
    required this.qty,
    required this.insuranceUnits,
  });

  Map<String, dynamic> toJson() =>
      {"qty": qty, "insuranceUnits": insuranceUnits};

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        qty: json["qty"],
        insuranceUnits: json["insuranceUnits"],
      );
}

class CartController extends StateNotifier<Map<String, CartItem>> {
  CartController() : super({}) {
    _loadCart();
  }

  // LOAD CART
  Future<void> _loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString("cartData");

    if (jsonString == null) return;

    final decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    final loaded = decoded.map(
      (key, value) =>
          MapEntry(key, CartItem.fromJson(value as Map<String, dynamic>)),
    );

    state = loaded;
  }

  // SAVE CART
  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded =
        jsonEncode(state.map((key, item) => MapEntry(key, item.toJson())));
    prefs.setString("cartData", encoded);
  }

  // CLEAR CART
  Future<void> clearCart() async {
    state = {};
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("cartData");
  }

  // ADD / UPDATE ITEM
  void setItem(String id, int qty, int insuranceUnits) {
    if (qty <= 0) {
      remove(id);
      return;
    }

    // insurance cannot be more than qty
    if (insuranceUnits > qty) {
      insuranceUnits = qty;
    }

    state = {
      ...state,
      id: CartItem(qty: qty, insuranceUnits: insuranceUnits),
    };

    _saveCart();
  }

  // REMOVE ITEM
  void remove(String id) {
    final copy = {...state};
    copy.remove(id);
    state = copy;
    _saveCart();
  }

  // UNIT INCREASE
  void increaseUnits(String id) {
    final old = state[id]!;
    setItem(id, old.qty + 1, old.insuranceUnits);
  }

  // UNIT DECREASE
  void decreaseUnits(String id) {
    final old = state[id]!;
    setItem(id, old.qty - 1, old.insuranceUnits);
  }

  // INSURANCE INCREASE
  void increaseInsurance(String id) {
    final old = state[id]!;
    if (old.insuranceUnits >= old.qty) return;
    setItem(id, old.qty, old.insuranceUnits + 1);
  }

  // INSURANCE DECREASE
  void decreaseInsurance(String id) {
    final old = state[id]!;
    if (old.insuranceUnits <= 0) return;
    setItem(id, old.qty, old.insuranceUnits - 1);
  }
}

final cartProvider =
    StateNotifierProvider<CartController, Map<String, CartItem>>(
  (ref) => CartController(),
);
