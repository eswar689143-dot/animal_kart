// lib/manualpayment/model/ifsc_response.dart
class IfscResponse {
  final String micr;
  final String branch;
  final String address;
  final String state;
  final String city;
  final String centre;
  final String district;
  final bool neft;
  final bool imps;
  final bool rtgs;
  final bool upi;
  final String bank;
  final String bankCode;
  final String ifsc;
  final String? swift;
  final String? contact;
  final String? iso3166;

  IfscResponse({
    required this.micr,
    required this.branch,
    required this.address,
    required this.state,
    required this.city,
    required this.centre,
    required this.district,
    required this.neft,
    required this.imps,
    required this.rtgs,
    required this.upi,
    required this.bank,
    required this.bankCode,
    required this.ifsc,
    this.swift,
    this.contact,
    this.iso3166,
  });

  factory IfscResponse.fromJson(Map<String, dynamic> json) {
    return IfscResponse(
      micr: json['MICR'] ?? '',
      branch: json['BRANCH'] ?? '',
      address: json['ADDRESS'] ?? '',
      state: json['STATE'] ?? '',
      city: json['CITY'] ?? '',
      centre: json['CENTRE'] ?? '',
      district: json['DISTRICT'] ?? '',
      neft: json['NEFT'] ?? false,
      imps: json['IMPS'] ?? false,
      rtgs: json['RTGS'] ?? false,
      upi: json['UPI'] ?? false,
      bank: json['BANK'] ?? '',
      bankCode: json['BANKCODE'] ?? '',
      ifsc: json['IFSC'] ?? '',
      swift: json['SWIFT'],
      contact: json['CONTACT'],
      iso3166: json['ISO3166'],
    );
  }

  Map<String, dynamic> toJson() => {
    'MICR': micr,
    'BRANCH': branch,
    'ADDRESS': address,
    'STATE': state,
    'CITY': city,
    'CENTRE': centre,
    'DISTRICT': district,
    'NEFT': neft,
    'IMPS': imps,
    'RTGS': rtgs,
    'UPI': upi,
    'BANK': bank,
    'BANKCODE': bankCode,
    'IFSC': ifsc,
    'SWIFT': swift,
    'CONTACT': contact,
    'ISO3166': iso3166,
  };

  @override
  String toString() {
    return 'Bank: $bank, Branch: $branch, IFSC: $ifsc';
  }
}