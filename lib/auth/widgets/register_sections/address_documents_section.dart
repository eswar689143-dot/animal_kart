import 'dart:io';
import 'package:animal_kart_demo2/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animal_kart_demo2/auth/widgets/aadhar_upload_widget.dart';
import 'package:animal_kart_demo2/auth/providers/user_provider.dart';

// Update the AddressDocumentsSection widget
class AddressDocumentsSection extends ConsumerWidget {
  final TextEditingController addressCtrl;
  final TextEditingController aadhaarCtrl;
  final File? aadhaarFront;
  final File? aadhaarBack;
  final File? panCard;
  final VoidCallback onAadhaarFrontCamera;
  final VoidCallback onAadhaarFrontGallery;
  final VoidCallback onAadhaarBackCamera;
  final VoidCallback onAadhaarBackGallery;
  final VoidCallback onPanCardCamera;
  final VoidCallback onPanCardGallery;
  final Function() onUploadAadhaarFront;
  final Function() onUploadAadhaarBack;
  final Function() onDeleteAadhaarFront;
  final Function() onDeleteAadhaarBack;
  final Function() onUploadPanCard;
  final Function() onDeletePanCard;

  const AddressDocumentsSection({
    super.key,
    required this.addressCtrl,
    required this.aadhaarCtrl,
    required this.aadhaarFront,
    required this.aadhaarBack,
    required this.panCard,
    required this.onAadhaarFrontCamera,
    required this.onAadhaarFrontGallery,
    required this.onAadhaarBackCamera,
    required this.onAadhaarBackGallery,
    required this.onPanCardCamera,
    required this.onPanCardGallery,
    required this.onUploadAadhaarFront,
    required this.onUploadAadhaarBack,
    required this.onDeleteAadhaarFront,
    required this.onDeleteAadhaarBack,
    required this.onUploadPanCard,
    required this.onDeletePanCard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFrontUploading = ref.watch(
      userProfileProvider.select((val) => val.frontUploadProgress),
    );
    final isBackUploading = ref.watch(
      userProfileProvider.select((val) => val.backUploadProgress),
    );
    final isPanUploading = ref.watch(
      userProfileProvider.select((val) => val.panUploadProgress),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Address Information",
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          color: akWhiteColor,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Address",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: addressCtrl,
                  maxLines: 3,
                  decoration: _fieldDeco("Address"),
                  validator: (v) => v!.isEmpty ? "Required" : null,
                ),

                const SizedBox(height: 20),
                const SizedBox(height: 8),
                TextFormField(
                  controller: aadhaarCtrl,
                  decoration: _fieldDeco("Aadhaar Number (Optional)"),
                  keyboardType: TextInputType.number,
                  maxLength: 12,
                ),

                const SizedBox(height: 25),
                // Aadhaar Front
                AadhaarUploadWidget(
                  title: "Upload Aadhaar Front Image",
                  file: aadhaarFront,
                  isFrontImage: true,
                  onCamera: onAadhaarFrontCamera,
                  onGallery: onAadhaarFrontGallery,
                  onRemove: onDeleteAadhaarFront,
                  uploadProgress: isFrontUploading,
                ),

                const SizedBox(height: 25),
                // Aadhaar Back
                AadhaarUploadWidget(
                  title: "Upload Aadhaar Back Image",
                  file: aadhaarBack,
                  isFrontImage: false,
                  onCamera: onAadhaarBackCamera,
                  onGallery: onAadhaarBackGallery,
                  onRemove: onDeleteAadhaarBack,
                  uploadProgress: isBackUploading,
                ),

                const SizedBox(height: 10),
                // PAN Card
                AadhaarUploadWidget(
                  title: "Upload PAN Card Image (Mandatory)",
                  file: panCard,
                  isFrontImage: true,
                  onCamera: onPanCardCamera,
                  onGallery: onPanCardGallery,
                  onRemove: onDeletePanCard,
                  uploadProgress: isPanUploading,
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