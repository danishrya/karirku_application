import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:karirku_application/core/constants/app_colors.dart';
import 'package:karirku_application/core/constants/app_text_styles.dart';
import 'package:karirku_application/core/enums/job_search_status.dart';
import 'package:karirku_application/core/enums/user_role.dart';
import 'package:karirku_application/models/career_preference.dart';
import 'package:karirku_application/providers/auth_provider.dart';
import 'package:karirku_application/providers/job_provider.dart';
import 'package:karirku_application/screens/employer/employer_main_screen.dart';
import 'package:karirku_application/screens/job_seeker/seeker_main_screen.dart';
import 'package:provider/provider.dart';

/// 4-step "Preferensi Karir" onboarding wizard shown right after a job
/// seeker completes registration & email verification:
///   1. Current job-search status
///   2. Desired roles
///   3. Desired industries / company types
///   4. Documents (CV + portfolio)
class CareerPreferenceScreen extends StatefulWidget {
  const CareerPreferenceScreen({super.key});

  @override
  State<CareerPreferenceScreen> createState() => _CareerPreferenceScreenState();
}

class _CareerPreferenceScreenState extends State<CareerPreferenceScreen> {
  final PageController _pageController = PageController();
  int _step = 0;
  static const int _totalSteps = 4;

  // Step 1
  JobSearchStatus _status = JobSearchStatus.openToWork;

  // Step 2
  final _roleSearchController = TextEditingController();
  final Set<String> _selectedRoles = {};
  static const _suggestedRoles = [
    'UI/UX Designer',
    'UX Designer',
    'Product Designer',
    'Voice Actor',
    'Translator',
    'Copywriter',
    'Associate Product Manager',
    'Graphic Designer',
    'Content Writer',
    'Data Analyst',
    'Software Engineer',
    'Marketing Specialist',
  ];

  // Step 3
  final _industrySearchController = TextEditingController();
  final Set<String> _selectedIndustries = {};
  static const _suggestedIndustries = [
    'Consulting',
    'FinTech',
    'Software Developer',
    'Creative Agent',
    '3D Design',
    'Arts',
    'E-Commerce',
    'Education',
    'Healthcare',
    'Retail',
  ];

  // Step 4
  File? _cvFile;
  String? _cvFileName;
  bool _uploadingCv = false;
  File? _portfolioFile;
  String? _portfolioFileName;
  bool _uploadingPortfolio = false;
  final List<TextEditingController> _portfolioLinkControllers = [
    TextEditingController(),
  ];
  bool _saving = false;

