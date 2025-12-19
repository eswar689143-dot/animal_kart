class UnitSelection {
  final String id;
  final String breedId;
  final String userId;
  final int buffaloCount;
  final int calfCount;
  final double numUnits;
  final String paymentStatus;
  final String paymentMode;
  final double baseUnitCost;
  final double cpfUnitCost;
  final bool withCpf;
  final double unitCost;
  final double totalCost;
  final DateTime? placedAt;

  UnitSelection({
    required this.id,
    required this.breedId,
    required this.userId,
    required this.buffaloCount,
    required this.calfCount,
    required this.numUnits,
    required this.paymentStatus,
    required this.paymentMode,
    required this.baseUnitCost,
    required this.cpfUnitCost,
    required this.withCpf,
    required this.unitCost,
    required this.totalCost,
    this.placedAt,
  });

  factory UnitSelection.fromJson(Map<String, dynamic> json) {
    return UnitSelection(
      id: json['id']?.toString() ?? '',
      breedId: json['breedId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      buffaloCount: (json['buffaloCount'] as num?)?.toInt() ?? 0,
      calfCount: (json['calfCount'] as num?)?.toInt() ?? 0,
      numUnits: (json['numUnits'] as num?)?.toDouble() ?? 0.0,
      paymentStatus: json['paymentStatus']?.toString() ?? '',
      paymentMode: json['paymentMode']?.toString() ?? '',
      baseUnitCost: (json['baseUnitCost'] as num?)?.toDouble() ?? 0.0,
      cpfUnitCost: (json['cpfUnitCost'] as num?)?.toDouble() ?? 0.0,
      withCpf: json['withCpf'] as bool? ?? false,
      unitCost: (json['unitCost'] as num?)?.toDouble() ?? 0.0,
      totalCost: (json['totalCost'] as num?)?.toDouble() ?? 0.0,
      placedAt: json['placedAt'] != null 
          ? DateTime.tryParse(json['placedAt'].toString()) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'breedId': breedId,
      'userId': userId,
      'buffaloCount': buffaloCount,
      'calfCount': calfCount,
      'numUnits': numUnits,
      'paymentStatus': paymentStatus,
      'paymentMode': paymentMode,
      'baseUnitCost': baseUnitCost,
      'cpfUnitCost': cpfUnitCost,
      'withCpf': withCpf,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'placedAt': placedAt?.toIso8601String(),
    };
  }
}