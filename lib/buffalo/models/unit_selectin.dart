class UnitSelection {
  final String id;
  final String buffaloId;
  final String userId;
  final int buffaloCount;
  final int calfCount;
  final int numUnits;
  final String paymentStatus;
  final double? lat;
  final double? lng;
  final DateTime? placedAt;

  UnitSelection({
    required this.id,
    required this.buffaloId,
    required this.userId,
    required this.buffaloCount,
    required this.calfCount,
    required this.numUnits,
    required this.paymentStatus,
    this.lat,
    this.lng,
    this.placedAt,
  });

  factory UnitSelection.fromJson(Map<String, dynamic> json) {
    return UnitSelection(
      id: json['id'] ?? '',
      buffaloId: json['buffaloId'] ?? '',
      userId: json['userId'] ?? '',
      buffaloCount: json['buffaloCount'] ?? 0,
      calfCount: json['calfCount'] ?? 0,
      numUnits: json['numUnits'] ?? 0,
      paymentStatus: json['paymentStatus'] ?? '',
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      placedAt: _parsePlacedAt(json['placedAt']),
    );
  }

  /// Converts backend custom DateTime structure → Dart DateTime
  static DateTime? _parsePlacedAt(Map<String, dynamic>? placedAt) {
    if (placedAt == null) return null;

    final date = placedAt['_DateTime__date'];
    final time = placedAt['_DateTime__time'];

    if (date == null || time == null) return null;

    return DateTime(
      date['_Date__year'] ?? 0,
      date['_Date__month'] ?? 1,
      date['_Date__day'] ?? 1,
      time['_Time__hour'] ?? 0,
      time['_Time__minute'] ?? 0,
      time['_Time__second'] ?? 0,
    );
  }
}
