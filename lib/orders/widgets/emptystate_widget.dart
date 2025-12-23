import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animal_kart_demo2/utils/app_colors.dart';
import '../screens/orders_screen.dart';

class OrdersEmptyState extends ConsumerWidget {
  final bool noOrders;
  final bool hasFilters;

  const OrdersEmptyState({
    super.key,
    required this.noOrders,
    required this.hasFilters,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                noOrders
                    ? Icons.shopping_bag_outlined
                    : Icons.filter_alt_off_outlined,
                size: 60,
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              noOrders ? "No Orders Yet" : "No Matching Orders",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              noOrders
                  ? "Your orders will appear here once\nyou make your first purchase"
                  : "Try adjusting your filters to see\nmore orders",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            if (hasFilters) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  ref.read(filterStateProvider.notifier).state = FilterState();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Clear Filters'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: kPrimaryGreen,
                  side: BorderSide(color: kPrimaryGreen, width: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
