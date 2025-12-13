import 'package:animal_kart_demo2/orders/models/order_model.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../network/api_services.dart';

import 'package:shared_preferences/shared_preferences.dart';

final ordersProvider =
    StateNotifierProvider<OrdersController, List<OrderUnit>>(
  (ref) => OrdersController(),
);

final ordersLoadingProvider = StateProvider<bool>((ref) => false);

class OrdersController extends StateNotifier<List<OrderUnit>> {
  OrdersController() : super([]);

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userMobile');

    if (userId == null) return;

    state = [];
    final container = ProviderContainer();
    container.read(ordersLoadingProvider.notifier).state = true;

    final orders = await ApiServices.fetchOrders(userId);

    state = orders;
    container.read(ordersLoadingProvider.notifier).state = false;
  }
}
