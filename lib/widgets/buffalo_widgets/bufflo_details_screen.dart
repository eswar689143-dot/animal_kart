import 'dart:async';
import 'package:animal_kart_demo2/controllers/cart_provider.dart';
import 'package:animal_kart_demo2/controllers/buffalo_details_provider.dart';
import 'package:animal_kart_demo2/screens/tabs_screens/cart_screen.dart';
import 'package:animal_kart_demo2/theme/app_theme.dart';
import 'package:animal_kart_demo2/utils/app_colors.dart';
import 'package:animal_kart_demo2/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuffaloDetailsScreen extends ConsumerStatefulWidget {
  final String buffaloId;

  const BuffaloDetailsScreen({super.key, required this.buffaloId});

  @override
  ConsumerState<BuffaloDetailsScreen> createState() =>
      _BuffaloDetailsScreenState();
}

class _BuffaloDetailsScreenState extends ConsumerState<BuffaloDetailsScreen> {
  int qty = 1; // qty = units
  int currentIndex = 0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Future.delayed(const Duration(seconds: 3), autoScroll);
  }

  void autoScroll() {
    if (!mounted) return;
    final buffaloAsync = ref.read(buffaloDetailsProvider(widget.buffaloId));
    if (!buffaloAsync.hasValue) return;

    final list = buffaloAsync.value!.buffaloImages;
    int nextPage = currentIndex + 1;
    if (nextPage >= list.length) nextPage = 0;

    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 3), autoScroll);
  }

  @override
  Widget build(BuildContext context) {
    final buffaloAsync = ref.watch(buffaloDetailsProvider(widget.buffaloId));

    return buffaloAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),

      error: (err, _) => Scaffold(body: Center(child: Text("Error: $err"))),

      data: (buffalo) {
        final imageList = buffalo.buffaloImages;

        /// NEW PRICE LOGIC → 1 qty = 1 unit = 2 buffaloes
        final int totalBuffaloes = qty * 2;
        final int totalPrice = buffalo.price * totalBuffaloes;

        return Scaffold(
          backgroundColor: Theme.of(context).mainThemeBgColor,

          appBar: AppBar(
            backgroundColor: Colors.grey.shade200,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Theme.of(context).primaryTextColor,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              "Buffalo Details",
              style: TextStyle(color: Theme.of(context).primaryTextColor),
            ),
          ),

          body: Stack(
            children: [
              /// FULL-SCREEN SCROLLABLE CONTENT
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),

                          /// IMAGE CAROUSEL
                          SizedBox(
                            height: 350,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                PageView.builder(
                                  controller: _pageController,
                                  itemCount: imageList.length,
                                  onPageChanged: (idx) =>
                                      setState(() => currentIndex = idx),
                                  itemBuilder: (_, index) {
                                    final img = imageList[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          img,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                Positioned(
                                  bottom: 12,
                                  child: Row(
                                    children: List.generate(imageList.length, (
                                      idx,
                                    ) {
                                      final active = currentIndex == idx;
                                      return AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        width: active ? 22 : 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: active
                                              ? Colors.white
                                              : Colors.white54,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 22),

                          /// TEXT DETAILS
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  buffalo.breed,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  buffalo.description,
                                  style: TextStyle(
                                    fontSize: 18,
                                    height: 1.5,
                                    color: Theme.of(context).isLightTheme
                                        ? Colors.black87
                                        : akWhiteColor54,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                          _insuranceExplanation(buffalo),

                          const SizedBox(height: 150),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// FIXED BOTTOM BUY SECTION
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: Theme.of(context).mainThemeBgColor,
                  child: Row(
                    children: [
                      /// QTY SELECTOR
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 235, 241, 236),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _qtyButton(Icons.remove, () {
                                if (qty > 1) setState(() => qty--);
                              }),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                child: Text(
                                  "$qty",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              _qtyButton(Icons.add, () {
                                setState(() => qty++);
                              }),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 30),

                      /// BUY BUTTON
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .setItem(buffalo.id, qty, buffalo.insurance);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const CartScreen(showAppBar: true),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            backgroundColor: kPrimaryGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),

                          /// NEW PRICE DISPLAY HERE
                          child: Text(
                            "Buy: ${AppConstants().formatIndianAmount(totalPrice)}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// ---------------- INSURANCE EXPLANATION BLOCK ----------------
  Widget _insuranceExplanation(buffalo) {
    final price = buffalo.price;
    final insurance = buffalo.insurance;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "CPF Offer",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 16),

          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF10B981)),
            ),
            child: Column(
              children: [
                _headerRow(),
                _unitRow("1 Unit(2 Buffaloes)", price * 2, insurance, 1),
                _unitRow("2 Units (4 Buffaloes)", price * 4, insurance * 2, 2),
                _unitRow("4 Units (8 Buffaloes)", price * 8, insurance * 4, 4),
              ],
            ),
          ),

          const SizedBox(height: 22),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFEFFFF7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF10B981), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(
                      Icons.info_outline,
                      color: Color(0xFF0F9D58),
                      size: 22,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "Commercial Benefit Explanation",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0F9D58),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                const Text(
                  "Understanding the Unit System:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                const Text(
                  "• 1 Unit = 2 buffaloes.\n"
                  "• You can choose how many units you want to buy.\n"
                  "• Insurance is charged per buffalo: ₹13,000 each.\n",
                  style: TextStyle(fontSize: 14.5, height: 1.45),
                ),

                const SizedBox(height: 14),

                const Text(
                  "Free CPF Offer:",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                const Text(
                  "• For every 1 Unit (2 buffaloes), you get insurance for 1 buffalo absolutely FREE.\n"
                  "• Free insurance increases as you buy more units.",
                  style: TextStyle(fontSize: 14.5, height: 1.45),
                ),

                const SizedBox(height: 14),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Example Benefits:",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF0F9D58),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "• Buy 1 Unit (2 buffaloes) → 1  CPF FREE\n"
                        "• Buy 2 Units (4 buffaloes) → 2 CPF FREE\n"
                        "• Buy 4 Units (8 buffaloes) → 4 CPF FREE",
                        style: TextStyle(fontSize: 14.5, height: 1.45),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "This offer significantly reduces your total insurance cost as you buy more units.",
                  style: TextStyle(
                    fontSize: 14.5,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerRow() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFDFF7ED),

        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      child: Row(
        children: const [
          Expanded(child: Text("Units", style: _headerStyle)),
          Expanded(child: Text("Price", style: _headerStyle)),
          Expanded(
            child: Text(
              "CPF",
              textAlign: TextAlign.center,
              style: _headerStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _unitRow(String title, int price, int ins, int freeCount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(18)),
        color: Color(0xFFF4FFFA),
      ),
      child: Row(
        children: [
          Expanded(child: Text(title, style: const TextStyle(fontSize: 14))),
          Expanded(
            child: Text("₹$price", style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            child: Text(
              "₹$ins(Free: $freeCount)",
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 12,
        backgroundColor: akBlackColor,
        child: Icon(icon, size: 20, color: akWhiteColor),
      ),
    );
  }
}

const _headerStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w600);
