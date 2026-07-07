import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/core/enums/user_role.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/auth/registration_complete_screen.dart';
import 'package:karirku_application/screens/employer/employer_main_screen.dart';
import 'package:karirku_application/screens/job_seeker/seeker_main_screen.dart';
import 'package:provider/provider.dart';

/// 4-digit email OTP screen. Reads the email/name of the account
/// currently pending verification straight from [AuthProvider].
///
/// [fromRegistration] controls what happens after a successful
/// verification: a brand-new account is sent to the celebratory
/// [RegistrationCompleteScreen], while a returning-but-unverified
/// login goes straight into the app.
class OtpScreen extends StatefulWidget {
  final bool fromRegistration;

  const OtpScreen({super.key, this.fromRegistration = true});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  Timer? _cooldownTimer;
  int _cooldown = 30;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  void _startCooldown() {
    _cooldown = 30;
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_cooldown == 0) {
        timer.cancel();
      } else {
        setState(() => _cooldown--);
      }
    });
  }

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _handleConfirm() async {
    if (_code.length != 4) return;
    FocusScope.of(context).unfocus();

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final role = authProvider.pendingRole ?? UserRole.jobSeeker;
    final name = authProvider.pendingName ?? '';
    final success = await authProvider.verifyOtp(_code);

    if (!mounted) return;

    if (!success) {
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes.first.requestFocus();
      return;
    }

    if (widget.fromRegistration) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => RegistrationCompleteScreen(name: name, role: role),
        ),
      );
    } else {
      final jobProvider = Provider.of<JobProvider>(context, listen: false);
      final uid = authProvider.currentUser?.uid;
      if (uid != null) await jobProvider.loadSavedJobs(uid);
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => role == UserRole.employer
              ? const EmployerMainScreen()
              : const SeekerMainScreen(),
        ),
        (route) => false,
      );
    }
  }

  Future<void> _handleResend() async {
    if (_cooldown != 0) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final ok = await authProvider.resendOtp();
    if (!mounted) return;
    if (ok) {
      _startCooldown();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode baru telah dikirim ke email Anda')),
      );
    }
  }

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = context.watch<AuthProvider>().pendingEmail ?? '';
    final otpError = context.watch<AuthProvider>().otpError;
    final otpLoading = context.watch<AuthProvider>().otpLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.navy),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text('Kode Verifikasi', style: AppTextStyles.heading1),
              const SizedBox(height: 12),
              Text.rich(
                TextSpan(
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(
                        text: 'Kami telah mengirimkan kode verifikasi ke '),
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) => _buildBox(index)),
              ),
              if (otpError != null) ...[
                const SizedBox(height: 16),
                Text(
                  otpError,
                  style:
                      AppTextStyles.bodySmall.copyWith(color: AppColors.error),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Tidak menerima kode? ',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  GestureDetector(
                    onTap: _handleResend,
                    child: Text(
                      _cooldown == 0
                          ? 'Resend Code'
                          : 'Resend Code (${_cooldown}s)',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: _cooldown == 0
                            ? AppColors.primary
                            : AppColors.textHint,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: (_code.length == 4 && !otpLoading)
                      ? _handleConfirm
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.border,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: otpLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : Text('Confirm', style: AppTextStyles.buttonLarge),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox(int index) {
    return SizedBox(
      width: 64,
      height: 64,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: AppTextStyles.heading2,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
          setState(() {});
          if (_code.length == 4) _handleConfirm();
        },
      ),
    );
  }
}
