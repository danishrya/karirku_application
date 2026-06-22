import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/job_seeker/detail/job_detail_screen.dart';
import 'package:karirku_application/widgets/custom_text_field.dart';
import 'package:karirku_application/widgets/job_card.dart';
import 'package:provider/provider.dart';

class SeekerExploreScreen extends StatefulWidget {
  const SeekerExploreScreen({super.key});

  @override
  State<SeekerExploreScreen> createState() => _SeekerExploreScreenState();
}

class _SeekerExploreScreenState extends State<SeekerExploreScreen> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Eksplor Lowongan'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: CustomTextField(
              hintText: 'Cari posisi, perusahaan...',
              prefixIcon: Icons.search_rounded,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Categories list
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: JobProvider.categories.length,
              itemBuilder: (context, index) {
                final category = JobProvider.categories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: AppColors.surface,
                    selectedColor: AppColors.primaryLight.withOpacity(0.2),
                    checkmarkColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Job List
          Expanded(
            child: Consumer<JobProvider>(
              builder: (context, provider, child) {
                var jobs = provider.searchJobs(_searchQuery);
                if (_selectedCategory != 'All') {
                  jobs = jobs.where((j) => j.category == _selectedCategory).toList();
                }

                if (jobs.isEmpty) {
                  return Center(
                    child: Text(
                      'Tidak ada lowongan ditemukan.',
                      style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textHint),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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
          ),
        ],
      ),
    );
  }
}
