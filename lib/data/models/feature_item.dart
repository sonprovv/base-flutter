import 'package:equatable/equatable.dart';

class FeatureItem extends Equatable {

  const FeatureItem({
    required this.id,
    required this.name,
    this.points = 3,
    this.imagesType = 1,
  });

  factory FeatureItem.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] as int? ?? 1;
    final idStr = switch (rawId) {
      1 => 'future_baby',
      2 => 'family_similarity',
      3 => 'future_family',
      4 => 'ultrasound',
      _ => 'future_baby',
    };
    return FeatureItem(
      id: idStr,
      name: json['name'] as String? ?? '',
      points: json['points'] as int? ?? 3,
      imagesType: json['images_type'] as int? ?? 1,
    );
  }
  final String id;
  final String name;
  final int points;
  final int imagesType;

  @override
  List<Object?> get props => [id];
}
