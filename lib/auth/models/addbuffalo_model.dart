class AddToCartModel {
  int statusCode;
  String status;
  String message;
  CartData? item;

  AddToCartModel({
    required this.statusCode,
    required this.status,
    required this.message,
    this.item,
  });

  factory AddToCartModel.fromJson(Map<String, dynamic> json) {
    return AddToCartModel(
      statusCode: int.tryParse(json['statuscode']?.toString() ?? '0') ?? 0,
      status: json['status']?.toString() ?? '',
      message: json['message']?.toString() ?? '',
      item: json['data'] != null && json['data'] is Map<String, dynamic>
          ? CartData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'statuscode': statusCode,
      'status': status,
      'message': message,
      'data': item?.toJson(),
    };
  }
}

class CartData {
  
  String productId;
  String productType;
  int quantity;
  String unitname;
  int priceperunit;
  int totalPrice;
  String addedAt;

  CartData({
    
    required this.productId,
    required this.productType,
    required this.quantity,
    required this.unitname,
    required this.priceperunit,
    required this.totalPrice,
    required this.addedAt,
  });

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
     
      productId: json['product_id']?.toString() ?? '',
      productType: json['product_type']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      unitname: json['unit_name']?.toString() ?? '',
      priceperunit: int.tryParse(json['price_per_unit']?.toString() ?? '0') ?? 0,
      totalPrice: int.tryParse(json['total_price']?.toString() ?? '0') ?? 0,
      addedAt: json['added_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      
      'product_id': productId,
      'product_type': productType,
      'quantity': quantity,
      'unit_name': unitname,
      'price_per_unit': priceperunit,
      'total_price': totalPrice,
      'added_at': addedAt,
    };
  }
}
