import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/screens/auth/role_selection_screen.dart';
import 'package:provider/provider.dart';

class SeekerProfileScreen extends StatelessWidget {
  const SeekerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.surfaceVariant,
              child: Icon(Icons.person, size: 50, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            Text(user?.name ?? 'User', style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text(user?.email ?? '-', style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            
            _buildProfileMenuItem(
              icon: Icons.person_outline,
              title: 'Edit Profil',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.article_outlined,
              title: 'Curriculum Vitae',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.history,
              title: 'Riwayat Lamaran',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.help_outline,
              title: 'Pusat Bantuan',
              onTap: () {},
            ),
            const SizedBox(height: 24),
            _buildProfileMenuItem(
              icon: Icons.logout,
              title: 'Keluar',
              color: AppColors.error,
              onTap: () async {
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const RoleSelectionScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = AppColors.textPrimary,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: AppTextStyles.bodyLarge.copyWith(color: color)),
      trailing: Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
    );
  }
}
