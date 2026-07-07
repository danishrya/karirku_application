import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/core/enums/user_role.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/auth/career/career_preference_screen.dart';
import 'package:karirku_application/screens/employer/employer_main_screen.dart';
import 'package:provider/provider.dart';

class RegistrationCompleteScreen extends StatelessWidget {
  final String name;
  final UserRole role;

  const RegistrationCompleteScreen({
    super.key,
    required this.name,
    required this.role,
  });

  Future<void> _continue(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Employers don't go through the job-seeker career preference wizard —
    // they head straight into the app.
    if (role == UserRole.employer) {
      final jobProvider = Provider.of<JobProvider>(context, listen: false);
      final uid = authProvider.currentUser?.uid;
      if (uid != null) await jobProvider.loadSavedJobs(uid);
      authProvider.clearPendingVerification();
      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const EmployerMainScreen()),
        (route) => false,
      );
      return;
    }

    authProvider.clearPendingVerification();
    if (!context.mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CareerPreferenceScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = AppColors.primary;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              Text(
                'Hi, $name 👋',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading1.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                'Registrasimu Telah Berhasil',
                textAlign: TextAlign.center,
                style: AppTextStyles.heading4.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.task_alt_rounded,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'Buka akses ke ratusan lowongan kerja hanya dengan melengkapi profilmu. Kesempatan besar menantimu!',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.85),
                  height: 1.6,
                ),
              ),
              const Spacer(flex: 3),
              GestureDetector(
                onTap: () => _continue(context),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: const BoxDecoration(
                    color: AppColors.navy,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
