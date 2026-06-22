import 'package:flutter/material.dart';
import 'package:karirku_application/core/enums/user_role.dart';
import 'package:karirku_application/models/user_model.dart';
import 'package:karirku_application/services/firebase_service.dart';

/// Provider for authentication state management.
class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> login(String email, String password) async {
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
        return false;
      }

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

  Future<bool> register({
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
      _currentUser = await _firebaseService.getUserProfile(uid);

      if (_currentUser == null) {
        _isLoading = false;
        _errorMessage = 'Gagal memuat profil setelah registrasi.';
        notifyListeners();
        return false;
      }

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