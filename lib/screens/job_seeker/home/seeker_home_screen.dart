import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/job_seeker/detail/job_detail_screen.dart';
import 'package:karirku_application/widgets/custom_text_field.dart';
import 'package:karirku_application/widgets/job_card.dart';
import 'package:karirku_application/widgets/section_header.dart';
import 'package:provider/provider.dart';

class SeekerHomeScreen extends StatelessWidget {
  const SeekerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.currentUser?.name ?? 'User';

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
                        'Halo, $userName 👋',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Temukan Pekerjaanmu',
                        style: AppTextStyles.heading2,
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: AppColors.surfaceVariant,
                    child: Icon(Icons.person, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Search
              CustomTextField(
                hintText: 'Cari posisi, perusahaan...',
                prefixIcon: Icons.search_rounded,
                suffixIcon: Icons.tune_rounded,
              ),
              const SizedBox(height: 24),

              // Categories
              const SectionHeader(title: 'Kategori Populer'),
              SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    _CategoryCard(icon: Icons.design_services, title: 'Design', color: AppColors.primary),
                    _CategoryCard(icon: Icons.code, title: 'IT & Eng', color: AppColors.accent),
                    _CategoryCard(icon: Icons.campaign, title: 'Marketing', color: AppColors.warning),
                    _CategoryCard(icon: Icons.account_balance_wallet, title: 'Finance', color: AppColors.success),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Recommended Jobs
              SectionHeader(
                title: 'Rekomendasi Untukmu',
                actionText: 'Lihat Semua',
                onActionTap: () {},
              ),
              Consumer<JobProvider>(
                builder: (context, provider, child) {
                  final jobs = provider.jobs.take(3).toList(); // Show first 3

                  if (jobs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
                        child: Text(
                          'Memuat lowongan...',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: jobs.length,
                    itemBuilder: (context, index) {
                      return JobCard(
                        job: jobs[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JobDetailScreen(job: jobs[index]),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTextStyles.labelSmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
