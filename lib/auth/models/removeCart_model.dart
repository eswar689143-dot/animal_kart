// cart_response_model.dart

class CartResponseModel {
  final int statusCode;
  final String status;
  final CartData? cart;

  CartResponseModel({
    required this.statusCode,
    required this.status,
    this.cart,
  });

  factory CartResponseModel.fromJson(Map<String, dynamic> json) {
    return CartResponseModel(
      statusCode: json['statuscode'] is int
          ? json['statuscode']
          : int.tryParse(json['statuscode']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? '',
      cart: json['cart'] != null ? CartData.fromJson(json['cart']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statuscode': statusCode,
      'status': status,
      'cart': cart?.toJson(),
    };
  }
}

// ---------------------------------------------------

class CartData {
  final String userMobile;
  final List<CartItem> items;
  final int totalAmount;
  final int totalItems;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartData({
    required this.userMobile,
    required this.items,
    required this.totalAmount,
    required this.totalItems,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      userMobile: json['user_mobile']?.toString() ?? '',
      items: json['items'] != null
          ? List<CartItem>.from(
              json['items'].map((e) => CartItem.fromJson(e)),
            )
          : [],
      totalAmount:
          json['total_amount'] is int ? json['total_amount'] : int.tryParse(json['total_amount']?.toString() ?? '0') ?? 0,
      totalItems:
          json['total_items'] is int ? json['total_items'] : int.tryParse(json['total_items']?.toString() ?? '0') ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_mobile': userMobile,
      'items': items.map((e) => e.toJson()).toList(),
      'total_amount': totalAmount,
      'total_items': totalItems,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ---------------------------------------------------

class CartItem {
  final String productId;
  final String productType;
  final int quantity;
  final String? unitName;
  final int pricePerUnit;
  final int totalPrice;
  final DateTime addedAt;

  CartItem({
    required this.productId,
    required this.productType,
    required this.quantity,
    this.unitName,
    required this.pricePerUnit,
    required this.totalPrice,
    required this.addedAt,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['product_id']?.toString() ?? '',
      productType: json['product_type']?.toString() ?? '',
      quantity: json['quantity'] is int
          ? json['quantity']
          : int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      unitName: json['unit_name']?.toString(),
      pricePerUnit: json['price_per_unit'] is int
          ? json['price_per_unit']
          : int.tryParse(json['price_per_unit']?.toString() ?? '0') ?? 0,
      totalPrice: json['total_price'] is int
          ? json['total_price']
          : int.tryParse(json['total_price']?.toString() ?? '0') ?? 0,
      addedAt: DateTime.parse(json['added_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_type': productType,
      'quantity': quantity,
      'unit_name': unitName,
      'price_per_unit': pricePerUnit,
      'total_price': totalPrice,
      'added_at': addedAt.toIso8601String(),
    };
  }
}
