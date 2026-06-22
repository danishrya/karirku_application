import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_assets.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/models/job_model.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/widgets/custom_button.dart';
import 'package:karirku_application/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _minSalaryController = TextEditingController();
  final _maxSalaryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _logoController = TextEditingController();
  
  String _selectedCategory = JobProvider.categories[1]; // Design
  String _selectedWorkType = JobProvider.workTypes[0]; // Full Time
  String _selectedEmploymentType = JobProvider.employmentTypes[0]; // Remote
  
  final List<TextEditingController> _requirementControllers = [TextEditingController()];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _logoController.dispose();
    _locationController.dispose();
    _minSalaryController.dispose();
    _maxSalaryController.dispose();
    _descriptionController.dispose();
    for (var controller in _requirementControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addRequirement() {
    setState(() {
      _requirementControllers.add(TextEditingController());
    });
  }

  void _removeRequirement(int index) {
    if (_requirementControllers.length > 1) {
      setState(() {
        _requirementControllers[index].dispose();
        _requirementControllers.removeAt(index);
      });
    }
  }

  Future<void> _submitJob() async {
    if (_formKey.currentState!.validate()) {
      final requirements = _requirementControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      if (requirements.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tambahkan minimal 1 persyaratan.')),
        );
        return;
      }

      setState(() => _isSubmitting = true);

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;
      final companyName = user?.companyName ?? user?.name ?? 'Perusahaan';

      final newJob = JobModel(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        company: companyName,
        companyLogo: _logoController.text.trim().isNotEmpty ? _logoController.text.trim() : AppAssets.logo,
        workType: _selectedWorkType,
        employmentType: _selectedEmploymentType,
        salary: 'Rp ${_minSalaryController.text} - Rp ${_maxSalaryController.text}',
        location: _locationController.text.trim(),
        description: _descriptionController.text.trim(),
        requirements: requirements,
        category: _selectedCategory,
        postedAt: DateTime.now(),
        postedBy: user?.uid ?? '',
      );

      await Provider.of<JobProvider>(context, listen: false).addJob(newJob);

      if (!mounted) return;

      setState(() => _isSubmitting = false);

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Berhasil!'),
          content: const Text('Lowongan kerja berhasil diposting.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _resetForm();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _logoController.clear();
    _locationController.clear();
    _minSalaryController.clear();
    _maxSalaryController.clear();
    _descriptionController.clear();
    for (var controller in _requirementControllers) {
      controller.dispose();
    }
    setState(() {
      _requirementControllers.clear();
      _requirementControllers.add(TextEditingController());
      _selectedCategory = JobProvider.categories[1];
      _selectedWorkType = JobProvider.workTypes[0];
      _selectedEmploymentType = JobProvider.employmentTypes[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Buat Lowongan'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Informasi Dasar', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Judul Pekerjaan',
                hintText: 'Misal: Senior UI/UX Designer',
                controller: _titleController,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'URL Logo Perusahaan (Opsional)',
                hintText: 'Misal: https://example.com/logo.png',
                controller: _logoController,
              ),
              const SizedBox(height: 16),
              
              const Text('Kategori', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCategory,
                    isExpanded: true,
                    items: JobProvider.categories
                        .where((c) => c != 'All')
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedCategory = value);
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              Text('Tipe Pekerjaan', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: JobProvider.workTypes.map((type) {
                  final isSelected = _selectedWorkType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedWorkType = type);
                    },
                    selectedColor: AppColors.accentDark.withOpacity(0.2),
                    labelStyle: TextStyle(color: isSelected ? AppColors.accentDark : AppColors.textPrimary),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: JobProvider.employmentTypes.map((type) {
                  final isSelected = _selectedEmploymentType == type;
                  return ChoiceChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedEmploymentType = type);
                    },
                    selectedColor: AppColors.accentDark.withOpacity(0.2),
                    labelStyle: TextStyle(color: isSelected ? AppColors.accentDark : AppColors.textPrimary),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              Text('Lokasi & Gaji', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Lokasi Pekerjaan',
                hintText: 'Misal: Jakarta, Indonesia',
                controller: _locationController,
                prefixIcon: Icons.location_on_outlined,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'Gaji Minimum (Rp)',
                      hintText: 'Misal: 5.000.000',
                      controller: _minSalaryController,
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Wajib' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      label: 'Gaji Maksimum (Rp)',
                      hintText: 'Misal: 10.000.000',
                      controller: _maxSalaryController,
                      keyboardType: TextInputType.number,
                      validator: (value) => value!.isEmpty ? 'Wajib' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              Text('Detail Pekerjaan', style: AppTextStyles.heading3),
              const SizedBox(height: 16),
              
              CustomTextField(
                label: 'Deskripsi Pekerjaan',
                hintText: 'Jelaskan tanggung jawab dan ruang lingkup pekerjaan...',
                controller: _descriptionController,
                maxLines: 5,
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Persyaratan', style: AppTextStyles.heading3),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.accentDark),
                    onPressed: _addRequirement,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _requirementControllers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            hintText: 'Masukkan persyaratan ke-${index + 1}',
                            controller: _requirementControllers[index],
                          ),
                        ),
                        if (_requirementControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: AppColors.error),
                            onPressed: () => _removeRequirement(index),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),

              CustomButton(
                text: _isSubmitting ? 'Memposting...' : 'Posting Lowongan',
                onPressed: _isSubmitting ? null : _submitJob,
              ),
              const SizedBox(height: 48), // Padding for bottom nav
            ],
          ),
        ),
      ),
    );
  }
}
