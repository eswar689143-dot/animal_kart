import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/orders_screen.dart';
import '../widgets/sort_chip_widget.dart';
import '../widgets/status_chip_widget.dart';
import '../../utils/app_colors.dart';

class OrdersFilterBottomSheet extends ConsumerStatefulWidget {
  const OrdersFilterBottomSheet({super.key});

  @override
  ConsumerState<OrdersFilterBottomSheet> createState() =>
      _OrdersFilterBottomSheetState();
}

class _OrdersFilterBottomSheetState
    extends ConsumerState<OrdersFilterBottomSheet> {
  late FilterState localFilterState;

  @override
  void initState() {
    super.initState();
    localFilterState = ref.read(filterStateProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          /// Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filter & Sort',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 24),
                color: Colors.grey[600],
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 24),

          /// Sort section
          const Text(
            'Sort by Date',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: SortChip(
                  label: 'Latest First',
                  icon: Icons.arrow_downward,
                  selected: localFilterState.sortByLatest,
                  onTap: () {
                    setState(() {
                      localFilterState =
                          localFilterState.copyWith(sortByLatest: true);
                    });
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SortChip(
                  label: 'Oldest First',
                  icon: Icons.arrow_upward,
                  selected: !localFilterState.sortByLatest,
                  onTap: () {
                    setState(() {
                      localFilterState =
                          localFilterState.copyWith(sortByLatest: false);
                    });
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          /// Status filter
          const Text(
            'Filter by Status',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 12),

          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              StatusChip(
                label: 'All Orders',
                selected: localFilterState.statusFilter == null,
                color: Colors.grey,
                onTap: () {
                  setState(() {
                    localFilterState =
                        localFilterState.copyWith(clearStatusFilter: true);
                  });
                },
              ),
              StatusChip(
                label: 'Pending',
                selected:
                    localFilterState.statusFilter == 'PENDING_PAYMENT',
                color: Colors.orange,
                onTap: () {
                  setState(() {
                    localFilterState = localFilterState.copyWith(
                        statusFilter: 'PENDING_PAYMENT');
                  });
                },
              ),
              StatusChip(
                label: 'Paid',
                selected: localFilterState.statusFilter == 'PAID',
                color: Colors.green,
                onTap: () {
                  setState(() {
                    localFilterState =
                        localFilterState.copyWith(statusFilter: 'PAID');
                  });
                },
              ),
              StatusChip(
                label: 'Admin Review',
                selected: localFilterState.statusFilter ==
                    'PENDING_ADMIN_VERIFICATION',
                color: const Color(0xFF7E57C2),
                onTap: () {
                  setState(() {
                    localFilterState = localFilterState.copyWith(
                        statusFilter:
                            'PENDING_ADMIN_VERIFICATION');
                  });
                },
              ),
                            StatusChip(
                label: 'Rejected',
                selected: localFilterState.statusFilter ==
                    'REJECTED',
                color:  Colors.red,
                onTap: () {
                  setState(() {
                    localFilterState = localFilterState.copyWith(
                        statusFilter:
                            'REJECTED');
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          /// Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    ref.read(filterStateProvider.notifier).state =
                        FilterState();
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: kPrimaryGreen, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(
                      color: kPrimaryGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(filterStateProvider.notifier).state =
                        localFilterState;
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
