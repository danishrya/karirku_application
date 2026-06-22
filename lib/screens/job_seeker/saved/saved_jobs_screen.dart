import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/job_seeker/detail/job_detail_screen.dart';
import 'package:karirku_application/widgets/job_card.dart';
import 'package:provider/provider.dart';

class SavedJobsScreen extends StatelessWidget {
  const SavedJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lowongan Disimpan'),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<JobProvider>(
        builder: (context, provider, child) {
          final savedJobs = provider.savedJobs;

          if (savedJobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border_rounded, size: 64, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada lowongan tersimpan.',
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            itemCount: savedJobs.length,
            itemBuilder: (context, index) {
              return JobCard(
                job: savedJobs[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailScreen(job: savedJobs[index]),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
