import 'package:flutter/material.dart';

class JobFilter {
  final Set<String> employmentTypes;
  final Set<String> workTypes;
  final RangeValues salaryRange;

  const JobFilter({
    this.employmentTypes = const <String>{},
    this.workTypes = const <String>{},
    this.salaryRange = const RangeValues(0, 50),
  });

  bool get isActive =>
      employmentTypes.isNotEmpty ||
      workTypes.isNotEmpty ||
      salaryRange.start != 0 ||
      salaryRange.end != 50;

  int get activeCount =>
      employmentTypes.length +
      workTypes.length +
      ((salaryRange.start != 0 || salaryRange.end != 50) ? 1 : 0);

  bool matches({
    required String employmentType,
    required String workType,
  }) {
    final matchEmployment =
        employmentTypes.isEmpty || employmentTypes.contains(employmentType);
    final matchWork = workTypes.isEmpty || workTypes.contains(workType);
    return matchEmployment && matchWork;
  }

  JobFilter copyWith({
    Set<String>? employmentTypes,
    Set<String>? workTypes,
    RangeValues? salaryRange,
  }) {
    return JobFilter(
      employmentTypes: employmentTypes ?? this.employmentTypes,
      workTypes: workTypes ?? this.workTypes,
      salaryRange: salaryRange ?? this.salaryRange,
    );
  }

  static const empty = JobFilter(
    employmentTypes: <String>{},
    workTypes: <String>{},
    salaryRange: RangeValues(0, 50),
  );
}
