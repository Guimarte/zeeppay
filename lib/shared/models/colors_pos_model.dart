class ColorsPosModel {
  final String background;
  final String foreground;
  final String card;
  final String cardForeground;
  final String popover;
  final String popoverForeground;
  final String primary;
  final String primaryForeground;
  final String secondary;
  final String secondaryForeground;
  final String muted;
  final String mutedForeground;
  final String accent;
  final String accentForeground;
  final String destructive;
  final String destructiveForeground;
  final String border;
  final String input;
  final String ring;

  ColorsPosModel({
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
  });

  factory ColorsPosModel.fromJson(Map<String, dynamic> json) {
    return ColorsPosModel(
      background: json['background'] as String,
      foreground: json['foreground'] as String,
      card: json['card'] as String,
      cardForeground: json['cardForeground'] as String,
      popover: json['popover'] as String,
      popoverForeground: json['popoverForeground'] as String,
      primary: json['primary'] as String,
      primaryForeground: json['primaryForeground'] as String,
      secondary: json['secondary'] as String,
      secondaryForeground: json['secondaryForeground'] as String,
      muted: json['muted'] as String,
      mutedForeground: json['mutedForeground'] as String,
      accent: json['accent'] as String,
      accentForeground: json['accentForeground'] as String,
      destructive: json['destructive'] as String,
      destructiveForeground: json['destructiveForeground'] as String,
      border: json['border'] as String,
      input: json['input'] as String,
      ring: json['ring'] as String,
    );
  }
}
