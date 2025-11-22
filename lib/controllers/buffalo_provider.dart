import 'package:animal_kart_demo2/network/api_services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/buffalo.dart';


final buffaloListProvider = FutureProvider<List<Buffalo>>((ref) async {
  return ApiServices.fetchBuffaloList();
});
