// lib/manualpayment/provider/ifsc_provider.dart
import 'dart:convert';
import 'package:animal_kart_demo2/manualpayment/model/ifsc_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:http/http.dart' as http;


// Provider for IFSC lookup
final ifscProvider = FutureProvider.family<IfscResponse?, String>((ref, ifscCode) async {
  if (ifscCode.isEmpty || ifscCode.length != 11) {
    return null;
  }
  return await IfscService.fetchBankDetails(ifscCode);
});

// StateNotifier for IFSC management
final ifscStateProvider = StateNotifierProvider<IfscStateNotifier, IfscState>((ref) {
  return IfscStateNotifier();
});

class IfscState {
  final String bankName;
  final String branchName;
  final bool isLoading;
  final String? error;
  final IfscResponse? ifscData;

  IfscState({
    this.bankName = '',
    this.branchName = '',
    this.isLoading = false,
    this.error,
    this.ifscData,
  });

  IfscState copyWith({
    String? bankName,
    String? branchName,
    bool? isLoading,
    String? error,
    IfscResponse? ifscData,
  }) {
    return IfscState(
      bankName: bankName ?? this.bankName,
      branchName: branchName ?? this.branchName,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      ifscData: ifscData ?? this.ifscData,
    );
  }
}

class IfscStateNotifier extends StateNotifier<IfscState> {
  IfscStateNotifier() : super(IfscState());

  Future<void> fetchIfscDetails(String ifscCode, {bool isBankTransfer = true}) async {
    if (ifscCode.isEmpty || ifscCode.length != 11) {
      state = state.copyWith(
        bankName: '',
        branchName: '',
        isLoading: false,
        error: ifscCode.isNotEmpty ? 'IFSC code must be 11 characters' : null,
        ifscData: null,
      );
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await IfscService.fetchBankDetails(ifscCode);
      
      if (response == null) {
        state = state.copyWith(
          isLoading: false,
          error: 'Invalid IFSC code or network error',
          bankName: '',
          branchName: '',
          ifscData: null,
        );
        return;
      }

      state = state.copyWith(
        isLoading: false,
        bankName: response.bank,
        branchName: response.branch,
        ifscData: response,
        error: null,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to fetch bank details: $e',
        bankName: '',
        branchName: '',
        ifscData: null,
      );
    }
  }

  void clear() {
    state = IfscState();
  }
}

// Service class for IFSC API
class IfscService {
  static Future<IfscResponse?> fetchBankDetails(String ifscCode) async {
    try {
      final url = Uri.parse('https://ifsc.razorpay.com/$ifscCode');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        
        // Check if the response contains error
        if (jsonData.containsKey('error')) {
          return null;
        }
        
        return IfscResponse.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        return null; // IFSC not found
      } else {
        throw Exception('Failed to load bank details: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('IFSC API Error: $e');
      return null;
    }
  }
}