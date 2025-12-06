import 'dart:io';
import 'package:animal_kart_demo2/routes/routes.dart';
import 'package:animal_kart_demo2/widgets/floating_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';
import 'package:device_info_plus/device_info_plus.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final otpController = TextEditingController();

  String deviceId = "";
  String deviceModel = "";
  bool isOtpValid = false;
  bool _isVerifying = false;

 
  final String staticOtp = "123456";

  @override
  void initState() {
    super.initState();
    getDeviceInfo();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(6),
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
              // ----- BACK BUTTON -----
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 10),

              // ✅ PHONE NUMBER DISPLAY
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  children: [
                    const TextSpan(
                      text: "Please enter the OTP sent to ",
                    ),
                    TextSpan(
                      text: "(+91) ${widget.phoneNumber}",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // ---- OTP INPUT ----
              Center(
                child: Pinput(
                  controller: otpController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  onChanged: (value) {
                    setState(() {
                      isOtpValid = value.length == 6;
                    });
                  },
                ),
              ),

              const SizedBox(height: 10),

              // ✅ STATIC OTP DISPLAY (DEBUG MODE)
              Center(
                child: Text(
                  "Static OTP: 123456",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),

              const Spacer(),

             
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: isOtpValid && !_isVerifying
                      ? () async {
                          setState(() => _isVerifying = true);

                          await Future.delayed(
                            const Duration(milliseconds: 800),
                          );

                          // ✅ OTP VERIFICATION
                          if (otpController.text.trim() != staticOtp) {
                            FloatingToast.showSimpleToast("Invalid OTP");
                            setState(() => _isVerifying = false);
                            return;
                          }

                          FloatingToast.showSimpleToast(
                            "Login Successful",
                          );

                          if (!mounted) return;

                          // ✅ NAVIGATE TO HOME USING ROUTE
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.home,
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isOtpValid
                        ? const Color(0xFF57BE82)
                        : Colors.grey.shade300,
                    disabledBackgroundColor:
                        const Color(0xFFBAECD1),
                    disabledForegroundColor:
                        Colors.grey.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: _isVerifying
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(
                              Color(0xFF57BE82),
                            ),
                          ),
                        )
                      : Text(
                          "Continue",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isOtpValid
                                ? Colors.black
                                : Colors.grey.shade500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final android = await deviceInfo.androidInfo;
      setState(() {
        deviceId = android.id;
        deviceModel = android.model;
      });
    } else if (Platform.isIOS) {
      final ios = await deviceInfo.iosInfo;
      setState(() {
        deviceId = ios.identifierForVendor ?? "";
        deviceModel = ios.utsname.machine;
      });
    }
  }
}
