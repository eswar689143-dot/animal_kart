import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class ImageCompressionHelper {
  
  static const int _maxTargetSizeKB = 250; 
  static const int _maxDimensionsDocument = 1200; 
  static const int _maxDimensionsRegular = 1024; 
  
  
  static Future<File> compressDocumentImage({
    required File imageFile,
    int maxAttempts = 3,
    bool isDocument = true,
  }) async {
    try {
      // Get original size
      final originalSize = await imageFile.length();
      final originalSizeKB = originalSize / 1024;
      
      print('📷 Original image: ${originalSizeKB.toStringAsFixed(2)} KB');
      
     
      if (originalSizeKB <= _maxTargetSizeKB) {
        print('✅ Already under 250KB, no compression needed');
        return imageFile;
      }
      
     
      final fileExtension = path.extension(imageFile.path).toLowerCase();
      final isPng = fileExtension == '.png';
      
     
      if (isPng) {
        print('ℹ️ PNG detected - converting to JPEG for better compression');
      }
      
      // Start with conservative settings for documents
      int quality = isDocument ? 80 : 70;
      int maxWidth = isDocument ? _maxDimensionsDocument : _maxDimensionsRegular;
      int maxHeight = (maxWidth * 1.5).round(); // For document aspect ratio
      
      File? compressedFile;
      File currentFile = imageFile;
      
      // Iterative compression to find optimal settings
      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        print('🔄 Attempt $attempt: Quality=$quality, MaxWidth=$maxWidth');
        
        compressedFile = await _compressWithSettings(
          currentFile,
          quality: quality,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          format: isPng ? CompressFormat.jpeg : null, // Convert PNG to JPEG
        );
        
        if (compressedFile == null) {
          throw Exception('Failed to compress image');
        }
        
        final compressedSize = await compressedFile.length();
        final compressedSizeKB = compressedSize / 1024;
        
        print('   Size after attempt $attempt: ${compressedSizeKB.toStringAsFixed(2)} KB');
        
        // Success condition
        if (compressedSizeKB <= _maxTargetSizeKB) {
          print('🎉 Compression successful! Final: ${compressedSizeKB.toStringAsFixed(2)} KB');
          
          // Verify image is still readable
          if (isDocument) {
            await _verifyImageReadability(compressedFile);
          }
          
          return compressedFile;
        }
        
        // Prepare for next attempt
        currentFile = compressedFile;
        
        // Adjust settings for next attempt based on how far we are from target
        final oversizeRatio = compressedSizeKB / _maxTargetSizeKB;
        
        if (oversizeRatio > 2.0) {
          // Very large - reduce both quality and dimensions
          quality = (quality * 0.7).round();
          maxWidth = (maxWidth * 0.85).round();
          maxHeight = (maxHeight * 0.85).round();
        } else if (oversizeRatio > 1.5) {
          // Moderately large - reduce quality more
          quality = (quality * 0.75).round();
        } else {
          // Close to target - small adjustments
          quality = (quality * 0.85).round();
        }
        
        // Ensure minimum quality for readability
        if (isDocument) {
          quality = quality.clamp(40, 95); // Documents need at least 40% quality
          maxWidth = maxWidth.clamp(800, _maxDimensionsDocument);
          maxHeight = maxHeight.clamp(1000, 2000);
        } else {
          quality = quality.clamp(30, 90);
        }
        
        // Last resort on final attempt
        if (attempt == maxAttempts - 1 && compressedSizeKB > _maxTargetSizeKB * 1.5) {
          quality = isDocument ? 45 : 35;
          maxWidth = 800;
          maxHeight = 1200;
        }
      }
      
      // Return the best we could do
      final finalSize = await compressedFile!.length() / 1024;
      print('⚠️ Best effort: ${finalSize.toStringAsFixed(2)} KB (target: $_maxTargetSizeKB KB)');
      
      if (isDocument && finalSize > _maxTargetSizeKB * 1.2) {
        print('⚠️ Warning: Document image may have reduced readability');
      }
      
      return compressedFile!;
      
    } catch (e) {
      print('❌ Error compressing image: $e');
      // Return original if compression fails completely
      return imageFile;
    }
  }
  
  /// Core compression method
  static Future<File?> _compressWithSettings(
    File imageFile, {
    required int quality,
    required int maxWidth,
    required int maxHeight,
    CompressFormat? format,
  }) async {
    try {
      final String filePath = imageFile.path;
      final String fileName = path.basename(filePath);
      
      // Create unique temp file
      final Directory tempDir = await getTemporaryDirectory();
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String targetPath = '${tempDir.path}/compressed_${timestamp}_$fileName';
      
      // Determine format
      final fileExtension = path.extension(filePath).toLowerCase();
      final CompressFormat outputFormat = format ?? 
          (fileExtension == '.png' ? CompressFormat.png : CompressFormat.jpeg);
      
      // Compress the image
      final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
        filePath,
        targetPath,
        quality: quality,
        minWidth: maxWidth,
        minHeight: maxHeight,
        autoCorrectionAngle: true,
        format: outputFormat,
        keepExif: false, // Remove metadata to save space
        numberOfRetries: 1,
        rotate: 0,
      );
      
      return compressedFile != null ? File(compressedFile.path) : null;
      
    } catch (e) {
      print('Error in _compressWithSettings: $e');
      return null;
    }
  }
  
  /// Smart compression based on original image size
  static Future<File> smartCompressImage({
    required File imageFile,
    bool isDocument = true,
  }) async {
    try {
      final originalSize = await imageFile.length();
      final originalSizeKB = originalSize / 1024;
      
      print('📊 Smart compression - Original: ${originalSizeKB.toStringAsFixed(2)} KB');
      
      // Preset strategies based on original size
      if (originalSizeKB <= 300) {
        // Already close to target - minimal compression
        print('🟢 Minimal compression needed');
        return await _compressWithSettings(
          imageFile,
          quality: 85,
          maxWidth: isDocument ? 1200 : 1024,
          maxHeight: isDocument ? 1600 : 1024,
        ) ?? imageFile;
        
      } else if (originalSizeKB <= 1024) {
        // 300KB - 1MB range
        print('🟡 Moderate compression');
        return await _compressWithSettings(
          imageFile,
          quality: isDocument ? 75 : 65,
          maxWidth: isDocument ? 1200 : 1024,
          maxHeight: isDocument ? 1600 : 1024,
        ) ?? imageFile;
        
      } else if (originalSizeKB <= 2048) {
        // 1MB - 2MB range
        print('🟠 High compression needed');
        return await _compressWithSettings(
          imageFile,
          quality: isDocument ? 65 : 55,
          maxWidth: isDocument ? 1100 : 900,
          maxHeight: isDocument ? 1500 : 1024,
        ) ?? imageFile;
        
      } else {
        // >2MB - use iterative method
        print('🔴 Large image, using iterative compression');
        return await compressDocumentImage(
          imageFile: imageFile,
          isDocument: isDocument,
        );
      }
    } catch (e) {
      print('Error in smartCompressImage: $e');
      return imageFile;
    }
  }
  
  /// Verify image is still readable (for documents)
  static Future<void> _verifyImageReadability(File compressedFile) async {
    try {
      final size = await compressedFile.length() / 1024;
      final fileExtension = path.extension(compressedFile.path).toLowerCase();
      
      print('🔍 Image verification:');
      print('   Size: ${size.toStringAsFixed(2)} KB');
      print('   Format: $fileExtension');
      print('   Path: ${compressedFile.path}');
      
      // Check if file exists and has content
      final exists = await compressedFile.exists();
      if (!exists) {
        print('❌ Compressed file does not exist!');
      }
      
      // Basic validation - file should not be 0 bytes
      if (size < 5) {
        print('⚠️ Warning: Compressed file is very small (<5KB)');
      }
    } catch (e) {
      print('Error verifying image: $e');
    }
  }
  
  /// Check if compression is needed
  static Future<bool> needsCompression(File imageFile, {int maxSizeKB = 250}) async {
    try {
      final length = await imageFile.length();
      final sizeInKB = length / 1024;
      final needs = sizeInKB > maxSizeKB;
      
      if (needs) {
        print('⚡ Needs compression: ${sizeInKB.toStringAsFixed(2)} KB > $maxSizeKB KB');
      }
      
      return needs;
    } catch (e) {
      print('Error checking compression need: $e');
      return false;
    }
  }
  
  /// One-call method for compression
  static Future<File> getCompressedImageIfNeeded(
    File imageFile, {
    int maxSizeKB = 250,
    bool isDocument = true,
  }) async {
    print('\n=== IMAGE COMPRESSION STARTED ===');
    print('📁 File: ${path.basename(imageFile.path)}');
    print('📄 Document type: ${isDocument ? "Aadhar/Pan card" : "Regular photo"}');
    print('🎯 Target size: <$maxSizeKB KB\n');
    
    if (await needsCompression(imageFile, maxSizeKB: maxSizeKB)) {
      return await smartCompressImage(
        imageFile: imageFile,
        isDocument: isDocument,
      );
    }
    
    print('✅ No compression needed');
    return imageFile;
  }
  
  /// Quick compression with preset settings
  static Future<File> quickCompress(File imageFile, {bool isDocument = true}) async {
    print('⚡ Quick compression for ${isDocument ? "document" : "photo"}');
    
    return await _compressWithSettings(
      imageFile,
      quality: isDocument ? 70 : 60,
      maxWidth: isDocument ? 1100 : 1024,
      maxHeight: isDocument ? 1500 : 1024,
    ) ?? imageFile;
  }
  
  /// Get compression statistics
  static Future<void> printCompressionStats(File original, File compressed) async {
    try {
      final originalSize = await original.length() / 1024;
      final compressedSize = await compressed.length() / 1024;
      final reduction = ((originalSize - compressedSize) / originalSize * 100);
      
      print('\n📊 COMPRESSION STATISTICS:');
      print('   Original: ${originalSize.toStringAsFixed(2)} KB');
      print('   Compressed: ${compressedSize.toStringAsFixed(2)} KB');
      print('   Reduction: ${reduction.toStringAsFixed(1)}%');
      print('   File size under 250KB: ${compressedSize <= 250 ? "✅ YES" : "❌ NO"}');
    } catch (e) {
      print('Error calculating stats: $e');
    }
  }
}