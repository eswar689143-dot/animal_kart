import 'package:flutter/material.dart';

class TransferForm extends StatefulWidget {
  const TransferForm({super.key});

  @override
  State<TransferForm> createState() => _TransferFormState();
}

class _TransferFormState extends State<TransferForm> {
  final _formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();

  void transferUnit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Transferred 1 unit to ${firstNameController.text} ${lastNameController.text}',
          ),
        ),
      );
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: firstNameController,
            decoration: _inputDecoration('First Name'),
            validator: (v) => v!.isEmpty ? 'Enter first name' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: lastNameController,
            decoration: _inputDecoration('Last Name'),
            validator: (v) => v!.isEmpty ? 'Enter last name' : null,
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: phoneController,
            decoration: _inputDecoration('Phone Number'),
            keyboardType: TextInputType.phone,
            validator: (v) => v!.isEmpty ? 'Enter phone number' : null,
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    backgroundColor: Theme.of(context).colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  onPressed: transferUnit,
  child: const Text(
    'Transfer Unit',
    style: TextStyle(fontSize: 16,color: Colors.white),
  ),
),

          ),
        ],
      ),
    );
  }
}
