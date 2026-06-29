import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';

class WorkSimulationScreen extends StatelessWidget {
  const WorkSimulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Work Simulation'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.laptop_chromebook_rounded, size: 80, color: AppColors.primary),
            const SizedBox(height: 16),
            Text(
              'Simulasi Pekerjaan',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Fitur ini sedang dalam pengembangan.\nCoba lagi nanti!',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
