class OrderUnit {
  final String id;
  final String userId;
  final String buffaloId;
  final int numUnits;
  final int buffaloCount;
  final int calfCount;
  final String? status;
  final String paymentStatus;
  final String? paymentType;
  final List<OrderedBuffalo> buffalos;

  OrderUnit({
    required this.id,
    required this.userId,
    required this.buffaloId,
    required this.numUnits,
    required this.buffaloCount,
    required this.calfCount,
    this.status,
    required this.paymentStatus,
    this.paymentType,
    required this.buffalos,
  });

  factory OrderUnit.fromJson(Map<String, dynamic> json) {
    return OrderUnit(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      buffaloId: json['buffaloId'] ?? '',
      numUnits: json['numUnits'] ?? 0,
      buffaloCount: json['buffaloCount'] ?? 0,
      calfCount: json['calfCount'] ?? 0,
      status: json['status'],
      paymentStatus: json['paymentStatus'] ?? '',
      paymentType: json['paymentType'],
      buffalos: (json['buffalos'] as List? ?? [])
          .map((e) => OrderedBuffalo.fromJson(e))
          .toList(),
    );
  }
}

class OrderedBuffalo {
  final String id;
  final String? parentId;
  final String breedId;
  final int ageYears;
  final String status;
  final String type;

  OrderedBuffalo({
    required this.id,
    this.parentId,
    required this.breedId,
    required this.ageYears,
    required this.status,
    required this.type,
  });

  factory OrderedBuffalo.fromJson(Map<String, dynamic> json) {
    return OrderedBuffalo(
      id: json['id'] ?? '',
      parentId: json['parentId'],
      breedId: json['breedId'] ?? '',
      ageYears: json['ageYears'] ?? 0,
      status: json['status'] ?? '',
      type: json['type'] ?? '',
    );
  }
}
