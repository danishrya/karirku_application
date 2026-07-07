import 'dart:io';

import 'package:flutter/material.dart';
import 'package:karirku_application/core/enums/user_role.dart';
import 'package:karirku_application/models/career_preference.dart';
import 'package:karirku_application/models/user_model.dart';
import 'package:karirku_application/services/firebase_service.dart';

/// Provider for authentication state management.
class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // ─── Pending registration / OTP state ─────────────────────────
  // Holds the identity of the account currently going through the
  // 4-digit email verification step (either right after registering,
  // or when an existing-but-unverified account tries to log in).
  String? _pendingUid;
  String? _pendingEmail;
  String? _pendingName;
  UserRole? _pendingRole;
  bool _otpLoading = false;
  String? _otpError;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  String? get pendingEmail => _pendingEmail;
  String? get pendingName => _pendingName;
  UserRole? get pendingRole => _pendingRole;
  bool get otpLoading => _otpLoading;
  String? get otpError => _otpError;

  // ─── Login ──────────────────────────────────────────────────────

  /// Logs in with email & password.
  /// Returns [LoginResult.verified] on success, [LoginResult.needsVerification]
  /// if the account exists but the email hasn't been verified yet (a fresh
  /// OTP is sent automatically in that case), or [LoginResult.failed].
  Future<LoginResult> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _firebaseService.signIn(email, password);
      final uid = credential.user!.uid;

      _currentUser = await _firebaseService.getUserProfile(uid);

      if (_currentUser == null) {
        _isLoading = false;
        _errorMessage = 'Profil user tidak ditemukan di database.';
        notifyListeners();
        return LoginResult.failed;
      }

      if (!_currentUser!.emailVerified) {
        // Account exists but was never verified — send a fresh code and
        // route the user back through the OTP screen.
        _pendingUid = uid;
        _pendingEmail = _currentUser!.email;
        _pendingName = _currentUser!.name;
        _pendingRole = _currentUser!.role;
        await _firebaseService.generateAndSendOtp(
          uid: uid,
          email: _currentUser!.email ?? email,
          name: _currentUser!.name,
        );
        _isLoading = false;
        notifyListeners();
        return LoginResult.needsVerification;
      }

      _isLoading = false;
      notifyListeners();
      return LoginResult.verified;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _parseFirebaseError(e.toString());
      notifyListeners();
      return LoginResult.failed;
    }
  }

  // ─── Registration ──────────────────────────────────────────────

  /// Creates the Firebase Auth account + Firestore profile, then sends
  /// the first OTP code. On success the caller should navigate to the
  /// OTP screen; [pendingEmail]/[pendingName] are populated for it.
  Future<bool> startRegistration({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? companyName,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final credential = await _firebaseService.signUp(
        name: name,
        email: email,
        password: password,
        role: role,
        companyName: companyName,
      );

      final uid = credential.user!.uid;

      await _firebaseService.generateAndSendOtp(
        uid: uid,
        email: email.trim(),
        name: name.trim(),
      );

      _pendingUid = uid;
      _pendingEmail = email.trim();
      _pendingName = name.trim();
      _pendingRole = role;

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = _parseFirebaseError(e.toString());
      notifyListeners();
      return false;
    }
  }

  // ─── OTP ────────────────────────────────────────────────────────

  /// Verifies the 4-digit code for the pending account. On success,
  /// [currentUser] is populated and ready to use.
  Future<bool> verifyOtp(String code) async {
    if (_pendingUid == null) {
      _otpError = 'Sesi tidak ditemukan. Silakan ulangi proses.';
      notifyListeners();
      return false;
    }

    _otpLoading = true;
    _otpError = null;
    notifyListeners();

    try {
      final result = await _firebaseService.verifyOtp(
        uid: _pendingUid!,
        code: code,
      );

      switch (result) {
        case OtpVerifyResult.success:
          _currentUser = await _firebaseService.getUserProfile(_pendingUid!);
          _otpLoading = false;
          notifyListeners();
          return true;
        case OtpVerifyResult.invalid:
          _otpError = 'Kode salah. Silakan coba lagi.';
          break;
        case OtpVerifyResult.expired:
          _otpError = 'Kode sudah kedaluwarsa. Kirim ulang kode.';
          break;
        case OtpVerifyResult.notFound:
          _otpError = 'Kode tidak ditemukan. Kirim ulang kode.';
          break;
      }

      _otpLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _otpLoading = false;
      _otpError = 'Terjadi kesalahan. Silakan coba lagi.';
      notifyListeners();
      return false;
    }
  }

  /// Requests a brand-new OTP code for the pending account.
  Future<bool> resendOtp() async {
    if (_pendingUid == null || _pendingEmail == null) return false;

    _otpLoading = true;
    _otpError = null;
    notifyListeners();

    try {
      await _firebaseService.generateAndSendOtp(
        uid: _pendingUid!,
        email: _pendingEmail!,
        name: _pendingName ?? '',
      );
      _otpLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _otpLoading = false;
      _otpError = 'Gagal mengirim ulang kode. Coba lagi.';
      notifyListeners();
      return false;
    }
  }

  void clearPendingVerification() {
    _pendingUid = null;
    _pendingEmail = null;
    _pendingName = null;
    _pendingRole = null;
    _otpError = null;
    notifyListeners();
  }

  // ─── Career Preference (job seeker onboarding) ──────────────────

  bool _preferenceSaving = false;
  bool get preferenceSaving => _preferenceSaving;

  /// Uploads a CV or portfolio PDF to Firebase Storage and returns its
  /// download URL.
  Future<String?> uploadDocument({
    required File file,
    required String folder,
    required String fileName,
  }) async {
    final uid = _currentUser?.uid;
    if (uid == null) return null;
    try {
      return await _firebaseService.uploadDocument(
        uid: uid,
        file: file,
        folder: folder,
        fileName: fileName,
      );
    } catch (e) {
      _errorMessage = 'Gagal mengunggah file: $e';
      notifyListeners();
      return null;
    }
  }

  /// Saves the completed career preference profile to Firestore and
  /// refreshes [currentUser] with the result.
  Future<bool> saveCareerPreference(CareerPreference preference) async {
    final uid = _currentUser?.uid;
    if (uid == null) return false;

    _preferenceSaving = true;
    notifyListeners();

    try {
      await _firebaseService.updateCareerPreference(uid, preference);
      _currentUser = _currentUser!.copyWith(careerPreference: preference);
      _preferenceSaving = false;
      notifyListeners();
      return true;
    } catch (e) {
      _preferenceSaving = false;
      _errorMessage = 'Gagal menyimpan preferensi karir: $e';
      notifyListeners();
      return false;
    }
  }

  // ─── Session ────────────────────────────────────────────────────

  Future<void> logout() async {
    await _firebaseService.signOut();
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> refreshUser() async {
    final firebaseUser = _firebaseService.currentFirebaseUser;
    if (firebaseUser != null) {
      _currentUser = await _firebaseService.getUserProfile(firebaseUser.uid);
      notifyListeners();
    }
  }

  /// For a user who is already Firebase-authenticated (session restored on
  /// app launch) but whose profile is still unverified: populates the
  /// pending-OTP state and fires off a fresh code so [OtpScreen] works.
  Future<void> resendVerificationForCurrentSession() async {
    final user = _currentUser;
    final firebaseUser = _firebaseService.currentFirebaseUser;
    if (user == null || firebaseUser == null) return;

    _pendingUid = firebaseUser.uid;
    _pendingEmail = user.email;
    _pendingName = user.name;
    _pendingRole = user.role;

    await _firebaseService.generateAndSendOtp(
      uid: firebaseUser.uid,
      email: user.email ?? '',
      name: user.name,
    );
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _parseFirebaseError(String error) {
    if (error.contains('user-not-found')) {
      return 'Akun tidak ditemukan. Silakan daftar terlebih dahulu.';
    } else if (error.contains('wrong-password') ||
        error.contains('invalid-credential')) {
      return 'Email atau password salah.';
    } else if (error.contains('email-already-in-use')) {
      return 'Email sudah digunakan. Silakan gunakan email lain.';
    } else if (error.contains('weak-password')) {
      return 'Password terlalu lemah. Gunakan minimal 6 karakter.';
    } else if (error.contains('invalid-email')) {
      return 'Format email tidak valid.';
    } else if (error.contains('network-request-failed')) {
      return 'Koneksi internet bermasalah. Coba lagi.';
    } else if (error.contains('too-many-requests')) {
      return 'Terlalu banyak percobaan. Coba lagi nanti.';
    }
    return 'Error: $error';
  }
}

/// Outcome of a login attempt.
enum LoginResult { verified, needsVerification, failed }
