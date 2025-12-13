import 'package:animal_kart_demo2/auth/providers/auth_provider.dart';
import 'package:animal_kart_demo2/routes/routes.dart';
import 'package:animal_kart_demo2/utils/app_constants.dart';
import 'package:animal_kart_demo2/utils/save_user.dart';
import 'package:animal_kart_demo2/widgets/floating_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final phoneController = TextEditingController();

  bool isButtonEnabled = false;
  bool _isSendingOtp = false;

  bool isValidPhone(String value) {
    return RegExp(r'^[0-9]{10}$').hasMatch(value);
  }

  void validatePhone() {
    final phone = phoneController.text.trim();
    setState(() {
      isButtonEnabled = isValidPhone(phone);
    });
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                const Center(
                  child: Text(
                    "Back to the Buffalo Cart\nworld!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                  ),
                ),

                const SizedBox(height: 12),

                const Center(
                  child: Text(
                    "Enter your mobile number to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 40),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mobile number",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // ---------------- PHONE INPUT ----------------
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 12),

                      InkWell(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              AppConstants.countryCode,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.keyboard_arrow_down),
                          ],
                        ),
                      ),

                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey.shade500,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                      ),

                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          onChanged: (_) => validatePhone(),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: "",
                            hintText: "Enter number",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const SizedBox(height: 40),

                // ✅ STATIC LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: isButtonEnabled && !_isSendingOtp
                        ? () async {
                            setState(() => _isSendingOtp = true);

                            final enteredPhone =
                                phoneController.text.trim();

                            final response = await ref
                                .read(authProvider)
                                .sendWhatsappOtp(enteredPhone);

                            if (!mounted) return;

                            // ✅ SERVER ERROR
                            if (response == null) {
                              FloatingToast.showSimpleToast(
                                  "Server error. Try again.");
                              setState(() => _isSendingOtp = false);
                              return;
                            }
                            
                            // ✅ USER NOT FOUND / ERROR
                            if (response.status == "error") {
                              FloatingToast.showSimpleToast(response.message);
                              setState(() => _isSendingOtp = false);
                              return;
                            }

                            // ✅ SUCCESS
                            FloatingToast.showSimpleToast(response.message);

                            Navigator.pushNamed(
                              context,
                              AppRouter.otp,
                              arguments: {
                                'phoneNumber': enteredPhone,
                                'otp': response.otp,
                                'isFormFilled':
                                    response.user?.isFormFilled ?? false,
                              },
                            );

                            setState(() => _isSendingOtp = false);
                          }
                        : null,


                    style: ElevatedButton.styleFrom(
                      backgroundColor: isButtonEnabled
                          ? const Color(0xFF57BE82)
                          : const Color.fromARGB(255, 186, 236, 209),
                      disabledBackgroundColor: const Color(0xFFBAECD1),
                      disabledForegroundColor: Colors.grey.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    child: _isSendingOtp
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF57BE82),
                              ),
                            ),
                          )
                        : Text(
                            "Send OTP",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: isButtonEnabled
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
      ),
    );
  }
}
