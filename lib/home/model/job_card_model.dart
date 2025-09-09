class JobCardModel {
  final String companyLogo;
  final String title;
  final String company;
  final String workType; // Hybrid / On Site / Remote
  final String employmentType; // Full Time / Part Time
  final String salary;

  JobCardModel({
    required this.companyLogo,
    required this.title,
    required this.company,
    required this.workType,
    required this.employmentType,
    required this.salary,
  });
}