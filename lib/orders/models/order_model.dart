import 'package:animal_kart_demo2/orders/models/buffalo_model.dart';

class OrderUnit {
  final String id;
  final String userId;
  final DateTime? userCreatedAt;
  final DateTime? paymentSessionDate;
  final String breedId;

  final double numUnits;
  final int buffaloCount;
  final int calfCount;

  final String? status;
  final String paymentStatus;
  final String? paymentType;

  final DateTime placedAt;
  final DateTime? approvalDate;

  final double baseUnitCost;
  final double cpfUnitCost;
  final double unitCost;
  final double totalCost;

  final bool withCpf;
  final List<BuffaloModel> buffalos;

  OrderUnit({
    required this.id,
    required this.userId,
    required this.userCreatedAt,
    required this.paymentSessionDate,
    required this.breedId,
    required this.numUnits,
    required this.buffaloCount,
    required this.calfCount,
    required this.status,
    required this.paymentStatus,
    required this.paymentType,
    required this.placedAt,
    required this.approvalDate,
    required this.baseUnitCost,
    required this.cpfUnitCost,
    required this.unitCost,
    required this.totalCost,
    required this.withCpf,
    required this.buffalos,
  });

  factory OrderUnit.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String? value) {
      if (value == null || value.isEmpty || value == '') return null;
      return DateTime.tryParse(value);
    }

    return OrderUnit(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      userCreatedAt: parseDate(json['userCreatedAt']?.toString()),
      paymentSessionDate: parseDate(json['paymentSessionDate']?.toString()),
      breedId: json['breedId']?.toString() ?? '',

      numUnits: parseDouble(json['numUnits']),
      buffaloCount: parseInt(json['buffaloCount']),
      calfCount: parseInt(json['calfCount']),

      status: json['status']?.toString(),
      paymentStatus: json['paymentStatus']?.toString() ?? 'UNKNOWN',
      paymentType: json['paymentType']?.toString(),

      placedAt: parseDate(json['placedAt']?.toString()) ?? DateTime.now(),
      approvalDate: parseDate(json['approvalDate']?.toString()),

      baseUnitCost: parseDouble(json['baseUnitCost']),
      cpfUnitCost: parseDouble(json['cpfUnitCost']),
      unitCost: parseDouble(json['unitCost']),
      totalCost: parseDouble(json['totalCost']),

      withCpf: json['withCpf'] as bool? ?? false,

      buffalos: (json['buffalos'] as List? ?? [])
          .map<BuffaloModel>((e) => BuffaloModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userCreatedAt': userCreatedAt?.toIso8601String(),
      'paymentSessionDate': paymentSessionDate?.toIso8601String(),
      'breedId': breedId,
      'numUnits': numUnits,
      'buffaloCount': buffaloCount,
      'calfCount': calfCount,
      'status': status,
      'paymentStatus': paymentStatus,
      'paymentType': paymentType,
      'placedAt': placedAt.toIso8601String(),
      'approvalDate': approvalDate?.toIso8601String(),
      'baseUnitCost': baseUnitCost,
      'cpfUnitCost': cpfUnitCost,
      'unitCost': unitCost,
      'totalCost': totalCost,
      'withCpf': withCpf,
      "buffalos": (['buffalos'] as List? ?? [])
          .map((e) => BuffaloModel.fromJson(e))
          .toList(),
    
    };
  }
}

int parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) {
    return double.tryParse(value)?.toInt() ?? int.tryParse(value) ?? 0;
  }
  return 0;
}

double parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  }
  return 0.0;
}