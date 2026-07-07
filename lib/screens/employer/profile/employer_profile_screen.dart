import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class EmployerProfileScreen extends StatelessWidget {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profil Perusahaan'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.surfaceVariant,
              child:
                  Icon(Icons.business, size: 50, color: AppColors.accentDark),
            ),
            const SizedBox(height: 16),
            Text(user?.companyName ?? user?.name ?? 'Perusahaan',
                style: AppTextStyles.heading2),
            const SizedBox(height: 4),
            Text(user?.email ?? '-',
                style: AppTextStyles.bodyLarge
                    .copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            _buildProfileMenuItem(
              icon: Icons.edit_outlined,
              title: 'Edit Profil Perusahaan',
              onTap: () {},
            ),
            _buildProfileMenuItem(
              icon: Icons.settings_outlined,
              title: 'Pengaturan Akun',
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
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
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
