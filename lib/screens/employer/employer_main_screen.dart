import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/screens/employer/dashboard/employer_dashboard_screen.dart';
import 'package:karirku_application/screens/employer/my_jobs/my_jobs_screen.dart';
import 'package:karirku_application/screens/employer/post_job/post_job_screen.dart';
import 'package:karirku_application/screens/employer/profile/employer_profile_screen.dart';

class EmployerMainScreen extends StatefulWidget {
  const EmployerMainScreen({super.key});

  @override
  State<EmployerMainScreen> createState() => _EmployerMainScreenState();
}

class _EmployerMainScreenState extends State<EmployerMainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const EmployerDashboardScreen(),
    const PostJobScreen(),
    const MyJobsScreen(),
    const EmployerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: AppColors.accentDark,
        animationDuration: const Duration(milliseconds: 300),
        index: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          Icon(Icons.dashboard_rounded, color: Colors.white),
          Icon(Icons.add_box_rounded, color: Colors.white),
          Icon(Icons.work_history_rounded, color: Colors.white),
          Icon(Icons.business_rounded, color: Colors.white),
        ],
      ),
    );
  }
}
