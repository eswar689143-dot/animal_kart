import 'dart:async';
import 'package:animal_kart_demo2/routes/routes.dart';
import 'package:animal_kart_demo2/utils/app_constants.dart';
import 'package:animal_kart_demo2/widgets/app_text_styles.dart';
import 'package:animal_kart_demo2/widgets/size_config.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (currentIndex < AppConstants.onboardingData.length - 1) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }

      _pageController.animateToPage(
        currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: SizeConfig.blockHeight * 3),
            Column(
              children: [
                Container(
                  height: SizeConfig.blockHeight * 10,
                  width: SizeConfig.blockHeight * 10,
                  decoration: BoxDecoration(
                    color: const Color(0xFF5DBE8A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(AppConstants.onBoardAppLogo),
                ),
                Image.asset(
                  AppConstants.AppNameAsset,
                  height: SizeConfig.blockHeight * 15,
                ),
              ],
            ),

            SizedBox(height: SizeConfig.blockHeight * 2),

            /// PAGEVIEW
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockWidth * 5,
                ),
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.blockWidth * 5),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: AppConstants.onboardingData.length,
                          onPageChanged: (index) =>
                              setState(() => currentIndex = index),
                          itemBuilder: (context, index) {
                            final item = AppConstants.onboardingData[index];

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  item.image,
                                  height: SizeConfig.blockHeight * 30,
                                ),
                                SizedBox(height: SizeConfig.blockHeight * 2),
                                Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: AppText.bold16,
                                ),
                                SizedBox(height: SizeConfig.blockHeight * 1),
                                Text(
                                  item.subtitle,
                                  textAlign: TextAlign.center,
                                  style: AppText.regular14,
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      SizedBox(height: SizeConfig.blockHeight * 1),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          AppConstants.onboardingData.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.blockWidth * 1.2,
                            ),
                            height: SizeConfig.blockHeight * 1.2,
                            width: currentIndex == index
                                ? SizeConfig.blockWidth * 6
                                : SizeConfig.blockWidth * 2.5,
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? Colors.black
                                  : Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockHeight * 2),

            /// BUTTON
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.blockWidth * 5,
              ),
              child: SizedBox(
                width: double.infinity,
                height: SizeConfig.blockHeight * 7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5DBE8A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, AppRouter.login),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ),

            SizedBox(height: SizeConfig.blockHeight * 4),
          ],
        ),
      ),
    );
  }
}

