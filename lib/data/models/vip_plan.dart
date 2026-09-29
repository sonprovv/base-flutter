import 'package:equatable/equatable.dart';

class VipPlan extends Equatable {

  const VipPlan({
    required this.id,
    required this.name,
    required this.price,
    this.subtitle = '',
    this.note = '',
    this.isTrial = false,
    this.isSelected = false,
  });

  factory VipPlan.fromJson(Map<String, dynamic> json) {
    return VipPlan(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      price: json['price'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      note: json['note'] as String? ?? '',
      isTrial: json['is_trial'] as bool? ?? false,
      isSelected: json['is_selected'] as bool? ?? false,
    );
  }
  final String id;
  final String name;
  final String price;
  final String subtitle;
  final String note;
  final bool isTrial;
  final bool isSelected;

  VipPlan copyWith({bool? isSelected}) => VipPlan(
        id: id,
        name: name,
        price: price,
        subtitle: subtitle,
        note: note,
        isTrial: isTrial,
        isSelected: isSelected ?? this.isSelected,
      );

  @override
  List<Object?> get props => [id];
}
