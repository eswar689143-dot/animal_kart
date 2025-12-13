import 'package:animal_kart_demo2/orders/screens/invoice_screen.dart';
import 'package:animal_kart_demo2/orders/screens/pdf_viewer_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/orders_providers.dart';
import '../widgets/orders_card_widget.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(ordersProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    final isLoading = ref.watch(ordersLoadingProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(
                  child: Text(
                    "No Orders Available",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: BuffaloOrderCard(
                        order: order,
                        onTapInvoice: ()  {
                          

                         
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
