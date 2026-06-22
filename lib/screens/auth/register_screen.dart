import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/core/enums/user_role.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/employer/employer_main_screen.dart';
import 'package:karirku_application/screens/job_seeker/seeker_main_screen.dart';
import 'package:karirku_application/widgets/custom_button.dart';
import 'package:karirku_application/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  final UserRole role;

  const RegisterScreen({super.key, required this.role});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _companyController = TextEditingController(); // Only for employer
  bool _isPasswordVisible = false;

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: widget.role,
        companyName: widget.role == UserRole.employer
            ? _companyController.text.trim()
            : null,
      );

      if (!mounted) return;

      if (success) {
        // Load saved jobs for the new user
        final jobProvider = Provider.of<JobProvider>(context, listen: false);
        final uid = authProvider.currentUser!.uid;
        await jobProvider.loadSavedJobs(uid);

        if (!mounted) return;

        // Navigate to main screen based on role
        if (widget.role == UserRole.jobSeeker) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SeekerMainScreen()),
            (route) => false,
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const EmployerMainScreen()),
            (route) => false,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Registrasi gagal'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _companyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEmployer = widget.role == UserRole.employer;
    final primaryColor = isEmployer ? AppColors.accentDark : AppColors.primary;
    final title = isEmployer ? 'Daftar Employer' : 'Daftar Pencari Kerja';
    final subtitle = isEmployer
        ? 'Buat akun untuk mulai mencari talenta terbaik.'
        : 'Buat akun untuk memulai perjalanan kariermu.';

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
                  label: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap',
                  prefixIcon: Icons.person_outline_rounded,
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                if (isEmployer) ...[
                  const SizedBox(height: 24),
                  CustomTextField(
                    label: 'Nama Perusahaan',
                    hintText: 'Masukkan nama perusahaan',
                    prefixIcon: Icons.business_rounded,
                    controller: _companyController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama perusahaan tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 24),
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
                  hintText: 'Buat kata sandi',
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
                const SizedBox(height: 48),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return CustomButton(
                      text: authProvider.isLoading ? 'Memproses...' : 'Daftar',
                      onPressed:
                          authProvider.isLoading ? null : _handleRegister,
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Masuk',
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
