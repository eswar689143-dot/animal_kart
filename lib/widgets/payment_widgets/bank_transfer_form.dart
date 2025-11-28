import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BankTransferForm extends StatefulWidget {
  final int amount;

  const BankTransferForm({super.key, required this.amount});

  @override
  State<BankTransferForm> createState() => _BankTransferFormState();
}

class _BankTransferFormState extends State<BankTransferForm> {
  final _formKey = GlobalKey<FormState>();

  final utrController = TextEditingController();
  final bankNameController = TextEditingController();
  final amountController = TextEditingController();
  File? screenshot;

  Future pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) {
      setState(() => screenshot = File(img.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    amountController.text = widget.amount.toString();

    return Scaffold(
      appBar: AppBar(title: const Text("Bank Transfer Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: amountController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Amount Paid",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: utrController,
                decoration: const InputDecoration(
                  labelText: "UTR Number",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter UTR number" : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: bankNameController,
                decoration: const InputDecoration(
                  labelText: "Bank Name",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              screenshot == null
                  ? ElevatedButton(
                      onPressed: pickImage,
                      child: const Text("Upload Payment Screenshot"),
                    )
                  : Image.file(screenshot!, height: 150),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: upload to backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Bank details submitted")),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
