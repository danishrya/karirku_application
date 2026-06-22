import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:karirku_application/core/constants/app_assets.dart';
import 'package:karirku_application/models/job_model.dart';

/// Seeds initial job data into Firestore if the collection is empty.
class SeedData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Check if the jobs collection is empty, if so, upload sample jobs.
  static Future<void> seedInitialJobs() async {
    final snapshot = await _firestore.collection('jobs').limit(1).get();
    if (snapshot.docs.isNotEmpty) return; // Already has data

    final batch = _firestore.batch();

    for (final job in _sampleJobs) {
      final docRef = _firestore.collection('jobs').doc();
      batch.set(docRef, job.toMap());
    }

    await batch.commit();
  }

  static final List<JobModel> _sampleJobs = [
    JobModel(
      id: '',
      title: 'Merchandise Designer',
      company: 'MLB',
      companyLogo: AppAssets.mlbLogo,
      workType: 'Full Time',
      employmentType: 'Onsite',
      salary: 'Rp 8.000.000 - Rp 12.000.000',
      location: 'Jakarta, Indonesia',
      description:
          'Kami mencari Merchandise Designer yang kreatif dan berpengalaman untuk bergabung dengan tim kami. '
          'Anda akan bertanggung jawab dalam mendesain merchandise resmi perusahaan termasuk apparel, aksesori, '
          'dan produk kolaborasi.\n\n'
          'Tanggung jawab utama:\n'
          '• Membuat desain merchandise dari konsep hingga produksi\n'
          '• Berkolaborasi dengan tim marketing untuk campaign seasonal\n'
          '• Riset tren desain terkini dan preferensi pasar\n'
          '• Menyiapkan file produksi siap cetak',
      requirements: [
        'Pengalaman minimal 2 tahun di bidang graphic design',
        'Mahir menggunakan Adobe Illustrator & Photoshop',
        'Memiliki portfolio desain merchandise',
        'Kreatif dan mampu bekerja dalam deadline ketat',
        'Mengerti proses produksi garment menjadi nilai tambah',
      ],
      category: 'Design',
      postedAt: DateTime.now().subtract(const Duration(days: 2)),
      postedBy: 'seed',
    ),
    JobModel(
      id: '',
      title: 'Company Website Designer',
      company: 'NBA',
      companyLogo: AppAssets.nbaLogo,
      workType: 'Part Time',
      employmentType: 'Remote',
      salary: 'Rp 6.000.000 - Rp 9.000.000',
      location: 'Remote, Indonesia',
      description:
          'NBA Indonesia membuka lowongan untuk Website Designer yang akan bertanggung jawab memperbarui dan '
          'mendesain ulang website perusahaan dengan tampilan yang modern dan responsif.\n\n'
          'Anda akan bekerja secara remote dan berkolaborasi dengan developer team.',
      requirements: [
        'Pengalaman dalam UI/UX design minimal 1 tahun',
        'Menguasai Figma dan tools prototyping',
        'Paham prinsip responsive web design',
        'Mampu berkomunikasi dengan baik secara remote',
      ],
      category: 'Design',
      postedAt: DateTime.now().subtract(const Duration(days: 5)),
      postedBy: 'seed',
    ),
    JobModel(
      id: '',
      title: 'UI/UX Designer',
      company: 'GoTo',
      companyLogo: AppAssets.logo,
      workType: 'Full Time',
      employmentType: 'Hybrid',
      salary: 'Rp 10.000.000 - Rp 15.000.000',
      location: 'Bandung, Indonesia',
      description:
          'Bergabunglah dengan tim product design kami sebagai UI/UX Designer. '
          'Anda akan merancang pengalaman pengguna yang intuitif untuk produk digital kami.',
      requirements: [
        'Minimal 3 tahun pengalaman di UI/UX Design',
        'Portfolio yang kuat di mobile app design',
        'Menguasai Figma, Sketch, atau Adobe XD',
        'Memahami design system dan component library',
        'Pengalaman melakukan user research & usability testing',
      ],
      category: 'Design',
      postedAt: DateTime.now().subtract(const Duration(days: 1)),
      postedBy: 'seed',
    ),
    JobModel(
      id: '',
      title: 'Flutter Mobile Developer',
      company: 'Tokopedia',
      companyLogo: AppAssets.logo,
      workType: 'Full Time',
      employmentType: 'Onsite',
      salary: 'Rp 12.000.000 - Rp 18.000.000',
      location: 'Jakarta, Indonesia',
      description:
          'Kami mencari Flutter Developer berpengalaman untuk mengembangkan aplikasi mobile kami. '
          'Anda akan bekerja dengan tim agile untuk membangun fitur baru.',
      requirements: [
        'Minimal 2 tahun pengalaman dengan Flutter & Dart',
        'Memahami state management (Provider, BLoC, Riverpod)',
        'Pengalaman dengan REST API dan Firebase',
        'Familiar dengan Git workflow',
        'Memahami clean architecture pattern',
      ],
      category: 'Engineering',
      postedAt: DateTime.now().subtract(const Duration(hours: 12)),
      postedBy: 'seed',
    ),
    JobModel(
      id: '',
      title: 'Digital Marketing Specialist',
      company: 'Shopee',
      companyLogo: AppAssets.logo,
      workType: 'Full Time',
      employmentType: 'Hybrid',
      salary: 'Rp 7.000.000 - Rp 11.000.000',
      location: 'Surabaya, Indonesia',
      description:
          'Shopee Indonesia membuka lowongan untuk Digital Marketing Specialist yang kreatif. '
          'Anda akan mengelola campaign digital di berbagai platform.',
      requirements: [
        'Pengalaman minimal 2 tahun di digital marketing',
        'Menguasai Google Ads, Meta Ads, dan TikTok Ads',
        'Paham analytics dan data-driven marketing',
        'Kemampuan copywriting yang baik',
      ],
      category: 'Marketing',
      postedAt: DateTime.now().subtract(const Duration(days: 3)),
      postedBy: 'seed',
    ),
    JobModel(
      id: '',
      title: 'Financial Analyst',
      company: 'Bank BCA',
      companyLogo: AppAssets.logo,
      workType: 'Full Time',
      employmentType: 'Onsite',
      salary: 'Rp 9.000.000 - Rp 14.000.000',
      location: 'Jakarta, Indonesia',
      description:
          'Bank BCA mencari Financial Analyst untuk bergabung dalam tim corporate finance. '
          'Anda akan bertanggung jawab untuk analisis keuangan dan pelaporan.',
      requirements: [
        'S1 Akuntansi/Keuangan/Manajemen',
        'Pengalaman minimal 1 tahun di bidang keuangan',
        'Mahir Microsoft Excel dan tools analisis data',
        'Memiliki sertifikasi CFA/CPA menjadi nilai tambah',
      ],
      category: 'Finance',
      postedAt: DateTime.now().subtract(const Duration(days: 4)),
      postedBy: 'seed',
    ),
  ];
}
