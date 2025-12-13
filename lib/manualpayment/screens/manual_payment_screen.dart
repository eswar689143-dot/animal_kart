import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:animal_kart_demo2/utils/app_constants.dart';
import 'package:animal_kart_demo2/l10n/app_localizations.dart';
import 'package:animal_kart_demo2/manualpayment/widgets/common_widgets.dart';
import 'package:animal_kart_demo2/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:animal_kart_demo2/theme/app_theme.dart';
import 'package:animal_kart_demo2/utils/app_colors.dart';
import 'package:animal_kart_demo2/auth/widgets/aadhar_upload_widget.dart';
import 'package:animal_kart_demo2/widgets/floating_toast.dart';

class ManualPaymentScreen extends StatefulWidget {
  final int totalAmount;
   final String unitId;
  final String userId;
  final String buffaloId;

  const ManualPaymentScreen({super.key,
  required this.totalAmount,
    required this.unitId,
    required this.userId,
    required this.buffaloId,
  });

  @override
  State<ManualPaymentScreen> createState() => _ManualPaymentScreenState();
}

class _ManualPaymentScreenState extends State<ManualPaymentScreen> {
  bool showBankForm = true;
  bool showChequeForm = false;
  final GlobalKey<FormState> _bankFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _chequeFormKey = GlobalKey<FormState>();

  bool _isUploading = false;

  Future<String?> _uploadFile(
    File file,
    String path,
    Function(double) onProgress,
  ) async {
    try {
      final storage = FirebaseStorage.instanceFor(
        bucket: AppConstants.storageBucketName,
      );
      final ref = storage.ref().child(path);
      final uploadTask = ref.putFile(
        file,
        SettableMetadata(contentType: "image/jpeg"),
      );

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        onProgress(progress);
      });

