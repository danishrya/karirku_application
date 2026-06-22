import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/screens/job_seeker/explore/seeker_explore_screen.dart';
import 'package:karirku_application/screens/job_seeker/home/seeker_home_screen.dart';
import 'package:karirku_application/screens/job_seeker/profile/seeker_profile_screen.dart';
import 'package:karirku_application/screens/job_seeker/saved/saved_jobs_screen.dart';

class SeekerMainScreen extends StatefulWidget {
  const SeekerMainScreen({super.key});

  @override
  State<SeekerMainScreen> createState() => _SeekerMainScreenState();
}

class _SeekerMainScreenState extends State<SeekerMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const SeekerHomeScreen(),
    const SeekerExploreScreen(),
    const SavedJobsScreen(),
    const SeekerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppColors.primary,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          Icon(Icons.home_rounded, color: Colors.white),
          Icon(Icons.explore_rounded, color: Colors.white),
          Icon(Icons.bookmark_rounded, color: Colors.white),
          Icon(Icons.person_rounded, color: Colors.white),
        ],
      ),
    );
  }
}
