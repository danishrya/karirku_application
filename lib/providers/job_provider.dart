import 'dart:async';

import 'package:flutter/material.dart';
import 'package:karirku_application/models/job_model.dart';
import 'package:karirku_application/services/firebase_service.dart';

/// State management for job listings using ChangeNotifier + Firestore.
class JobProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<JobModel> _jobs = [];
  List<String> _savedJobIds = [];
  StreamSubscription? _jobsSubscription;
  bool _isLoading = true; // tambah ini

  List<JobModel> get jobs => List.unmodifiable(_jobs);
  bool get isLoading => _isLoading; // tambah ini

  /// Jobs saved by the current user.
  List<JobModel> get savedJobs {
    return _jobs.where((job) => _savedJobIds.contains(job.id)).toList();
  }

  /// Start listening to jobs from Firestore.
  void listenToJobs() {
    _jobsSubscription?.cancel();
    _jobsSubscription = _firebaseService.getJobsStream().listen((jobList) {
      _jobs = jobList.map((job) {
        return job.copyWith(isSaved: _savedJobIds.contains(job.id));
      }).toList();
      _isLoading = false; // stream udah nyampe, selesai loading
      notifyListeners();
    });
  }

  /// Load saved job IDs for the current user.
  Future<void> loadSavedJobs(String uid) async {
    _savedJobIds = await _firebaseService.getSavedJobIds(uid);
    // Re-apply isSaved flags
    _jobs = _jobs.map((job) {
      return job.copyWith(isSaved: _savedJobIds.contains(job.id));
    }).toList();
    notifyListeners();
  }

  /// Jobs posted by a specific employer (by UID).
  List<JobModel> getJobsByEmployer(String uid) {
    final myJobs = _jobs.where((job) => job.postedBy == uid).toList();
    // Temporary fallback for prototype testing: 
    // If the employer has no jobs, show some seeded jobs so the UI is visible.
    if (myJobs.isEmpty && _jobs.isNotEmpty) {
      return _jobs.take(3).toList();
    }
    return myJobs;
  }

  /// Add a new job posting to Firestore.
  Future<void> addJob(JobModel job) async {
    await _firebaseService.addJob(job);
    // The stream listener will automatically update _jobs
  }

  /// Remove a job posting from Firestore.
  Future<void> removeJob(String jobId) async {
    await _firebaseService.deleteJob(jobId);
    // The stream listener will automatically update _jobs
  }

  /// Toggle the save/bookmark status for a user.
  Future<void> toggleSaveJob(String uid, String jobId) async {
    // Optimistic update
    if (_savedJobIds.contains(jobId)) {
      _savedJobIds.remove(jobId);
    } else {
      _savedJobIds.add(jobId);
    }
    _jobs = _jobs.map((job) {
      if (job.id == jobId) {
        return job.copyWith(isSaved: _savedJobIds.contains(jobId));
      }
      return job;
    }).toList();
    notifyListeners();

    // Persist to Firestore
    await _firebaseService.toggleSaveJob(uid, jobId);
  }

  /// Search jobs by keyword.
  List<JobModel> searchJobs(String query) {
    if (query.isEmpty) return _jobs;
    final lower = query.toLowerCase();
    return _jobs.where((job) {
      return job.title.toLowerCase().contains(lower) ||
          job.company.toLowerCase().contains(lower) ||
          job.category.toLowerCase().contains(lower) ||
          job.location.toLowerCase().contains(lower);
    }).toList();
  }

  /// Get jobs by category.
  List<JobModel> getJobsByCategory(String category) {
    if (category == 'All') return _jobs;
    return _jobs.where((job) => job.category == category).toList();
  }

  /// Available job categories.
  static const List<String> categories = [
    'All',
    'Design',
    'Engineering',
    'Marketing',
    'Finance',
    'Sales',
    'HR',
    'Operations',
  ];

  /// Work type options.
  static const List<String> workTypes = [
    'Full Time',
    'Part Time',
    'Contract',
    'Internship',
  ];

  /// Employment type options.
  static const List<String> employmentTypes = [
    'Remote',
    'Onsite',
    'Hybrid',
  ];

  @override
  void dispose() {
    _jobsSubscription?.cancel();
    super.dispose();
  }
}
