import 'dart:io';
import 'package:animal_kart_demo2/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:device_info_plus/device_info_plus.dart';

class OtpScreen extends ConsumerStatefulWidget {
  const OtpScreen({super.key});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final otpController = TextEditingController();

  String deviceId = "";
  String deviceModel = "";

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  Future<void> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      setState(() {
        deviceId = android.id ?? "";
        deviceModel = android.model ?? "";
      });
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      setState(() {
        deviceId = ios.identifierForVendor ?? "";
        deviceModel = ios.utsname.machine ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Enter OTP",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(
                "A 6-digit OTP has been sent to your phone.",
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),

              const SizedBox(height: 30),

              /// OTP Input
              Pinput(
                controller: otpController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                pinAnimationType: PinAnimationType.scale,
                autofocus: true,
                onCompleted: (value) {
                  ref.read(authProvider.notifier).verifyOtp(
                        value,
                        deviceId,
                        deviceModel,
                      );

                  if (ref.read(authProvider).isVerified) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/main-home',
                      (route) => false,
                    );
                  }
                },
              ),

              if (auth.error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    auth.error,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),

              const SizedBox(height: 20),

              /// Submit OTP button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(authProvider.notifier).verifyOtp(
                          otpController.text.trim(),
                          deviceId,
                          deviceModel,
                        );

                    if (ref.read(authProvider).isVerified) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/main-home',
                        (route) => false,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    "Submit OTP",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 👀 (Optional debugging)
              Text("Device ID: $deviceId",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              Text("Device Model: $deviceModel",
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
