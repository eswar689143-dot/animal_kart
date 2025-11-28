import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animal_kart_demo2/theme/app_theme.dart';
import 'package:animal_kart_demo2/utils/app_colors.dart';
import 'package:animal_kart_demo2/widgets/custom_widgets.dart';
import 'package:animal_kart_demo2/widgets/aadhar_upload_widget.dart';
import 'package:animal_kart_demo2/widgets/floating_toast.dart';

class ManualPaymentScreen extends StatefulWidget {
  final int totalAmount;

  const ManualPaymentScreen({super.key, required this.totalAmount});

  @override
  State<ManualPaymentScreen> createState() => _ManualPaymentScreenState();
}

class _ManualPaymentScreenState extends State<ManualPaymentScreen> {
  bool showBankForm = true;   
  bool showChequeForm = false;


  final bankAmountCtrl = TextEditingController();
  final utrCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  File? bankScreenshot;

  final chequeNoCtrl = TextEditingController();
  final chequeBankCtrl = TextEditingController();
  final chequeNameCtrl = TextEditingController();
  final chequeDateCtrl = TextEditingController();
  File? chequeImage;

  Future<File?> pickImage(bool isCamera) async {
    final picked = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
    );
    return picked != null ? File(picked.path) : null;
  }

  @override
  void initState() {
    super.initState();
    bankAmountCtrl.text = widget.totalAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFieldBg,
      appBar: AppBar(
        title: const Text("Manual Payment"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Amount to Pay: ₹${widget.totalAmount}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

 
            Row(
              children: [
                Expanded(
                  child: _paymentSelectButton(
                    title: "Bank Transfer",
                    isSelected: showBankForm,
                    color: Colors.green,
                    onTap: () {
                      setState(() {
                        showBankForm = true;
                        showChequeForm = false;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _paymentSelectButton(
                    title: "Cheque",
                    isSelected: showChequeForm,
                    color: Colors.orange,
                    onTap: () {
                      setState(() {
                        showChequeForm = true;
                        showBankForm = false;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),


            if (showBankForm) _bankTransferForm(),
            if (showChequeForm) _chequePaymentForm(),
          ],
        ),
      ),
    );
  }

 
  Widget _paymentSelectButton({
    required String title,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: isSelected ? color : akWhiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 2),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }


  Widget _bankTransferForm() {
    return Card(
      color: akWhiteColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Bank Transfer Details (NEFT/RTGS/IMPS)",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            TextFormField(
              controller: bankAmountCtrl,
              readOnly: true,
              decoration: fieldDeco("Amount Paid"),
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: utrCtrl,
              decoration: fieldDeco("UTR Number"),
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: bankNameCtrl,
              decoration: fieldDeco("Bank Name"),
            ),

            const SizedBox(height: 20),

            AadhaarUploadWidget(
              title: "Upload Payment Screenshot",
              file: bankScreenshot,
              isFrontImage: true,
              onCamera: () async {
                final file = await pickImage(true);
                if (file != null) setState(() => bankScreenshot = file);
              },
              onGallery: () async {
                final file = await pickImage(false);
                if (file != null) setState(() => bankScreenshot = file);
              },
              onRemove: () {
                setState(() => bankScreenshot = null);
              },
            ),

            const SizedBox(height: 20),

            _submitButton(() {
              if (utrCtrl.text.isEmpty) {
                FloatingToast.showSimpleToast("Enter UTR Number");
                return;
              }
              FloatingToast.showSimpleToast("Bank Transfer Submitted");
            }),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // CHEQUE PAYMENT FORM
  // ----------------------------------------------------------
  Widget _chequePaymentForm() {
    return Card(
      color: akWhiteColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Cheque Payment Details",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            Text("Amount: ₹${widget.totalAmount}",
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 15),

            TextFormField(
              controller: chequeNoCtrl,
              decoration: fieldDeco("Cheque Number"),
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: chequeBankCtrl,
              decoration: fieldDeco("Bank & Branch"),
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: chequeNameCtrl,
              decoration: fieldDeco("Name on Cheque"),
            ),
            const SizedBox(height: 15),

            TextFormField(
              controller: chequeDateCtrl,
              readOnly: true,
              decoration: fieldDeco("Cheque Date").copyWith(
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      chequeDateCtrl.text =
                          "${picked.day}-${picked.month}-${picked.year}";
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            AadhaarUploadWidget(
              title: "Upload Cheque Image",
              file: chequeImage,
              isFrontImage: true,
              onCamera: () async {
                final file = await pickImage(true);
                if (file != null) setState(() => chequeImage = file);
              },
              onGallery: () async {
                final file = await pickImage(false);
                if (file != null) setState(() => chequeImage = file);
              },
              onRemove: () {
                setState(() => chequeImage = null);
              },
            ),

            const SizedBox(height: 20),

            _submitButton(() {
              if (chequeNoCtrl.text.isEmpty) {
                FloatingToast.showSimpleToast("Enter Cheque Number");
                return;
              }
              FloatingToast.showSimpleToast("Cheque Details Submitted");
            }),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  // SUBMIT BUTTON
  // ----------------------------------------------------------
  Widget _submitButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryGreen,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        child: const Text(
          "Submit",
          style: TextStyle(color: Colors.white, fontSize: 17),
        ),
      ),
    );
  }
}
