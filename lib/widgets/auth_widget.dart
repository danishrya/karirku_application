import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_assets.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';

/// "◀  [logo]  Karirku!" header used on the Login / Register / Complete
/// screens, which all sit on a solid brand-colored background.
class AuthTopBar extends StatelessWidget {
  final VoidCallback? onBack;
  final Color foreground;

  const AuthTopBar({super.key, this.onBack, this.foreground = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack ?? () => Navigator.maybePop(context),
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: foreground, size: 20),
        ),
        const SizedBox(width: 4),
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(5),
          child: Image.asset(AppAssets.logo, fit: BoxFit.contain),
        ),
        const SizedBox(width: 8),
        Text(
          'Karirku!',
          style: AppTextStyles.heading4.copyWith(
            color: foreground,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

/// Full-width light CTA button used on colored auth backgrounds
/// (white surface, colored label — the inverse of [CustomButton]).
class AuthPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color foregroundColor;

  const AuthPrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.foregroundColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          disabledBackgroundColor: Colors.white.withValues(alpha: 0.7),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: foregroundColor,
                ),
              )
            : Text(
                text,
                style: AppTextStyles.buttonLarge.copyWith(
                  color: foregroundColor,
                ),
              ),
      ),
    );
  }
}

/// Row of circular social sign-in buttons (Google / Apple / LinkedIn).
/// These are wired up to show a "coming soon" note — swap [onGoogle],
/// [onApple], [onLinkedIn] for real provider sign-in when ready.
class SocialLoginRow extends StatelessWidget {
  final VoidCallback? onGoogle;
  final VoidCallback? onApple;
  final VoidCallback? onLinkedIn;

  const SocialLoginRow({
    super.key,
    this.onGoogle,
    this.onApple,
    this.onLinkedIn,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialButton(onTap: onGoogle, child: _GoogleG()),
        const SizedBox(width: 16),
        _SocialButton(
          onTap: onApple,
          child: const Icon(Icons.apple_rounded, color: Colors.black, size: 24),
        ),
        const SizedBox(width: 16),
        _SocialButton(
          onTap: onLinkedIn,
          child: const Text(
            'in',
            style: TextStyle(
              color: Color(0xFF0A66C2),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const _SocialButton({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Segera hadir')),
              ),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

class _GoogleG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Text(
      'G',
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 20,
        color: Color(0xFF4285F4),
      ),
    );
  }
}

/// Terms & privacy agreement checkbox with an inline "learn more" link.
class AuthAgreementCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String leadingText;
  final String linkText;

  const AuthAgreementCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.leadingText,
    required this.linkText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 22,
          height: 22,
          child: Checkbox(
            value: value,
            onChanged: (v) => onChanged(v ?? false),
            activeColor: Colors.white,
            checkColor: AppColors.primary,
            side: const BorderSide(color: Colors.white, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
                children: [
                  TextSpan(text: leadingText),
                  TextSpan(
                    text: linkText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
