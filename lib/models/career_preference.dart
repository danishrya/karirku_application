import 'package:karirku_application/core/enums/job_search_status.dart';

/// A job seeker's career preference profile, collected right after
/// registration (status → desired roles → desired industries → documents).
class CareerPreference {
  final JobSearchStatus status;
  final List<String> desiredRoles;
  final List<String> desiredIndustries;
  final String? cvUrl;
  final String? cvFileName;
  final List<String> portfolioLinks;
  final String? portfolioFileUrl;
  final String? portfolioFileName;
  final bool isComplete;

  const CareerPreference({
    this.status = JobSearchStatus.openToWork,
    this.desiredRoles = const [],
    this.desiredIndustries = const [],
    this.cvUrl,
    this.cvFileName,
    this.portfolioLinks = const [],
    this.portfolioFileUrl,
    this.portfolioFileName,
    this.isComplete = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'desiredRoles': desiredRoles,
      'desiredIndustries': desiredIndustries,
      'cvUrl': cvUrl,
      'cvFileName': cvFileName,
      'portfolioLinks': portfolioLinks,
      'portfolioFileUrl': portfolioFileUrl,
      'portfolioFileName': portfolioFileName,
      'isComplete': isComplete,
    };
  }

  factory CareerPreference.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const CareerPreference();
    return CareerPreference(
      status: JobSearchStatusX.fromString(map['status']),
      desiredRoles: List<String>.from(map['desiredRoles'] ?? []),
      desiredIndustries: List<String>.from(map['desiredIndustries'] ?? []),
      cvUrl: map['cvUrl'],
      cvFileName: map['cvFileName'],
      portfolioLinks: List<String>.from(map['portfolioLinks'] ?? []),
      portfolioFileUrl: map['portfolioFileUrl'],
      portfolioFileName: map['portfolioFileName'],
      isComplete: map['isComplete'] ?? false,
    );
  }

  CareerPreference copyWith({
    JobSearchStatus? status,
    List<String>? desiredRoles,
    List<String>? desiredIndustries,
    String? cvUrl,
    String? cvFileName,
    List<String>? portfolioLinks,
    String? portfolioFileUrl,
    String? portfolioFileName,
    bool? isComplete,
  }) {
    return CareerPreference(
      status: status ?? this.status,
      desiredRoles: desiredRoles ?? this.desiredRoles,
      desiredIndustries: desiredIndustries ?? this.desiredIndustries,
      cvUrl: cvUrl ?? this.cvUrl,
      cvFileName: cvFileName ?? this.cvFileName,
      portfolioLinks: portfolioLinks ?? this.portfolioLinks,
      portfolioFileUrl: portfolioFileUrl ?? this.portfolioFileUrl,
      portfolioFileName: portfolioFileName ?? this.portfolioFileName,
      isComplete: isComplete ?? this.isComplete,
    );
  }
}
