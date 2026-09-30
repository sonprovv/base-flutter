import 'package:equatable/equatable.dart';

/// status: -1 = failed, 0 = processing, 1 = completed
class ProfileWork extends Equatable {

  const ProfileWork({
    required this.id,
    required this.name,
    required this.type,
    this.status = 0,
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
      status: json['status'] as int? ?? 1,
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
  final int status;
  final String coverUrl;
  final String mediaUrl;
  final String previewWebpUrl;
  final String previewGifUrl;
  final String createdAt;

  bool get isCompleted => status == 1;
  bool get isProcessing => status == 0;
  bool get isFailed => status == -1;
  bool get isVideo => type == 'video' || mediaUrl.endsWith('.mp4');

  ProfileWork copyWith({
    int? status,
    String? coverUrl,
    String? mediaUrl,
  }) => ProfileWork(
        id: id,
        name: name,
        type: type,
        status: status ?? this.status,
        coverUrl: coverUrl ?? this.coverUrl,
        mediaUrl: mediaUrl ?? this.mediaUrl,
        previewWebpUrl: previewWebpUrl,
        previewGifUrl: previewGifUrl,
        createdAt: createdAt,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'status': status,
        'cover_url': coverUrl,
        'media_url': mediaUrl,
        'preview_webp_url': previewWebpUrl,
        'preview_gif_url': previewGifUrl,
        'created_at': createdAt,
      };

  @override
  List<Object?> get props => [id];
}
