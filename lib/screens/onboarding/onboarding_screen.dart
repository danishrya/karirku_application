import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_assets.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/screens/auth/login_screen.dart';
import 'package:karirku_application/widgets/custom_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  bool isLastPage = false;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Temukan Karier Impianmu Dimulai dari Sini',
      description:
          'Jelajahi peluang kerja terbaik yang sesuai dengan minat, keahlian, dan tujuanmu.',
      image: AppAssets.onboarding1,
    ),
    OnboardingData(
      title: 'Bangun Profil Profesional yang Menarik',
      description:
          'Tampilkan portofolio, pengalaman, dan keahlianmu untuk menarik perhatian perusahaan impian.',
      image: AppAssets.onboarding2,
    ),
    OnboardingData(
      title: 'Latih Diri & Tunjukkan Potensi Terbaikmu',
      description:
          'Ikuti simulasi wawancara, pelatihan karier, dan micro-project untuk menarik perhatian HRD.',
      image: AppAssets.onboarding3,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _navigateToLogin,
                child: const Text('Skip'),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = index == _pages.length - 1;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          page.image,
                          height: 300,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 48),
                        Text(
                          page.title,
                          style: AppTextStyles.heading2,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Bottom Controls
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _pages.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.primary,
                      dotColor: AppColors.border,
                    ),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: isLastPage ? 'Mulai Sekarang' : 'Selanjutnya',
                    onPressed: () {
                      if (isLastPage) {
                        _navigateToLogin();
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String image;

  OnboardingData({
    required this.title,
    required this.description,
    required this.image,
  });
}
