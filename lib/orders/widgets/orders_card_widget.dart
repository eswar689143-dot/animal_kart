import 'package:animal_kart_demo2/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../../manualpayment/screens/manual_payment_screen.dart';

class BuffaloOrderCard extends StatelessWidget {
  final OrderUnit order;

  const BuffaloOrderCard({
    super.key,
    required this.order, required Null Function() onTapInvoice,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPending =
        order.paymentStatus.toUpperCase() == "PENDING_PAYMENT";
    final bool isPaid = order.paymentStatus.toUpperCase() == "PAID";

    final bool isBankTransfer =
        order.paymentType?.toUpperCase() == "BANK_TRANSFER";

    // As per requirement
    const int totalAmount = 363000;

    final Color statusColor = isPaid ? Colors.green : Colors.orange;
    final String statusText =
        isPaid ? context.tr("paid") : context.tr("pending");

    return InkWell(
      onTap: isPending
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ManualPaymentScreen(
                    totalAmount: totalAmount,
                    unitId: order.id,
                    userId: order.userId,
                    buffaloId: order.buffaloId,
                  ),
                ),
              );
            }
          : null,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ================= MAIN CONTENT =================
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------- LEFT IMAGE --------
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    "assets/images/buffalo_image2.png",
                    height: 80,
                    width: 130,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 5),

                // -------- RIGHT DETAILS --------
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                              _valueRow(
                        context,
                        "${order.buffaloCount}",
                        context.tr("buffalo"),
                      ),
                      const SizedBox(width: 4),

                      _valueRow(
                        context,
                        "${order.calfCount}",
                        context.tr("calf"),
                      ),
                        ],
                      ),

                    
                    

                      // -------- UNIT + CPF + AMOUNT --------
                      Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(fontSize: 14),
                              children: [
                                TextSpan(
                                  text: "${order.numUnits} ",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                                TextSpan(
                                  text: "${context.tr("unit")} + CPF",
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "₹${_formatAmount(totalAmount)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // -------- BANK TRANSFER + INVOICE --------
                      if (isPaid && isBankTransfer)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                "BANK TRANSFER",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                // Invoice click
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  context.tr("invoice"),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // ================= STATUS BADGE =================
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- HELPERS ----------

  Widget _valueRow(BuildContext context, String value, String label) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 14),
        children: [
          TextSpan(
            text: "$value ",
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          TextSpan(
            text: label,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  static String _formatAmount(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}
