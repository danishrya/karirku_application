import 'package:cloud_firestore/cloud_firestore.dart';

/// Data model representing a job listing.
class JobModel {
  final String id;
  final String title;
  final String company;
  final String companyLogo;
  final String workType; // Full Time / Part Time / Contract / Internship
  final String employmentType; // Remote / Onsite / Hybrid
  final String salary;
  final String location;
  final String description;
  final List<String> requirements;
  final String category;
  final DateTime postedAt;
  final String postedBy; // Firebase UID of the employer
  bool isSaved;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.companyLogo,
    required this.workType,
    required this.employmentType,
    required this.salary,
    required this.location,
    required this.description,
    required this.requirements,
    required this.category,
    required this.postedAt,
    required this.postedBy,
    this.isSaved = false,
  });

  /// Serialize to a Map for Firestore.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'companyLogo': companyLogo,
      'workType': workType,
      'employmentType': employmentType,
      'salary': salary,
      'location': location,
      'description': description,
      'requirements': requirements,
      'category': category,
      'postedAt': Timestamp.fromDate(postedAt),
      'postedBy': postedBy,
    };
  }

  /// Deserialize from a Firestore document snapshot.
  factory JobModel.fromMap(String id, Map<String, dynamic> map) {
    return JobModel(
      id: id,
      title: map['title']?.toString() ?? '',
      company: map['company']?.toString() ?? '',
      companyLogo: map['companyLogo']?.toString() ?? '',
      workType: map['workType']?.toString() ?? '',
      employmentType: map['employmentType']?.toString() ?? '',
      salary: map['salary']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      requirements: map['requirements'] is Iterable 
          ? List<String>.from(map['requirements']) 
          : [],
      category: map['category']?.toString() ?? '',
      postedAt: map['postedAt'] is Timestamp 
          ? (map['postedAt'] as Timestamp).toDate() 
          : DateTime.now(),
      postedBy: map['postedBy']?.toString() ?? '',
    );
  }

  /// Creates a copy with modified fields.
  JobModel copyWith({
    String? id,
    String? title,
    String? company,
    String? companyLogo,
    String? workType,
    String? employmentType,
    String? salary,
    String? location,
    String? description,
    List<String>? requirements,
    String? category,
    DateTime? postedAt,
    String? postedBy,
    bool? isSaved,
  }) {
    return JobModel(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      companyLogo: companyLogo ?? this.companyLogo,
      workType: workType ?? this.workType,
      employmentType: employmentType ?? this.employmentType,
      salary: salary ?? this.salary,
      location: location ?? this.location,
      description: description ?? this.description,
      requirements: requirements ?? this.requirements,
      category: category ?? this.category,
      postedAt: postedAt ?? this.postedAt,
      postedBy: postedBy ?? this.postedBy,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
