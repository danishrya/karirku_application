import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/core/enums/user_role.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/auth/register_screen.dart';
import 'package:karirku_application/screens/employer/employer_main_screen.dart';
import 'package:karirku_application/screens/job_seeker/seeker_main_screen.dart';
import 'package:karirku_application/widgets/custom_button.dart';
import 'package:karirku_application/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final UserRole role;

  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        // Load saved jobs for the logged-in user
        final jobProvider = Provider.of<JobProvider>(context, listen: false);
        final uid = authProvider.currentUser!.uid;
        await jobProvider.loadSavedJobs(uid);

        if (!mounted) return;
        _navigateToMainScreen();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Login gagal'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _navigateToMainScreen() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final role = authProvider.currentUser?.role ?? widget.role;

    if (role == UserRole.jobSeeker) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SeekerMainScreen()),
        (route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const EmployerMainScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmployer = widget.role == UserRole.employer;
    final primaryColor = isEmployer ? AppColors.accentDark : AppColors.primary;
    final title = isEmployer ? 'Login Employer' : 'Login Pencari Kerja';
    final subtitle = isEmployer
        ? 'Masuk untuk mengelola lowongan dan kandidat.'
        : 'Masuk untuk menemukan pekerjaan impianmu.';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.heading1,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  label: 'Email',
                  hintText: 'Masukkan alamat email',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomTextField(
                  label: 'Password',
                  hintText: 'Masukkan kata sandi',
                  prefixIcon: Icons.lock_outline_rounded,
                  obscureText: !_isPasswordVisible,
                  controller: _passwordController,
                  suffixIcon: _isPasswordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  onSuffixTap: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Lupa Password?',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: authProvider.isLoading ? 'Memproses...' : 'Login',
                      onPressed: authProvider.isLoading ? null : _handleLogin,
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun?',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(
                              role: widget.role,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Daftar',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
