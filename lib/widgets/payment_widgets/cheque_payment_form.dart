import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ChequePaymentForm extends StatefulWidget {
  final int amount;

  const ChequePaymentForm({super.key, required this.amount});

  @override
  State<ChequePaymentForm> createState() => _ChequePaymentFormState();
}

class _ChequePaymentFormState extends State<ChequePaymentForm> {
  final _formKey = GlobalKey<FormState>();

  final chequeNumberController = TextEditingController();
  final bankBranchController = TextEditingController();
  final nameController = TextEditingController();
  File? chequeImage;

  Future pickImage() async {
    final img = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => chequeImage = File(img.path));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cheque Payment Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text("Amount: ₹${widget.amount}",
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 20),

              TextFormField(
                controller: chequeNumberController,
                decoration: const InputDecoration(
                  labelText: "Cheque Number",
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Enter cheque number" : null,
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: bankBranchController,
                decoration: const InputDecoration(
                  labelText: "Bank & Branch",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Name on Cheque",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              chequeImage == null
                  ? ElevatedButton(
                      onPressed: pickImage,
                      child: const Text("Upload Cheque Image"),
                    )
                  : Image.file(chequeImage!, height: 150),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // TODO: Upload to backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Cheque details submitted")),
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
