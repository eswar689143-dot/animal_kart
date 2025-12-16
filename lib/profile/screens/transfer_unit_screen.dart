import 'package:animal_kart_demo2/utils/app_constants.dart';
import 'package:flutter/material.dart';

class TransferUnitScreen extends StatefulWidget {
 

  const TransferUnitScreen({
    super.key,
    
  });

  @override
  State<TransferUnitScreen> createState() => _TransferUnitScreenState();
}

class _TransferUnitScreenState extends State<TransferUnitScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),

              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'coins',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "3,63,000",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Spend coins to unlock your Buffalo! Purchase 1 unit today and get free CPF for an entire year.',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// RIGHT COIN IMAGE
                  Image.asset(AppConstants.coinDetailsImage, // replace with your coin image
                    width: 90,
                    height: 90,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// Divider
              const Divider(
                color:  Colors.black12,
                thickness: 1,
              ),

              const SizedBox(height: 8),
               Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _StatItem(title: "lifetime earnings", value: "3,63,000"),
                  _StatItem(title: "lifetime spends", value: "0"),
                ],
              ),

              const SizedBox(height: 8),

              const Divider(
                color:  Colors.black12,
                thickness: 1,
              ),

              const SizedBox(height: 18),

              /// LEDGER TITLE
              const Text(
                "COIN LEDGER",
                style: TextStyle(
                  color:  Colors.black,
                  letterSpacing: 2,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              /// LEDGER LIST
              Expanded(
                child: ListView(
                  children: const [
                    CoinLedgerItem(
                      amount: "7,260",
                      label: "referred investor purchased 1 unit",
                      date: "16TH DEC",
                      isCredit: true,
                    ),
                    CoinLedgerItem(
                      amount: "7,260",
                      label: "referred investor purchased 1 unit",
                      date: "04TH DEC",
                       isCredit: true,
                    ),
                    CoinLedgerItem(
                       amount: "7,260",
                      label: "referred investor purchased 1 unit",
                      date: "04TH DEC",
                       isCredit: true,
                    ),
                    CoinLedgerItem(
                      amount: "7,260",
                      label: "referred investor purchased 1 unit ",
                      date: "04TH DEC",
                       isCredit: true,
                    ),
                    CoinLedgerItem(
                      amount: "7,260",
                      label: "referred investor purchased 1 unit",
                      date: "30TH NOV",
                       isCredit: true,
                    ),
                    CoinLedgerItem(
                      amount: "7,260",
                      label: "referred investor purchased 1 unit ",
                      date: "30TH NOV",
                      isCredit: true,
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}



class _StatItem extends StatelessWidget {
  final String title;
  final String value;

  const _StatItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color:  Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            color:  Colors.black54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}


class CoinLedgerItem extends StatelessWidget {
  final String amount;
  final String label;
  final String date;
  final bool isCredit;

  const CoinLedgerItem({
    super.key,
    required this.amount,
    required this.label,
    required this.date,
    this.isCredit = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCredit ? Colors.green : Colors.red,
              ),
            ),
            child: Icon(
              isCredit ? Icons.north_east : Icons.south_west,
              color: isCredit ? Colors.green : Colors.red,
              size: 16,
            ),
          ),

          const SizedBox(width: 14),

          /// DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  amount,
                  style: const TextStyle(
                    color:  Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: const TextStyle(
                    color:  Colors.black,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          /// DATE
          Text(
            date,
            style: const TextStyle(
              color:  Colors.black38,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
