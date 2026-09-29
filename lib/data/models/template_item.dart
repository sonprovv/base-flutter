import 'package:equatable/equatable.dart';

class TemplateItem extends Equatable {

  const TemplateItem({
    required this.id,
    required this.name,
    this.coverUrl = '',
    this.type = 'photo',
    this.originCoverUrl = '',
    this.points = 3,
    this.composition = 'baby_only',
    this.previewWebpUrl = '',
    this.previewGifUrl = '',
    this.previewMp4Url = '',
    this.mp4Url = '',
    this.category = '',
  });

  factory TemplateItem.fromJson(Map<String, dynamic> json) {
    return TemplateItem(
      id: (json['id'] ?? json['template_id'] ?? 0).toString(),
      name: json['name'] as String? ?? '',
      coverUrl: json['cover_url'] as String? ?? '',
      type: json['template_type'] as String? ?? json['type'] as String? ?? 'photo',
      originCoverUrl: json['origin_cover_url'] as String? ?? '',
      points: json['points'] as int? ?? 3,
      composition: json['composition'] as String? ?? 'baby_only',
      previewWebpUrl: json['preview_webp_url'] as String? ?? '',
      previewGifUrl: json['preview_gif_url'] as String? ?? '',
      previewMp4Url: json['preview_mp4_url'] as String? ?? '',
      mp4Url: json['mp4_url'] as String? ?? '',
      category: json['category'] as String? ?? '',
    );
  }
  final String id;
  final String name;
  final String coverUrl;
  final String type;
  final String originCoverUrl;
  final int points;
  final String composition;
  final String previewWebpUrl;
  final String previewGifUrl;
  final String previewMp4Url;
  final String mp4Url;
  final String category;

  bool get isVideo =>
      type == 'video' || mp4Url.isNotEmpty || previewMp4Url.isNotEmpty;

  String get displayMediaUrl {
    if (previewWebpUrl.isNotEmpty) return previewWebpUrl;
    if (previewGifUrl.isNotEmpty) return previewGifUrl;
    if (coverUrl.isNotEmpty) return coverUrl;
    return originCoverUrl;
  }

  @override
  List<Object?> get props => [id];
}

class CategoryItem extends Equatable {

  const CategoryItem({
    required this.name,
    this.isGrid = false,
    this.templates = const [],
  });

  factory CategoryItem.fromJson(Map<String, dynamic> json, {bool isGrid = false}) {
    final rawTemplates = json['templates'] as List<dynamic>? ?? [];
    return CategoryItem(
      name: json['name'] as String? ?? '',
      isGrid: isGrid,
      templates: rawTemplates.map((t) => TemplateItem.fromJson(t as Map<String, dynamic>)).toList(),
    );
  }
  final String name;
  final bool isGrid;
  final List<TemplateItem> templates;

  @override
  List<Object?> get props => [name];
}
