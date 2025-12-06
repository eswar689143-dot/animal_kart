import 'dart:convert';
import 'dart:io';

import 'package:animal_kart_demo2/auth/models/addbuffalo_model.dart';
import 'package:animal_kart_demo2/auth/models/removeCart_model.dart';
import 'package:animal_kart_demo2/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;


/// ONE PROVIDER FOR FULL CART FEATURE
final cartProvider = ChangeNotifierProvider<CartProvider>(
  (ref) => CartProvider(),
);

class CartProvider extends ChangeNotifier {
  bool _isLoading = false;

  AddToCartModel? _addToCartResult;
  CartResponseModel? _cartResponse;

  // GETTERS
  bool get isLoading => _isLoading;
  AddToCartModel? get addToCartResult => _addToCartResult;
  CartResponseModel? get cartResponse => _cartResponse;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // POST API → ADD TO CART
  Future<bool> addToCart({
    required String userMobile,
    required String productId,
    required String productType,
    required int quantity,
  }) async {
    _setLoading(true);

    try {
      final url = '${AppConstants.apiUrl}/cart/add';

      final res = await http.post(
        Uri.parse(url),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        },
        body: jsonEncode({
          "user_mobile": userMobile,
          "product_id": productId,
          "product_type": productType,
          "quantity": quantity,
        }),
      );

      final jsonBody = json.decode(res.body);
      _addToCartResult = AddToCartModel.fromJson(jsonBody);

      return res.statusCode == 200 || res.statusCode == 201;
    } catch (e) {
      print("Add to cart error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // ✅ GET API → FETCH CART
  Future<bool> fetchCart(String userMobile) async {
    _setLoading(true);

    try {
      final url = '${AppConstants.apiUrl}/cart/$userMobile';

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final jsonBody = json.decode(res.body);
        _cartResponse = CartResponseModel.fromJson(jsonBody);
        return true;
      } else {
        print("Fetch cart failed: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      print("Fetch cart error: $e");
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
