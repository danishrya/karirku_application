import 'package:karirku_application/core/enums/user_role.dart';

class UserModel {
  final String uid;
  final String name;
  final UserRole role;
  final String? companyName;
  final String? email;
  final List<String> savedJobs;

  const UserModel({
    required this.uid,
    required this.name,
    required this.role,
    this.companyName,
    this.email,
    this.savedJobs = const [],
  });

  /// Serialize to a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'role': role == UserRole.employer ? 'employer' : 'jobSeeker',
      'companyName': companyName,
      'email': email,
      'savedJobs': savedJobs,
    };
  }

  /// Deserialize from a Firestore document.
  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      role: map['role'] == 'employer' ? UserRole.employer : UserRole.jobSeeker,
      companyName: map['companyName'],
      email: map['email'],
      savedJobs: List<String>.from(map['savedJobs'] ?? []),
    );
  }

  /// Creates a copy with modified fields.
  UserModel copyWith({
    String? uid,
    String? name,
    UserRole? role,
    String? companyName,
    String? email,
    List<String>? savedJobs,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      role: role ?? this.role,
      companyName: companyName ?? this.companyName,
      email: email ?? this.email,
      savedJobs: savedJobs ?? this.savedJobs,
    );
  }
}
