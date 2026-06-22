import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/models/job_model.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class JobDetailScreen extends StatelessWidget {
  final JobModel job;

  const JobDetailScreen({super.key, required this.job});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Consumer2<JobProvider, AuthProvider>(
            builder: (context, jobProvider, authProvider, child) {
              final currentJob = jobProvider.jobs.firstWhere(
                (j) => j.id == job.id,
                orElse: () => job,
              );
              return IconButton(
                icon: Icon(
                  currentJob.isSaved ? Icons.bookmark : Icons.bookmark_border,
                  color: currentJob.isSaved ? AppColors.primary : AppColors.textPrimary,
                ),
                onPressed: () {
                  final uid = authProvider.currentUser?.uid;
                  if (uid != null) {
                    jobProvider.toggleSaveJob(uid, job.id);
                  }
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: job.companyLogo.startsWith('http')
                      ? Image.network(
                          job.companyLogo,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.business, color: AppColors.primary),
                        )
                      : Image.asset(job.companyLogo, fit: BoxFit.contain),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(job.title, style: AppTextStyles.heading2),
                      const SizedBox(height: 4),
                      Text(
                        job.company,
                        style: AppTextStyles.heading4.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoItem(Icons.location_on_outlined, job.location),
                _buildInfoItem(Icons.work_outline, job.workType),
                _buildInfoItem(Icons.attach_money_outlined, job.salary.split(' ').first), // Shorten salary
              ],
            ),
            const SizedBox(height: 32),

            // Description
            Text('Deskripsi Pekerjaan', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            Text(
              job.description,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),

            // Requirements
            Text('Persyaratan', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            ...job.requirements.map((req) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.circle, size: 8, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          req,
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 100), // padding for bottom button
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(24.0),
        child: CustomButton(
          text: 'Lamar Pekerjaan Ini',
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Aplikasi lamaran berhasil dikirim!')),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
