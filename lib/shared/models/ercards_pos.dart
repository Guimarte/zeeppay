class ERCardsModel {
  final String endpoint;
  final String? clientId;

  ERCardsModel({required this.endpoint, this.clientId});

  factory ERCardsModel.fromJson(Map<String, dynamic> json) {
    return ERCardsModel(
      endpoint: json['endpoint'] as String,
      clientId: json['clientId'] as String?,
    );
  }
}
