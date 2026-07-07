import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/core/enums/user_role.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/auth/otp_screen.dart';
import 'package:karirku_application/screens/auth/register_screen.dart';
import 'package:karirku_application/screens/employer/employer_main_screen.dart';
import 'package:karirku_application/screens/job_seeker/seeker_main_screen.dart';
import 'package:karirku_application/widgets/auth_widget.dart';
import 'package:karirku_application/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  final UserRole role;

  const LoginScreen({super.key, this.role = UserRole.jobSeeker});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _agree = true;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Anda harus menyetujui Ketentuan Layanan dan Kebijakan Privasi'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;

    switch (result) {
      case LoginResult.verified:
        final jobProvider = Provider.of<JobProvider>(context, listen: false);
        final uid = authProvider.currentUser?.uid;
        if (uid != null) await jobProvider.loadSavedJobs(uid);
        if (!mounted) return;
        _navigateToMainScreen();
        break;
      case LoginResult.needsVerification:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const OtpScreen(fromRegistration: false),
          ),
        );
        break;
      case LoginResult.failed:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authProvider.errorMessage ?? 'Login gagal'),
            backgroundColor: AppColors.error,
          ),
        );
        break;
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
    const primaryColor = AppColors.primary;

    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AuthTopBar(),
                const SizedBox(height: 32),
                Text(
                  'Selamat Datang Kembali\nPejuang Kerja!',
                  style: AppTextStyles.heading1.copyWith(color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text(
                  'Masuk ke akun dan jelajahi karir terbaik untukmu.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
                const SizedBox(height: 36),
                CustomTextField(
                  hintText: 'Email or Username',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Password',
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
                const SizedBox(height: 20),
                AuthAgreementCheckbox(
                  value: _agree,
                  onChanged: (v) => setState(() => _agree = v),
                  leadingText: 'Ya, Saya Mengerti dan setuju dengan ',
                  linkText: 'Ketentuan Layanan dan Kebijakan Privasi',
                ),
                const SizedBox(height: 32),
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return AuthPrimaryButton(
                      text: 'Login',
                      isLoading: authProvider.isLoading,
                      foregroundColor: primaryColor,
                      onPressed: _handleLogin,
                    );
                  },
                ),
                const SizedBox(height: 28),
                const SocialLoginRow(),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't Have An Account? ",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Register',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
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
