import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/job_seeker/detail/job_detail_screen.dart';
import 'package:karirku_application/screens/job_seeker/mentoring/mentoring_screen.dart';
import 'package:karirku_application/screens/job_seeker/simulation/work_simulation_screen.dart';
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
      body: Stack(
        children: [
          // Blue background pinned to top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 350,
            child: Container(color: AppColors.primary),
          ),
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Blue Header Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Halo, $userName 👋',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white70,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Temukan Pekerjaanmu',
                                  style: AppTextStyles.heading2.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white24,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Search Input
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari posisi, perusahaan...',
                            hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                            prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
                            suffixIcon: const Icon(Icons.tune_rounded, color: AppColors.primary),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // White Content Sheet
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Categories
                        const SectionHeader(title: 'Fitur KarirKu'),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              _CategoryCard(
                                icon: Icons.laptop_chromebook_rounded, 
                                title: 'Simulasi', 
                                color: AppColors.primary,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkSimulationScreen()));
                                },
                              ),
                              _CategoryCard(
                                icon: Icons.people_alt_rounded, 
                                title: 'Mentoring', 
                                color: AppColors.accent,
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MentoringScreen()));
                                },
                              ),
                              _CategoryCard(
                                icon: Icons.design_services, 
                                title: 'Design', 
                                color: AppColors.warning,
                                onTap: () {},
                              ),
                              _CategoryCard(
                                icon: Icons.code, 
                                title: 'IT & Eng', 
                                color: AppColors.success,
                                onTap: () {},
                              ),
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
                            final jobs = provider.jobs.take(5).toList();

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
                        const SizedBox(height: 80), // Padding for bottom nav
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
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
      ),
    );
  }
}
