import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:provider/provider.dart';

class EmployerDashboardScreen extends StatelessWidget {
  const EmployerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final companyName = authProvider.currentUser?.companyName ?? 'Perusahaan';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        companyName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Dashboard',
                        style: AppTextStyles.heading2,
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.surfaceVariant,
                    child: Icon(Icons.business, color: AppColors.accentDark),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Stats Cards from real data
              Consumer<JobProvider>(
                builder: (context, jobProvider, child) {
                  final uid = authProvider.currentUser?.uid ?? '';
                  final myJobs = jobProvider.getJobsByEmployer(uid);

                  return Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Total Lowongan',
                          '${myJobs.length}',
                          Icons.work,
                          AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Total Pelamar',
                          '0',
                          Icons.people,
                          AppColors.accentDark,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),

              Text('Aktivitas Terakhir', style: AppTextStyles.heading4),
              const SizedBox(height: 16),
              
              // Empty state for recent activity
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    Icon(Icons.history_rounded, size: 48, color: AppColors.textHint),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada aktivitas',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
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

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 16),
          Text(
            value,
            style: AppTextStyles.heading1.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
