import 'package:animal_kart_demo2/buffalo/models/buffalo.dart';
import 'package:animal_kart_demo2/network/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final buffaloDetailsProvider =
    FutureProvider.family<Buffalo, String>((ref, buffaloId) async {
  return ApiServices.fetchBuffaloById(buffaloId);
});