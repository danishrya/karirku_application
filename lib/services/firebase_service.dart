import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:karirku_application/core/enums/user_role.dart';
import 'package:karirku_application/models/career_preference.dart';
import 'package:karirku_application/models/job_model.dart';
import 'package:karirku_application/models/user_model.dart';

/// Centralized service for all Firebase operations.
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// How long a generated OTP code stays valid.
  static const Duration otpValidity = Duration(minutes: 5);

  // ─── Auth ──────────────────────────────────────────────────────

  /// Get the currently logged-in Firebase user.
  User? get currentFirebaseUser => _auth.currentUser;

  /// Sign in with email and password.
  Future<UserCredential> signIn(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  /// Create a new account and store the user profile in Firestore.
  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    String? companyName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    // Store the user profile document.
    final user = UserModel(
      uid: credential.user!.uid,
      name: name.trim(),
      role: role,
      companyName: companyName?.trim(),
      email: email.trim(),
    );

    await _firestore
        .collection('users')
        .doc(credential.user!.uid)
        .set(user.toMap());

    return credential;
  }

  /// Sign out the current user.
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ─── Email OTP Verification ──────────────────────────────────────
  //
  // The 4-digit code is generated here and stored in the
  // `otp_verifications/{uid}` document. The code is delivered by writing
  // a document to the `mail` collection, which is the exact format the
  // official Firebase "Trigger Email" extension expects. Once that
  // extension is installed (Firebase Console → Extensions → "Trigger
  // Email") and pointed at the `mail` collection with your SMTP/SendGrid
  // credentials, every document written here is automatically emailed to
  // the user — no separate backend server is required.
  //
  // Until the extension is installed, the code is only visible in the
  // debug console (kDebugMode) so the flow can still be tested end-to-end.

  String _generateOtpCode() {
    final rand = Random.secure();
    return List.generate(4, (_) => rand.nextInt(10)).join();
  }

  /// Generates a new 4-digit code, stores it, and queues the delivery
  /// email. Returns the generated code (debug/testing convenience only).
  Future<String> generateAndSendOtp({
    required String uid,
    required String email,
    required String name,
  }) async {
    final code = _generateOtpCode();
    final now = DateTime.now();

    await _firestore.collection('otp_verifications').doc(uid).set({
      'email': email,
      'code': code,
      'attempts': 0,
      'createdAt': Timestamp.fromDate(now),
      'expiresAt': Timestamp.fromDate(now.add(otpValidity)),
    });

    // Queued email — sent automatically once the Trigger Email extension
    // is watching the `mail` collection.
    await _firestore.collection('mail').add({
      'to': [email],
      'message': {
        'subject': 'Kode Verifikasi KarirKu Anda',
        'html': '''
          <div style="font-family:sans-serif;padding:24px">
            <h2>Hi, $name 👋</h2>
            <p>Kode verifikasi email Anda adalah:</p>
            <h1 style="letter-spacing:8px">$code</h1>
            <p>Kode ini berlaku selama 5 menit. Jangan bagikan kode ini kepada siapa pun.</p>
          </div>
        ''',
      },
    });

    if (kDebugMode) {
      debugPrint('🔐 [DEV ONLY] OTP for $email: $code');
    }

    return code;
  }

  /// Verifies a submitted OTP code against the stored one.
  /// Returns true and marks the user verified if correct & not expired.
  Future<OtpVerifyResult> verifyOtp({
    required String uid,
    required String code,
  }) async {
    final ref = _firestore.collection('otp_verifications').doc(uid);
    final doc = await ref.get();

    if (!doc.exists) {
      return OtpVerifyResult.notFound;
    }

    final data = doc.data()!;
    final expiresAt = (data['expiresAt'] as Timestamp).toDate();

    if (DateTime.now().isAfter(expiresAt)) {
      return OtpVerifyResult.expired;
    }

    if (data['code'] != code) {
      await ref.update({'attempts': FieldValue.increment(1)});
      return OtpVerifyResult.invalid;
    }

    // Correct code: mark the user's profile as verified and clean up.
    await _firestore.collection('users').doc(uid).update({
      'emailVerified': true,
    });
    await ref.delete();

    return OtpVerifyResult.success;
  }

  // ─── Users ─────────────────────────────────────────────────────

  /// Fetch the user profile from Firestore.
  Future<UserModel?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(uid, doc.data()!);
    }
    return null;
  }

  /// Update the user profile in Firestore.
  Future<void> updateUserProfile(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }

  /// Persist the job seeker's career preference profile (status, desired
  /// roles/industries, CV & portfolio links) as a nested map on their
  /// user document.
  Future<void> updateCareerPreference(
    String uid,
    CareerPreference preference,
  ) async {
    await _firestore.collection('users').doc(uid).update({
      'careerPreference': preference.toMap(),
    });
  }

  /// Uploads a local file (CV or portfolio PDF) to Firebase Storage under
  /// `documents/{uid}/{folder}/{fileName}` and returns its public
  /// download URL.
  Future<String> uploadDocument({
    required String uid,
    required File file,
    required String folder,
    required String fileName,
  }) async {
    final ref =
        FirebaseStorage.instance.ref().child('documents/$uid/$folder/$fileName');
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }

  // ─── Jobs ──────────────────────────────────────────────────────

  /// Stream all jobs ordered by newest first.
  Stream<List<JobModel>> getJobsStream() {
    return _firestore
        .collection('jobs')
        .orderBy('postedAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return JobModel.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  /// Add a new job to Firestore. Returns the document ID.
  Future<String> addJob(JobModel job) async {
    final docRef = await _firestore.collection('jobs').add(job.toMap());
    return docRef.id;
  }

  /// Delete a job from Firestore.
  Future<void> deleteJob(String jobId) async {
    await _firestore.collection('jobs').doc(jobId).delete();
  }

  // ─── Saved Jobs ────────────────────────────────────────────────

  /// Toggle a job's saved status for a user.
  /// Adds or removes the jobId from the user's savedJobs array.
  Future<void> toggleSaveJob(String uid, String jobId) async {
    final userRef = _firestore.collection('users').doc(uid);
    final doc = await userRef.get();

    if (doc.exists) {
      final savedJobs = List<String>.from(doc.data()?['savedJobs'] ?? []);
      if (savedJobs.contains(jobId)) {
        savedJobs.remove(jobId);
      } else {
        savedJobs.add(jobId);
      }
      await userRef.update({'savedJobs': savedJobs});
    }
  }

  /// Get the list of saved job IDs for a user.
  Future<List<String>> getSavedJobIds(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return List<String>.from(doc.data()!['savedJobs'] ?? []);
    }
    return [];
  }
}

/// Result of an OTP verification attempt.
enum OtpVerifyResult { success, invalid, expired, notFound }