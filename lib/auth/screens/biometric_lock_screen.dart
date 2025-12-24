import 'package:flutter/material.dart';
import 'package:animal_kart_demo2/services/biometric_service.dart';
import 'package:animal_kart_demo2/services/secure_storage_service.dart';

class BiometricLockScreen extends StatefulWidget {
  final Widget child;
  const BiometricLockScreen({super.key, required this.child});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen>
    with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initialAuth(); // <-- change here
  }

  Future<void> _initialAuth() async {
    final enabled = await SecureStorageService.isBiometricEnabled();
    if (!enabled) return;

    // Force authentication on first app launch
    await BiometricService.authenticate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final enabled = await SecureStorageService.isBiometricEnabled();
    if (!enabled) return;

    if (state == AppLifecycleState.paused) {
      // App went to background → lock
      BiometricService.lock();
    }

    if (state == AppLifecycleState.resumed) {
      // App comes back → system auth
      if (!BiometricService.isUnlocked) {
        await BiometricService.authenticate();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child; // No custom UI
  }
}
