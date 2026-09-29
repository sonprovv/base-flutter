import 'package:equatable/equatable.dart';

class ProfileWork extends Equatable {

  const ProfileWork({
    required this.id,
    required this.name,
    required this.type,
    this.coverUrl = '',
    this.mediaUrl = '',
    this.previewWebpUrl = '',
    this.previewGifUrl = '',
    this.createdAt = '',
  });

  factory ProfileWork.fromJson(Map<String, dynamic> json) {
    return ProfileWork(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'photo',
      coverUrl: json['cover_url'] as String? ?? '',
      mediaUrl: json['media_url'] as String? ?? '',
      previewWebpUrl: json['preview_webp_url'] as String? ?? '',
      previewGifUrl: json['preview_gif_url'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
    );
  }
  final int id;
  final String name;
  final String type;
  final String coverUrl;
  final String mediaUrl;
  final String previewWebpUrl;
  final String previewGifUrl;
  final String createdAt;

  bool get isVideo => type == 'video' || mediaUrl.endsWith('.mp4');

  @override
  List<Object?> get props => [id];
}
