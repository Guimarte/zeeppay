import 'package:zeeppay/shared/models/colors_pos_model.dart';

class ThemePosModel {
  final String logo;
  final ColorsPosModel colors;

  ThemePosModel({required this.logo, required this.colors});

  factory ThemePosModel.fromJson(Map<String, dynamic> json) {
    return ThemePosModel(
      logo: json['logo'],
      colors: ColorsPosModel.fromJson(json['colors']),
    );
  }
}
