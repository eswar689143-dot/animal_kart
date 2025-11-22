import 'dart:async';
import 'package:animal_kart_demo2/controllers/cart_provider.dart';
import 'package:animal_kart_demo2/controllers/buffalo_details_provider.dart';
import 'package:animal_kart_demo2/screens/tabs_screens/cart_screen.dart';
import 'package:animal_kart_demo2/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BuffaloDetailsScreen extends ConsumerStatefulWidget {
  final String buffaloId;

  const BuffaloDetailsScreen({super.key, required this.buffaloId});

  @override
  ConsumerState<BuffaloDetailsScreen> createState() =>
      _BuffaloDetailsScreenState();
}

class _BuffaloDetailsScreenState
    extends ConsumerState<BuffaloDetailsScreen> {
  int qty = 1;
  bool isFavorite = false;


  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    Future.delayed(const Duration(seconds: 3), autoScroll);
  }

  void autoScroll() {
    if (!mounted) return;
    final buffaloAsync = ref.read(
      buffaloDetailsProvider(widget.buffaloId),
    );
    if (!buffaloAsync.hasValue) return;

    final imageList = buffaloAsync.value!.buffaloImages;

    int nextPage = currentIndex + 1;
    if (nextPage == imageList.length) nextPage = 0;

    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 3), autoScroll);
  }

  @override
  Widget build(BuildContext context) {
    final buffaloAsync =
        ref.watch(buffaloDetailsProvider(widget.buffaloId));

    return buffaloAsync.when(
      loading: () => Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: kPrimaryGreen),
        ),
      ),

      error: (err, st) => Scaffold(
        body: Center(child: Text("Error: $err")),
      ),

      data: (buffalo) {
        final imageList = buffalo.buffaloImages;

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text("Buffalo Details",
                style: TextStyle(color: Colors.black)),
          ),

          body: Column(
            children: [
              const SizedBox(height: 8),
            
              Expanded(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
          ),
          padding: const EdgeInsets.only(bottom: 20),

          child: Column(
            children: [
              const SizedBox(height: 12),

              // ---------------------- IMAGE CAROUSEL ----------------------
              SizedBox(
                height: 350,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    PageView.builder(
                      controller: _pageController,
                      itemCount: imageList.length,
                      onPageChanged: (i) => setState(() => currentIndex = i),
                      itemBuilder: (_, index) {
                        final img = imageList[index];
                        final isNetwork = img.startsWith("http");

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: isNetwork
                                ? Image.network(img,
                                    fit: BoxFit.cover,
                                    width: double.infinity)
                                : Image.asset(img,
                                    fit: BoxFit.cover,
                                    width: double.infinity),
                          ),
                        );
                      },
                    ),
                   

                    // DOT INDICATORS
                    Positioned(
                      bottom: 12,
                      child: Row(
                        children: List.generate(
                          imageList.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: currentIndex == index ? 22 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // ---------------------- TEXT DETAILS ----------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // QTY SELECTOR
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7FDF8),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          _qtyButton(Icons.remove, () {
                            if (qty > 1) setState(() => qty--);
                          }),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text("$qty",
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold)),
                          ),
                          _qtyButton(Icons.add, () {
                            setState(() => qty++);
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ADD TO CART
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          ref.read(cartProvider.notifier).setItem(
                                buffalo.id,
                                qty,
                                buffalo.insurance,
                              );
                              Navigator.push( context, MaterialPageRoute( builder: (_) => const CartScreen(showAppBar: true), ), );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "₹${buffalo.price*qty}",
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }
}
