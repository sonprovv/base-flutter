// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppL10nId extends AppL10n {
  AppL10nId([String locale = 'id']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => 'Ciptakan momen ajaib untuk bayi Anda';

  @override
  String get splashAdDisclaimer => 'Tindakan ini mungkin mengandung iklan';

  @override
  String get chooseLanguage => 'Pilih Bahasa';

  @override
  String get save => 'Simpan';

  @override
  String get onboarding1Title => 'Temukan\nBayi Masa Depan';

  @override
  String get onboarding1Desc =>
      'Lihat seperti apa bayi Anda dengan generasi wajah bertenaga AI';

  @override
  String get onboarding2Title => 'Template\nTari Bayi';

  @override
  String get onboarding2Desc =>
      'Buat video tari lucu bersama bayi Anda menggunakan template trending';

  @override
  String get onboarding3Title => 'Kemiripan\nKeluarga';

  @override
  String get onboarding3Desc =>
      'Temukan siapa yang paling mirip dengan bayi Anda';

  @override
  String get next => 'Lanjut';

  @override
  String get getStarted => 'Mulai';

  @override
  String get termsAgreement =>
      'Dengan melanjutkan, Anda setuju dengan Syarat & Kebijakan Privasi kami';

  @override
  String get navHome => 'Beranda';

  @override
  String get navVideo => 'Video';

  @override
  String get navPhoto => 'Foto';

  @override
  String get navProfile => 'Profil';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get comingSoon => 'Segera hadir!';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get error => 'Error';

  @override
  String get homeLoadError => 'Gagal memuat beranda';

  @override
  String get profileTitle => 'Profil';

  @override
  String get profileUser => 'Pengguna BabyGenie';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString kreasi';
  }

  @override
  String get filterAll => 'Semua';

  @override
  String get noCreationsYet => 'Belum ada kreasi';

  @override
  String get settingsTitle => 'Pengaturan';

  @override
  String get settingsLanguage => 'Bahasa';

  @override
  String get settingsPrivacyPolicy => 'Kebijakan Privasi';

  @override
  String get settingsRateApp => 'Nilai Aplikasi';

  @override
  String get settingsShareApp => 'Bagikan Aplikasi';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => 'Foto Ibu';

  @override
  String get dadsPhoto => 'Foto Ayah';

  @override
  String get babysPhoto => 'Foto Bayi';

  @override
  String get boyOrGirl => 'Laki-laki atau Perempuan';

  @override
  String get uploadPhotoHint =>
      'Upload foto wajah yang jelas untuk hasil terbaik';

  @override
  String get generateBabyPhoto => 'Buat Foto Bayi';

  @override
  String get uploadPhoto => 'Upload Foto';

  @override
  String get tapToSelectImage => 'Ketuk untuk memilih gambar';

  @override
  String get babyGirl => 'Bayi Perempuan';

  @override
  String get babyBoy => 'Bayi Laki-laki';

  @override
  String get teenGirl => 'Remaja Perempuan';

  @override
  String get teenBoy => 'Remaja Laki-laki';

  @override
  String get noTemplatesFound => 'Tidak ada template ditemukan';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => 'Buka semua fitur premium';

  @override
  String get paywallTrial => 'COBA';

  @override
  String get paywallContinue => 'Lanjutkan';

  @override
  String get paywallCancelNote => 'Batalkan kapan saja · Pulihkan pembelian';

  @override
  String get uninstallSorry =>
      'Kami sangat menyesal jika belum memenuhi harapan Anda.';

  @override
  String get uninstallImprove =>
      'Mohon beritahu kami cara untuk meningkatkan layanan.';

  @override
  String get uninstallNotUseful =>
      'Tidak jauh lebih berguna dari fitur default';

  @override
  String get uninstallLaggy => 'Lambat atau tidak responsif';

  @override
  String get explore => 'Jelajahi';

  @override
  String get dontUninstall => 'Jangan hapus dulu';

  @override
  String get stillUninstall => 'Tetap ingin menghapus';

  @override
  String get whyUninstall => 'Mengapa Anda menghapus aplikasi ini?';

  @override
  String get uninstall => 'Hapus';

  @override
  String get uninstallReasonDifficult => 'Sulit digunakan';

  @override
  String get uninstallReasonAds => 'Terlalu banyak iklan';

  @override
  String get uninstallReasonError => 'Error Tidak Berfungsi';

  @override
  String get uninstallReasonBattery => 'Boros baterai';

  @override
  String get uninstallReasonOthers => 'Lainnya';

  @override
  String get uninstallConfirmTitle => 'Apakah Anda yakin?';

  @override
  String get uninstallConfirmContent => 'Anda ingin menghapus aplikasi ini?';

  @override
  String get skip => 'Lewati';

  @override
  String get bornBaby => 'Bayi yang lahir';

  @override
  String get unbornBaby => 'Bayi yang belum lahir';

  @override
  String get createNow => 'Buat sekarang';

  @override
  String get generatingAiBaby => 'Membuat foto bayi AI...';

  @override
  String get analyzingFacialFeatures =>
      'Menganalisis fitur wajah dan menghasilkan hasil';

  @override
  String get generationComplete => 'Selesai! Disimpan ke kreasi Anda.';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return 'Gagal memuat video: $error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return 'Gagal memuat foto: $error';
  }

  @override
  String get filterVideo => 'Video';

  @override
  String get filterPhoto => 'Foto';

  @override
  String get workFilesAvailable =>
      'File hanya tersedia selama 7 hari — simpan sekarang';

  @override
  String get workGenerationFailed =>
      'Pembuatan gagal. Silakan ganti foto dan coba lagi.';

  @override
  String get workWaiting => 'Perkiraan menunggu 30 menit…';

  @override
  String get creationCompleted => 'Pembuatan selesai';

  @override
  String get taskSubmission => 'Pengiriman tugas';

  @override
  String get completed => 'Selesai';

  @override
  String get generationFailed => 'Pembuatan gagal';

  @override
  String generationOnTheWay(String title) {
    return '$title Anda sedang dalam perjalanan 🍼';
  }

  @override
  String get generationWaitMsg =>
      'Ini mungkin memakan waktu sekitar 1-2 menit.';

  @override
  String get somethingWentWrong => 'Terjadi kesalahan.\nSilakan coba lagi.';

  @override
  String get viewNow => 'Lihat sekarang';

  @override
  String get goBack => 'Kembali';

  @override
  String get buyPoints => '✦ Beli Poin';

  @override
  String get submittingWait => 'Mengirimkan, harap tunggu…';

  @override
  String get myPhoto => 'Foto saya';

  @override
  String get mothersPhoto => 'Foto ibu';

  @override
  String get fathersPhoto => 'Foto ayah';

  @override
  String get detectSimilarity => 'Deteksi kemiripan';

  @override
  String get babyPhotoLabel => 'Foto bayi';

  @override
  String get gender => 'Jenis kelamin';

  @override
  String get skinTone => 'Warna kulit';

  @override
  String get ultrasoundPhoto => 'Foto USG';

  @override
  String get viewYourBaby => 'Lihat bayi Anda';

  @override
  String get familyStyle => 'Gaya keluarga';

  @override
  String get generateFamilyPortrait => 'Buat foto keluarga';

  @override
  String get photoGuidanceGood =>
      'Sertakan bahu, berbagai latar belakang, pakaian, ekspresi, dan sudut kepala.';

  @override
  String get photoGuidanceBad =>
      'Hindari wajah tertutup, kacamata hitam, foto grup, atau riasan tebal.';

  @override
  String get takeSelfie => 'Ambil selfie';

  @override
  String get selectPhoto => 'Pilih foto';
}
