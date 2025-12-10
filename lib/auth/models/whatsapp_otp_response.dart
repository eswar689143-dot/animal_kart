

import 'package:animal_kart_demo2/auth/models/user_model.dart';

class WhatsappOtpResponse {
  final int statuscode;
  final String status;
  final String message;
  final String? otp;
  final UserModel? user;

  WhatsappOtpResponse({
    required this.statuscode,
    required this.status,
    required this.message,
    this.otp,
    this.user,
  });

  factory WhatsappOtpResponse.fromJson(Map<String, dynamic> json) {
    return WhatsappOtpResponse(
      statuscode: json['statuscode'],
      status: json['status'],
      message: json['message'],
      otp: json['otp'],
      user: json['user'] != null ? UserModel.fromJson(json['user']) : null,
    );
  }
}
