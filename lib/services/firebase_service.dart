import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:karirku_application/core/enums/user_role.dart';
import 'package:karirku_application/models/job_model.dart';
import 'package:karirku_application/models/user_model.dart';

/// Centralized service for all Firebase operations.
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