      final snapshot = await uploadTask;
      final url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      debugPrint('Error uploading file: $e');
      return null;
    }
  }

  Future<void> _deleteFile(String path) async {
    try {
      final storage = FirebaseStorage.instanceFor(
        bucket: AppConstants.storageBucketName,
      );
      final ref = storage.ref().child(path);
      await ref.delete();
      FloatingToast.showSimpleToast("Image deleted successfully");
    } catch (e) {
      debugPrint('Error deleting file: $e');
      // Don't show toast here as it might be confusing if user just cleared UI
    }
  }

  Future<void> _handleImageUpload({
    required bool isCamera,
    required bool isBankScreenshot,
    required bool isChequeFront,
    required bool isChequeBack,
  }) async {
    final file = await pickImage(isCamera);
    if (file == null) return;

    if (isBankScreenshot) {
      setState(() {
        bankScreenshot = file;
        bankScreenshotError = null;
        bankScreenshotProgress = 0.0;
      });
    } else if (isChequeFront) {
      setState(() {
        chequeFrontImage = file;
        chequeFrontImageError = null;
        chequeFrontProgress = 0.0;
      });
    } else if (isChequeBack) {
      setState(() {
        chequeBackImage = file;
        chequeBackImageError = null;
        chequeBackProgress = 0.0;
      });
    }

    final now = DateTime.now();
    final dateFolder =
        '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}';

    String pathPrefix = "manual_payment/$dateFolder";
    String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";

    if (isBankScreenshot) fileName = "bank_transfer_$fileName";
    if (isChequeFront) fileName = "cheque_front_$fileName";
    if (isChequeBack) fileName = "cheque_back_$fileName";

    final url = await _uploadFile(file, "$pathPrefix/$fileName", (progress) {
      if (mounted) {
        setState(() {
          if (isBankScreenshot) bankScreenshotProgress = progress;
          if (isChequeFront) chequeFrontProgress = progress;
          if (isChequeBack) chequeBackProgress = progress;
        });
      }
    });

    if (mounted) {
      setState(() {
        if (isBankScreenshot) {
          bankScreenshotUrl = url;
          bankScreenshotPath = url != null ? "$pathPrefix/$fileName" : null;
          bankScreenshotProgress = null;
        }
        if (isChequeFront) {
          chequeFrontUrl = url;
          chequeFrontPath = url != null ? "$pathPrefix/$fileName" : null;
          chequeFrontProgress = null;
        }
        if (isChequeBack) {
          chequeBackUrl = url;
          chequeBackPath = url != null ? "$pathPrefix/$fileName" : null;
          chequeBackProgress = null;
        }
      });

      if (url == null) {
        FloatingToast.showSimpleToast("Image upload failed");
      }
    }
  }

  // Bank Transfer Controllers

  final bankAmountCtrl = TextEditingController();
  final bankAccountNumber = TextEditingController();
  final bankAccountHolderName = TextEditingController();
  final utrCtrl = TextEditingController();
  final bankNameCtrl = TextEditingController();
  final ifscCodeCtrl = TextEditingController();
  final transactionDateCtrl = TextEditingController();
  String transferMode = 'NEFT';
  List<String> transferModes = ['NEFT', 'RTGS', 'IMPS'];
  File? bankScreenshot;
  String? bankScreenshotError;
  String? bankScreenshotUrl;
  String? bankScreenshotPath;
  double? bankScreenshotProgress;

  // Cheque Payment Controllers

  final chequeNoCtrl = TextEditingController();
  final chequeDateCtrl = TextEditingController();
  final chequeAmountCtrl = TextEditingController();
  final chequeBankNameCtrl = TextEditingController();
  final chequeIfscCodeCtrl = TextEditingController();
  final chequeUtrRefCtrl = TextEditingController();
  File? chequeFrontImage;
  File? chequeBackImage;
  String? chequeFrontImageError;
  String? chequeBackImageError;

  String? chequeFrontUrl;
  String? chequeBackUrl;

  String? chequeFrontPath;
  String? chequeBackPath;

  double? chequeFrontProgress;
  double? chequeBackProgress;

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
    chequeAmountCtrl.text = widget.totalAmount.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kFieldBg,
      appBar: AppBar(
        title: Text(context.tr("manualPayment")),

        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${context.tr("amountToPay")}: ₹${widget.totalAmount}",

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Payment Mode Selection
            Row(
              children: [
                Expanded(
                  child: _paymentSelectButton(
                    title: context.tr("bankTransfer"),
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
                    title: context.tr("cheque"),

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

            // Forms
            if (showBankForm) _bankTransferForm(),
            if (showChequeForm) _chequePaymentForm(),
          ],
        ),
      ),
    );
  }

  // Payment Mode Selection Button
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

  // Bank Transfer Form
  Widget _bankTransferForm() {
    return Card(
      color: akWhiteColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _bankFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr("bankTransferDetails"),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Amount Field
              ValidatedTextField(
                controller: bankAmountCtrl,
                label: context.tr("amountPaid"),

                readOnly: true,
              ),
              const SizedBox(height: 15),

              // UTR Number Field
              ValidatedTextField(
                controller: utrCtrl,
                label: context.tr("utrNumber"),

                validator: BankTransferValidators.validateUTR,
                keyboardType: TextInputType.text,
                maxLength: 22,
              ),
              const SizedBox(height: 8),

              // Bank Name Field
              ValidatedTextField(
                controller: bankNameCtrl,
                label: context.tr("bankName"),
                validator: BankTransferValidators.validateBankName,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 8),

              // IFSC Code Field
              ValidatedTextField(
                controller: ifscCodeCtrl,
                label: context.tr("ifscCode"),

                validator: BankTransferValidators.validateIFSC,
                keyboardType: TextInputType.text,
                maxLength: 11,
              ),
              const SizedBox(height: 8),

              // Transaction Date Field
              ValidatedTextField(
                controller: transactionDateCtrl,
                label: context.tr("transactionDate"),
                readOnly: true,
                validator: BankTransferValidators.validateTransactionDate,
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
                      transactionDateCtrl.text =
                          "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Transfer Mode Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldTitle(context.tr("transferMode")),
                  const SizedBox(height: 4),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButton<String>(
                      value: transferMode,
                      isExpanded: true,
                      underline: const SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          transferMode = newValue!;
                        });
                      },
                      items: transferModes.map<DropdownMenuItem<String>>((
                        String value,
                      ) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Payment Screenshot Upload with validation
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AadhaarUploadWidget(
                    title: context.tr("uploadPaymentScreenshot"),
                    file: bankScreenshot,
                    isFrontImage: true,
                    uploadProgress: bankScreenshotProgress,
                    onCamera: () => _handleImageUpload(
                      isCamera: true,
                      isBankScreenshot: true,
                      isChequeFront: false,
                      isChequeBack: false,
                    ),
                    onGallery: () => _handleImageUpload(
                      isCamera: false,
                      isBankScreenshot: true,
                      isChequeFront: false,
                      isChequeBack: false,
                    ),
                    onRemove: () {
                      if (bankScreenshotPath != null) {
                        _deleteFile(bankScreenshotPath!);
                      }
                      setState(() {
                        bankScreenshot = null;
                        bankScreenshotError = null;
                        bankScreenshotUrl = null;
                        bankScreenshotPath = null;
                        bankScreenshotProgress = null;
                      });
                    },
                  ),
                  if (bankScreenshotError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8),
                      child: Text(
                        context.tr(bankScreenshotError!),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),
              _submitButton(() async {
                if (_bankFormKey.currentState!.validate()) {
                  final screenshotError =
                      BankTransferValidators.validatePaymentScreenshot(
                        bankScreenshot,
                      );
                  if (screenshotError != null) {
                    setState(() {
                      bankScreenshotError = screenshotError;
                    });
                    return;
                  }

                  if (bankScreenshotProgress != null) {
                    FloatingToast.showSimpleToast(
                      "Please wait for image upload to complete",
                    );
                    return;
                  }

                  if (bankScreenshotUrl == null && bankScreenshot != null) {
                    FloatingToast.showSimpleToast(
                      "Image upload failed, please try again",
                    );
                    return;
                  }

                  // Use bankScreenshotUrl here for API submission if needed
                  debugPrint(
                    "Submitting Bank Transfer with URL: $bankScreenshotUrl",
                  );

                  FloatingToast.showSimpleToast(
                    context.tr("bankTransferSubmitted"),
                  );
                  Navigator.pushReplacementNamed(
                    context,
                    AppRouter.PaymentPending,
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chequePaymentForm() {
    return Card(
      color: akWhiteColor,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _chequeFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.tr("chequePaymentDetails"),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),

              // Cheque Number
              ValidatedTextField(
                controller: chequeNoCtrl,
                label: context.tr("chequeNumber"),
                validator: ChequePaymentValidators.validateChequeNumber,
                keyboardType: TextInputType.number,
                maxLength: 10,
              ),
              const SizedBox(height: 8),

              // Cheque Date
              ValidatedTextField(
                controller: chequeDateCtrl,
                label: context.tr("chequeDate"),
                readOnly: true,
                validator: ChequePaymentValidators.validateChequeDate,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now().subtract(
                        const Duration(days: 90),
                      ),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      chequeDateCtrl.text =
                          "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
                    }
                  },
                ),
              ),
              const SizedBox(height: 8),

              // Cheque Amount
              ValidatedTextField(
                controller: chequeAmountCtrl,
                label: context.tr("chequeAmount"),
                readOnly: true,
              ),
              const SizedBox(height: 8),

              // Bank Name
              ValidatedTextField(
                controller: chequeBankNameCtrl,
                label: context.tr("bankName"),
                validator: ChequePaymentValidators.validateChequeBankName,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 8),

              // IFSC Code
              ValidatedTextField(
                controller: chequeIfscCodeCtrl,
                label: context.tr("ifscCode"),
                validator: ChequePaymentValidators.validateChequeIFSC,
                keyboardType: TextInputType.text,
                maxLength: 11,
              ),
              const SizedBox(height: 8),

              // UTR/Reference Number
              ValidatedTextField(
                controller: chequeUtrRefCtrl,
                label: context.tr("utrReferenceNumber"),
                validator: ChequePaymentValidators.validateChequeUTRRef,
                keyboardType: TextInputType.text,
                maxLength: 30,
              ),
              const SizedBox(height: 20),

              // Cheque Front Image with validation
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AadhaarUploadWidget(
                    title: context.tr("uploadChequeFrontImage"),
                    file: chequeFrontImage,
                    isFrontImage: true,
                    uploadProgress: chequeFrontProgress,
                    onCamera: () => _handleImageUpload(
                      isCamera: true,
                      isBankScreenshot: false,
                      isChequeFront: true,
                      isChequeBack: false,
                    ),
                    onGallery: () => _handleImageUpload(
                      isCamera: false,
                      isBankScreenshot: false,
                      isChequeFront: true,
                      isChequeBack: false,
                    ),
                    onRemove: () {
                      if (chequeFrontPath != null) {
                        _deleteFile(chequeFrontPath!);
                      }
                      setState(() {
                        chequeFrontImage = null;
                        chequeFrontImageError = null;
                        chequeFrontUrl = null;
                        chequeFrontPath = null;
                        chequeFrontProgress = null;
                      });
                    },
                  ),
                  if (chequeFrontImageError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8),
                      child: Text(
                        chequeFrontImageError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Cheque Back Image with validation
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AadhaarUploadWidget(
                    title: context.tr("uploadChequeBackImage"),
                    file: chequeBackImage,
                    isFrontImage: true,
                    uploadProgress: chequeBackProgress,
                    onCamera: () => _handleImageUpload(
                      isCamera: true,
                      isBankScreenshot: false,
                      isChequeFront: false,
                      isChequeBack: true,
                    ),
                    onGallery: () => _handleImageUpload(
                      isCamera: false,
                      isBankScreenshot: false,
                      isChequeFront: false,
                      isChequeBack: true,
                    ),
                    onRemove: () {
                      if (chequeBackPath != null) {
                        _deleteFile(chequeBackPath!);
                      }
                      setState(() {
                        chequeBackImage = null;
                        chequeBackImageError = null;
                        chequeBackUrl = null;
                        chequeBackPath = null;
                        chequeBackProgress = null;
                      });
                    },
                  ),
                  if (chequeBackImageError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 8),
                      child: Text(
                        chequeBackImageError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 20),

              // Submit Button with validation
              _submitButton(() async {
                // Validate form fields
                if (_chequeFormKey.currentState!.validate()) {
                  // Validate images
                  final frontImageError =
                      ChequePaymentValidators.validateChequeFrontImage(
                        chequeFrontImage,
                      );
                  final backImageError =
                      ChequePaymentValidators.validateChequeBackImage(
                        chequeBackImage,
                      );

                  bool hasError = false;

                  if (frontImageError != null) {
                    setState(() {
                      chequeFrontImageError = frontImageError;
                    });
                    hasError = true;
                  }

                  if (backImageError != null) {
                    setState(() {
                      chequeBackImageError = backImageError;
                    });
                    hasError = true;
                  }

                  if (hasError) return;

                  if (chequeFrontProgress != null ||
                      chequeBackProgress != null) {
                    FloatingToast.showSimpleToast(
                      "Please wait for image upload to complete",
                    );
                    return;
                  }

                  if ((chequeFrontUrl == null && chequeFrontImage != null) ||
                      (chequeBackUrl == null && chequeBackImage != null)) {
                    FloatingToast.showSimpleToast(
                      "Image upload failed, please try again",
                    );
                    return;
                  }

                  debugPrint("Cheque Front URL: $chequeFrontUrl");
                  debugPrint("Cheque Back URL: $chequeBackUrl");

                  Navigator.pushReplacementNamed(
                    context,
                    AppRouter.PaymentPending,
                  );

                  // If all validations pass
                  FloatingToast.showSimpleToast(
                    context.tr("chequeDetailsSubmitted"),
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  // Submit Button
  Widget _submitButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimaryGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: _isUploading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(
                context.tr("submit"),
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
      ),
    );
  }
}
