


import 'package:animal_kart_demo2/auth/providers/auth_provider.dart';
import 'package:animal_kart_demo2/utils/save_user.dart';
import 'package:animal_kart_demo2/widgets/floating_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterController {
  final WidgetRef ref;
  
  RegisterController(this.ref);
  
  Future<bool> submitRegistration({
    required String userId,
    required Map<String, dynamic> userData,
    required BuildContext context,
  }) async {
    try {
      final auth = ref.read(authProvider.notifier);
      final user = await auth.updateUserdata(
        userId: userId,
        extraFields: userData,
      );
      
      if (user != null) {
        await saveUserToPrefs(user);
        return true;
      } else {
        FloatingToast.showSimpleToast('Failed to update profile. Please try again.');
        return false;
      }
    } catch (e) {
      debugPrint('Registration error: $e');
      FloatingToast.showSimpleToast('An error occurred. Please try again.');
      return false;
    }
  }
}