  @override
  void dispose() {
    _pageController.dispose();
    _roleSearchController.dispose();
    _industrySearchController.dispose();
    for (final c in _portfolioLinkControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _goNext() {
    if (_step == _totalSteps - 1) {
      _handleFinish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _goBack() {
    if (_step == 0) {
      Navigator.pop(context);
      return;
    }
    _pageController.previousPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _pickDocument({required bool isCv}) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result == null || result.files.single.path == null) return;

    setState(() {
      if (isCv) {
        _cvFile = File(result.files.single.path!);
        _cvFileName = result.files.single.name;
      } else {
        _portfolioFile = File(result.files.single.path!);
        _portfolioFileName = result.files.single.name;
      }
    });
  }

  Future<void> _handleFinish() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() => _saving = true);

    String? cvUrl;
    String? portfolioFileUrl;

    try {
      if (_cvFile != null) {
        setState(() => _uploadingCv = true);
        cvUrl = await authProvider.uploadDocument(
          file: _cvFile!,
          folder: 'cv',
          fileName: _cvFileName ?? 'cv.pdf',
        );
        setState(() => _uploadingCv = false);
      }

      if (_portfolioFile != null) {
        setState(() => _uploadingPortfolio = true);
        portfolioFileUrl = await authProvider.uploadDocument(
          file: _portfolioFile!,
          folder: 'portfolio',
          fileName: _portfolioFileName ?? 'portfolio.pdf',
        );
        setState(() => _uploadingPortfolio = false);
      }

      final links = _portfolioLinkControllers
          .map((c) => c.text.trim())
          .where((v) => v.isNotEmpty)
          .toList();

      final preference = CareerPreference(
        status: _status,
        desiredRoles: _selectedRoles.toList(),
        desiredIndustries: _selectedIndustries.toList(),
        cvUrl: cvUrl,
        cvFileName: _cvFileName,
        portfolioLinks: links,
        portfolioFileUrl: portfolioFileUrl,
        portfolioFileName: _portfolioFileName,
        isComplete: true,
      );

      final saved = await authProvider.saveCareerPreference(preference);

      if (!mounted) return;
      setState(() => _saving = false);

      if (!saved) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(authProvider.errorMessage ?? 'Gagal menyimpan preferensi'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final jobProvider = Provider.of<JobProvider>(context, listen: false);
      final uid = authProvider.currentUser?.uid;
      if (uid != null) await jobProvider.loadSavedJobs(uid);
      if (!mounted) return;

      final role = authProvider.currentUser?.role;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => role == UserRole.employer
              ? const EmployerMainScreen()
              : const SeekerMainScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _uploadingCv = false;
        _uploadingPortfolio = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Terjadi kesalahan: $e'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _step == 3 ? 'Keperluan Dokumen' : 'Preferensi Karir',
                    style: AppTextStyles.heading2,
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: (_step + 1) / _totalSteps,
                      minHeight: 6,
                      backgroundColor: AppColors.border,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  _buildStatusStep(),
                  _buildRolesStep(),
                  _buildIndustriesStep(),
                  _buildDocumentsStep(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed:
                          (_saving || _uploadingCv || _uploadingPortfolio)
                              ? null
                              : _goBack,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('Back',
                          style: AppTextStyles.buttonMedium
                              .copyWith(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed:
                          (_saving || _uploadingCv || _uploadingPortfolio)
                              ? null
                              : _goNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: (_saving || _uploadingCv || _uploadingPortfolio)
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              _step == _totalSteps - 1 ? 'Finish' : 'Next',
                              style: AppTextStyles.buttonMedium,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Step 1: Status ─────────────────────────────────────────────

  Widget _buildStatusStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Apakah Anda saat ini sedang mencari peluang baru?',
            style: AppTextStyles.heading4,
          ),
          const SizedBox(height: 20),
          _StatusCard(
            icon: Icons.search_rounded,
            title: JobSearchStatus.activelyLooking.label,
            description: JobSearchStatus.activelyLooking.description,
            selected: _status == JobSearchStatus.activelyLooking,
            onTap: () =>
                setState(() => _status = JobSearchStatus.activelyLooking),
          ),
          const SizedBox(height: 14),
          _StatusCard(
            icon: Icons.work_outline_rounded,
            title: JobSearchStatus.openToWork.label,
            description: JobSearchStatus.openToWork.description,
            selected: _status == JobSearchStatus.openToWork,
            onTap: () => setState(() => _status = JobSearchStatus.openToWork),
          ),
          const SizedBox(height: 14),
          _StatusCard(
            icon: Icons.cancel_outlined,
            title: JobSearchStatus.notOpen.label,
            description: JobSearchStatus.notOpen.description,
            selected: _status == JobSearchStatus.notOpen,
            onTap: () => setState(() => _status = JobSearchStatus.notOpen),
          ),
        ],
      ),
    );
  }

  // ─── Step 2: Desired roles ──────────────────────────────────────

  Widget _buildRolesStep() {
    return _buildChipSelectStep(
      question: 'Peran seperti apa yang kami buka untuk kerja?',
      searchController: _roleSearchController,
      allSuggestions: _suggestedRoles,
      selected: _selectedRoles,
    );
  }

  // ─── Step 3: Desired industries ─────────────────────────────────

  Widget _buildIndustriesStep() {
    return _buildChipSelectStep(
      question: 'Perusahaan seperti apa yang kamu ingin untuk bekerja?',
      searchController: _industrySearchController,
      allSuggestions: _suggestedIndustries,
      selected: _selectedIndustries,
    );
  }

  Widget _buildChipSelectStep({
    required String question,
    required TextEditingController searchController,
    required List<String> allSuggestions,
    required Set<String> selected,
  }) {
    final query = searchController.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? allSuggestions
        : allSuggestions.where((s) => s.toLowerCase().contains(query)).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: AppTextStyles.heading4),
          const SizedBox(height: 20),
          TextField(
            controller: searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Cari...',
              prefixIcon:
                  const Icon(Icons.search_rounded, color: AppColors.textHint),
              suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () => setState(() => searchController.clear()),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 24),
          Text('Saran Untuk Anda', style: AppTextStyles.labelLarge),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: filtered.map((item) {
              final isSelected = selected.contains(item);
              return GestureDetector(
                onTap: () => setState(() {
                  if (isSelected) {
                    selected.remove(item);
                  } else {
                    selected.add(item);
                  }
                }),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? Icons.check_rounded : Icons.add_rounded,
                        size: 16,
                        color: isSelected ? Colors.white : AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          if (selected.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Dipilih (${selected.length})',
                style: AppTextStyles.labelLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: selected.map((item) {
                return Chip(
                  label: Text(item, style: AppTextStyles.caption),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                  deleteIcon: const Icon(Icons.close_rounded, size: 14),
                  onDeleted: () => setState(() => selected.remove(item)),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  // ─── Step 4: Documents ──────────────────────────────────────────

  Widget _buildDocumentsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lampirkan CV anda dan dapatkan lowongan pekerjaan yang sempurna, tapi tenang mengganggu sekarang akan memungkinkan Anda mendapatkan tawaran pekerjaan eksklusif. Selain itu, Anda bisa mengunggah ulang lagi kapan saja!',
            style: AppTextStyles.bodySmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          Text('CV', style: AppTextStyles.labelLarge),
          const SizedBox(height: 10),
          _DocumentAttachTile(
            label: _cvFileName ?? 'Lampirkan CV mu dalam PDF',
            attached: _cvFile != null,
            onTap: () => _pickDocument(isCv: true),
          ),
          const SizedBox(height: 28),
          Text('Portfolio (Opsional)', style: AppTextStyles.labelLarge),
          const SizedBox(height: 10),
          ..._portfolioLinkControllers.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: entry.value,
                decoration: const InputDecoration(
                  hintText: 'https://',
                  prefixIcon: Icon(Icons.link_rounded),
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: () => setState(
              () => _portfolioLinkControllers.add(TextEditingController()),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  'Tambahkan Tautan Lain',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: AppColors.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _DocumentAttachTile(
            label: _portfolioFileName ?? 'File PDF (opsional)',
            attached: _portfolioFile != null,
            onTap: () => _pickDocument(isCv: false),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  const _StatusCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.08)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DocumentAttachTile extends StatelessWidget {
  final String label;
  final bool attached;
  final VoidCallback onTap;

  const _DocumentAttachTile({
    required this.label,
    required this.attached,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: attached
              ? AppColors.primary.withValues(alpha: 0.06)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: attached ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              attached ? Icons.check_circle_rounded : Icons.upload_file_rounded,
              color: attached ? AppColors.primary : AppColors.textHint,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: attached
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              attached ? 'Ganti' : 'Pilih File',
              style:
                  AppTextStyles.labelSmall.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
