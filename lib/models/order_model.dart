class OrderModel {
  final String id;
  final String buffaloId;
  final String breed;
  final int age;
  final List<String> buffaloImages;
  final int price;
  final int insurance;
  final String orderStatus;
  final bool userVerified;
  final String? invoiceUrl;

  OrderModel({
    required this.id,
    required this.buffaloId,
    required this.breed,
    required this.age,
    required this.buffaloImages,
    required this.price,
    required this.insurance,
    required this.orderStatus,
    required this.userVerified,
    this.invoiceUrl,
  });
}
