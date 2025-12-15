// // lib/auth/biometric_lock_screen.dart
// import 'package:animal_kart_demo2/auth/screens/pin_entery_screen.dart';
// import 'package:animal_kart_demo2/services/pin_auth_services.dart';
// import 'package:animal_kart_demo2/theme/app_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:animal_kart_demo2/services/biometric_service.dart';
// import 'package:animal_kart_demo2/services/secure_storage_service.dart';

// class BiometricLockScreen extends StatefulWidget {
//   final Widget child;

//   const BiometricLockScreen({super.key, required this.child});

//   @override
//   _BiometricLockScreenState createState() => _BiometricLockScreenState();
// }

// class _BiometricLockScreenState extends State<BiometricLockScreen>
//     with WidgetsBindingObserver {
//   bool _isInitialized = false;
//   bool _showPinEntry = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     _initAuth();
//   }

//   // Future<void> _initAuth() async {
//   //   final isEnabled = await SecureStorageService.isBiometricEnabled();
//   //   if (!isEnabled /* || BiometricService.isUnlocked */ ) {
//   //     setState(() => _isInitialized = true);
//   //     return;
//   //   }
//   //   await _authenticate();
//   // }

//   Future<void> _authenticate() async {
//     if (!mounted) return;

//     final success = await BiometricService.authenticate(allowPinFallback: true);

//     if (success) {
//       BiometricService.unlock();
//       setState(() {
//         _isInitialized = true;
//         _showPinEntry = false;
//       });
//     } else if (await PinAuthService.hasPin() && !_showPinEntry) {
//       // Show PIN entry if biometric fails and PIN is set
//       setState(() => _showPinEntry = true);
//     } else {
//       // If both biometric and PIN fail, show the fallback UI
//       setState(() => _isInitialized = true);
//     }
//   }

//   // @override
//   // void didChangeAppLifecycleState(AppLifecycleState state) async {
//   //   if (state == AppLifecycleState.paused) {
//   //     BiometricService.lock();
//   //   }
//   //   if (state == AppLifecycleState.resumed) {
//   //     final isEnabled = await SecureStorageService.isBiometricEnabled();
//   //     if (isEnabled && !BiometricService.isUnlocked && mounted) {
//   //       setState(() => _isInitialized = false);
//   //       await _authenticate();
//   //     }
//   //   }
//   // }
//   // Update the _initAuth method in biometric_lock_screen.dart
//   Future<void> _initAuth() async {
//     final isEnabled = await SecureStorageService.isBiometricEnabled();
//     if (!isEnabled) {
//       // If biometric is disabled, unlock the app
//       BiometricService.unlock();
//       setState(() => _isInitialized = true);
//       return;
//     }
//     await _authenticate();
//   }

//   // Also update the didChangeAppLifecycleState method
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     if (state == AppLifecycleState.paused) {
//       final isEnabled = await SecureStorageService.isBiometricEnabled();
//       if (isEnabled) {
//         BiometricService.lock();
//       }
//     }
//     if (state == AppLifecycleState.resumed) {
//       final isEnabled = await SecureStorageService.isBiometricEnabled();
//       if (isEnabled && !BiometricService.isUnlocked && mounted) {
//         setState(() => _isInitialized = false);
//         // await _authenticate();
//         BiometricService.lock();
//       } else if (!isEnabled) {
//         // If biometric is disabled, unlock the app
//         BiometricService.unlock();
//         if (mounted) {
//           setState(() => _isInitialized = true);
//         }
//       }
//     }
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final mediaHeight = MediaQuery.of(context).size.height;

//     if (BiometricService.isUnlocked) {
//       return widget.child;
//     }

//     // if (!_isInitialized) {
//     //   return const Scaffold(body: Center(child: CircularProgressIndicator()));
//     // }

//     if (_showPinEntry) {
//       return PinEntryScreen(
//         onSuccess: () {
//           setState(() {
//             _isInitialized = true;
//             _showPinEntry = false;
//           });
//         },
//         onCancel: () {
//           setState(() {
//             _showPinEntry = false;
//             _isInitialized = true;
//           });
//         },
//       );
//     }

//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(height: mediaHeight * 0.1),

//             Icon(Icons.lock_outlined, size: 30, color: Colors.green),
//             SizedBox(height: 16),
//             Text(
//               'AnimalKart Locked',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: mediaHeight * 0.25),

//             IconButton(
//               icon: const Icon(Icons.fingerprint, size: 64),
//               onPressed: _authenticate,
//             ),
//             const SizedBox(height: 16),
//             const Text('Use biometric to unlock'),
//             TextButton(
//               onPressed: () async {
//                 // if (await PinAuthService.hasPin()) {
//                 setState(() => _showPinEntry = true);
//                 // }
//               },
//               child: const Text('Use PIN instead'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// lib/auth/screens/biometric_lock_screen.dart
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
