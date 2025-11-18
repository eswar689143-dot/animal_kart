import 'package:flutter_riverpod/legacy.dart';

final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController();
});

class AuthState {
  final String phoneNumber;
  final bool otpSent;
  final bool isVerified;
  final String error;

  AuthState({
    this.phoneNumber = "",
    this.otpSent = false,
    this.isVerified = false,
    this.error = "",
  });

  AuthState copyWith({
    String? phoneNumber,
    bool? otpSent,
    bool? isVerified,
    String? error,
  }) {
    return AuthState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpSent: otpSent ?? this.otpSent,
      isVerified: isVerified ?? this.isVerified,
      error: error ?? "",
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(AuthState());

  /// Step 1: Validate Phone & Send OTP
  void sendOtp(String phone) {
    if (phone.length != 10) {
      state = state.copyWith(error: "Enter a valid 10-digit phone number");
      return;
    }

    // Static mock validation
    if (phone != "9876543210") {
      state = state.copyWith(error: "Phone not registered");
      return;
    }

    state = state.copyWith(phoneNumber: phone, otpSent: true, error: "");
  }

 void verifyOtp(
  String otp,
  String deviceId,
  String deviceModel,
) {
  print("🔐 OTP Verification Called:");
  print("📱 Device ID: $deviceId");
  print("📟 Device Model: $deviceModel");

  if (otp != "123456") {
    state = state.copyWith(error: "Invalid OTP");
    return;
  }

  // OTP success
  state = state.copyWith(isVerified: true, error: "");
}

}
