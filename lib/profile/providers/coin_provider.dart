import 'package:animal_kart_demo2/network/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animal_kart_demo2/profile/providers/profile_provider.dart';
import '../models/coins_model.dart';

final coinProvider = FutureProvider<CoinTransactionResponse?>((ref) async {
  final profileState = ref.watch(profileProvider);
  final mobile = profileState.currentUser?.mobile;

  if (mobile == null || mobile.isEmpty) {
    throw Exception("User mobile number not available");
  }

  return await ApiServices.fetchCoinTransactions(mobile);
});
