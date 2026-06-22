import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/job_seeker/detail/job_detail_screen.dart';
import 'package:karirku_application/widgets/job_card.dart';
import 'package:provider/provider.dart';

class MyJobsScreen extends StatelessWidget {
  const MyJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final uid = authProvider.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lowongan Saya'),
        backgroundColor: Colors.transparent,
      ),
      body: Consumer<JobProvider>(
        builder: (context, provider, child) {
          final myJobs = provider.getJobsByEmployer(uid);

          if (myJobs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.work_off_outlined, size: 64, color: AppColors.textHint),
                  const SizedBox(height: 16),
                  Text(
                    'Anda belum membuat lowongan.',
                    style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            itemCount: myJobs.length,
            itemBuilder: (context, index) {
              return JobCard(
                job: myJobs[index],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobDetailScreen(job: myJobs[index]),
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
