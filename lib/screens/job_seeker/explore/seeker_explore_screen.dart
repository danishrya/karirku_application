import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/job_seeker/detail/job_detail_screen.dart';
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
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 300,
            child: Container(color: AppColors.primary),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Blue Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Eksplor Lowongan',
                        style: AppTextStyles.heading2.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Cari posisi, perusahaan...',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textHint),
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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
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
                                  selectedColor: AppColors.primaryLight.withValues(alpha: 0.2),
                                  checkmarkColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  side: BorderSide(
                                    color: isSelected ? AppColors.primary : AppColors.border,
                                    width: 0.5,
                                  ),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
