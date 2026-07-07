/// How actively a job seeker is currently looking for work.
enum JobSearchStatus { activelyLooking, openToWork, notOpen }

extension JobSearchStatusX on JobSearchStatus {
  String get label {
    switch (this) {
      case JobSearchStatus.activelyLooking:
        return 'Ya, secara aktif mencari';
      case JobSearchStatus.openToWork:
        return 'Saya Terbuka untuk Kerja';
      case JobSearchStatus.notOpen:
        return 'Tidak terbuka';
    }
  }

  String get description {
    switch (this) {
      case JobSearchStatus.activelyLooking:
        return 'Menerima undangan pekerjaan eksklusif dan dihubungi oleh perusahaan';
      case JobSearchStatus.openToWork:
        return 'Pilih ini untuk sesekali menerima undangan pekerjaan';
      case JobSearchStatus.notOpen:
        return 'Anda tidak akan menerima undangan pekerjaan untuk saat ini';
    }
  }

  static JobSearchStatus fromString(String? value) {
    return JobSearchStatus.values.firstWhere(
      (e) => e.name == value,
      orElse: () => JobSearchStatus.openToWork,
    );
  }
}
