// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppL10nVi extends AppL10n {
  AppL10nVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'BabyGenie';

  @override
  String get splashTagline => 'Tạo những khoảnh khắc kỳ diệu cho bé';

  @override
  String get splashAdDisclaimer => 'Nội dung này có thể chứa quảng cáo';

  @override
  String get chooseLanguage => 'Chọn ngôn ngữ';

  @override
  String get save => 'Lưu';

  @override
  String get onboarding1Title => 'Khám phá\nEm bé Tương lai';

  @override
  String get onboarding1Desc =>
      'Xem em bé của bạn sẽ trông như thế nào với công nghệ AI';

  @override
  String get onboarding2Title => 'Mẫu Video\nNhảy múa';

  @override
  String get onboarding2Desc =>
      'Tạo video nhảy múa đáng yêu với em bé bằng các mẫu thịnh hành';

  @override
  String get onboarding3Title => 'Tương đồng\nGia đình';

  @override
  String get onboarding3Desc =>
      'Khám phá em bé giống ai nhất với công nghệ phát hiện tương đồng';

  @override
  String get next => 'Tiếp theo';

  @override
  String get getStarted => 'Bắt đầu';

  @override
  String get termsAgreement =>
      'Bằng cách tiếp tục, bạn đồng ý với Điều khoản & Chính sách bảo mật';

  @override
  String get navHome => 'Trang chủ';

  @override
  String get navVideo => 'Video';

  @override
  String get navPhoto => 'Ảnh';

  @override
  String get navProfile => 'Hồ sơ';

  @override
  String get retry => 'Thử lại';

  @override
  String get comingSoon => 'Sắp ra mắt!';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get error => 'Lỗi';

  @override
  String get homeLoadError => 'Không thể tải trang chủ';

  @override
  String get profileTitle => 'Hồ sơ';

  @override
  String get profileUser => 'Người dùng BabyGenie';

  @override
  String profileCreations(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString tác phẩm';
  }

  @override
  String get filterAll => 'Tất cả';

  @override
  String get noCreationsYet => 'Chưa có tác phẩm nào';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get settingsLanguage => 'Ngôn ngữ';

  @override
  String get settingsPrivacyPolicy => 'Chính sách bảo mật';

  @override
  String get settingsRateApp => 'Đánh giá ứng dụng';

  @override
  String get settingsShareApp => 'Chia sẻ ứng dụng';

  @override
  String get appVersion => 'BabyGenie v1.0.0';

  @override
  String get momsPhoto => 'Ảnh mẹ';

  @override
  String get dadsPhoto => 'Ảnh bố';

  @override
  String get babysPhoto => 'Ảnh em bé';

  @override
  String get boyOrGirl => 'Bé trai hay bé gái';

  @override
  String get uploadPhotoHint =>
      'Tải ảnh rõ nét, nhìn thẳng để có kết quả tốt nhất';

  @override
  String get generateBabyPhoto => 'Tạo ảnh em bé';

  @override
  String get uploadPhoto => 'Tải ảnh lên';

  @override
  String get tapToSelectImage => 'Nhấn để chọn ảnh';

  @override
  String get babyGirl => 'Bé gái';

  @override
  String get babyBoy => 'Bé trai';

  @override
  String get teenGirl => 'Thiếu nữ';

  @override
  String get teenBoy => 'Thiếu niên';

  @override
  String get noTemplatesFound => 'Không tìm thấy mẫu nào';

  @override
  String get paywallTitle => 'BabyGenie PRO';

  @override
  String get paywallSubtitle => 'Mở khóa tất cả tính năng cao cấp';

  @override
  String get paywallTrial => 'DÙNG THỬ';

  @override
  String get paywallContinue => 'Tiếp tục';

  @override
  String get paywallCancelNote => 'Hủy bất cứ lúc nào · Khôi phục mua hàng';

  @override
  String get uninstallSorry =>
      'Chúng tôi thực sự xin lỗi nếu chưa đáp ứng được kỳ vọng của bạn.';

  @override
  String get uninstallImprove => 'Hãy cho chúng tôi biết để cải thiện.';

  @override
  String get uninstallNotUseful => 'Không hữu ích hơn tính năng mặc định';

  @override
  String get uninstallLaggy => 'Chậm hoặc không phản hồi';

  @override
  String get explore => 'Khám phá';

  @override
  String get dontUninstall => 'Đừng gỡ cài đặt';

  @override
  String get stillUninstall => 'Vẫn muốn gỡ cài đặt';

  @override
  String get whyUninstall => 'Tại sao bạn gỡ cài đặt ứng dụng?';

  @override
  String get uninstall => 'Gỡ cài đặt';

  @override
  String get uninstallReasonDifficult => 'Khó sử dụng';

  @override
  String get uninstallReasonAds => 'Quá nhiều quảng cáo';

  @override
  String get uninstallReasonError => 'Lỗi không hoạt động';

  @override
  String get uninstallReasonBattery => 'Hao pin nhanh';

  @override
  String get uninstallReasonOthers => 'Lý do khác';

  @override
  String get uninstallConfirmTitle => 'Bạn có chắc không?';

  @override
  String get uninstallConfirmContent => 'Bạn muốn gỡ cài đặt ứng dụng này?';

  @override
  String get skip => 'Bỏ qua';

  @override
  String get bornBaby => 'Bé đã sinh';

  @override
  String get unbornBaby => 'Bé chưa sinh';

  @override
  String get createNow => 'Tạo ngay';

  @override
  String get generatingAiBaby => 'Đang tạo ảnh bé AI...';

  @override
  String get analyzingFacialFeatures =>
      'Phân tích đặc điểm khuôn mặt và tạo kết quả';

  @override
  String get generationComplete => 'Hoàn thành! Đã lưu vào tác phẩm của bạn.';

  @override
  String get babyDanceTitle => 'BabyDance';

  @override
  String failedToLoadVideos(String error) {
    return 'Tải video thất bại: $error';
  }

  @override
  String get babyTemplateTitle => 'BabyTemplate';

  @override
  String failedToLoadPhotos(String error) {
    return 'Tải ảnh thất bại: $error';
  }

  @override
  String get filterVideo => 'Video';

  @override
  String get filterPhoto => 'Ảnh';

  @override
  String get workFilesAvailable => 'Tệp chỉ khả dụng trong 7 ngày — lưu ngay';

  @override
  String get workGenerationFailed => 'Tạo thất bại. Hãy thay ảnh và thử lại.';

  @override
  String get workWaiting => 'Dự kiến chờ 30 phút…';

  @override
  String get creationCompleted => 'Hoàn thành tác phẩm';

  @override
  String get taskSubmission => 'Đang xử lý';

  @override
  String get completed => 'Hoàn thành';

  @override
  String get generationFailed => 'Tạo thất bại';

  @override
  String generationOnTheWay(String title) {
    return 'Ảnh $title của bạn đang được tạo 🍼';
  }

  @override
  String get generationWaitMsg => 'Có thể mất khoảng 1–2 phút.';

  @override
  String get somethingWentWrong => 'Đã xảy ra lỗi.\nVui lòng thử lại.';

  @override
  String get viewNow => 'Xem ngay';

  @override
  String get goBack => 'Quay lại';

  @override
  String get buyPoints => '✦ Mua điểm';

  @override
  String get submittingWait => 'Đang gửi, vui lòng chờ…';

  @override
  String get myPhoto => 'Ảnh của tôi';

  @override
  String get mothersPhoto => 'Ảnh mẹ';

  @override
  String get fathersPhoto => 'Ảnh bố';

  @override
  String get detectSimilarity => 'Phát hiện độ giống nhau';

  @override
  String get babyPhotoLabel => 'Ảnh bé';

  @override
  String get gender => 'Giới tính';

  @override
  String get skinTone => 'Tông da';

  @override
  String get ultrasoundPhoto => 'Ảnh siêu âm';

  @override
  String get viewYourBaby => 'Xem bé của bạn';

  @override
  String get familyStyle => 'Kiểu gia đình';

  @override
  String get generateFamilyPortrait => 'Tạo ảnh gia đình';

  @override
  String get photoGuidanceGood =>
      'Nên có vai, nhiều nền khác nhau, quần áo, cảm xúc và góc đầu.';

  @override
  String get photoGuidanceBad =>
      'Tránh che mặt, kính mát, ảnh nhóm hoặc trang điểm đậm che các đặc điểm.';

  @override
  String get takeSelfie => 'Chụp ảnh selfie';

  @override
  String get selectPhoto => 'Chọn ảnh';
}
