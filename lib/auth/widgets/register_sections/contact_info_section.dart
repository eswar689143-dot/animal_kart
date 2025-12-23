
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class ContactInfoSection extends StatelessWidget {
  final TextEditingController emailCtrl;
  final FocusNode emailFocus;
  final FocusNode firstNameFocus;
  final GlobalKey<FormState>? formKey;
  final String phoneNumber;

  const ContactInfoSection({
    super.key,
    required this.emailCtrl,
    required this.emailFocus,
    required this.firstNameFocus,
    this.formKey,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contact Information",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        Card(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Phone Number",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                
                // READ ONLY PHONE NUMBER
                Container(
                  height: 55,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "+91 $phoneNumber",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 15),
                const Text(
                  "Email ID",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),

                TextFormField(
                  controller: emailCtrl,
                  focusNode: emailFocus,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _fieldDeco("Email ID"),
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email is required";
                    }
                    final emailRegex = RegExp(
                      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                    );
                    if (!emailRegex.hasMatch(value.trim())) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    final isValid = formKey?.currentState?.validate() ?? false;
                    if (isValid) {
                      FocusScope.of(context).requestFocus(firstNameFocus);
                    } else {
                      emailFocus.requestFocus();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _fieldDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
    );
  }
}