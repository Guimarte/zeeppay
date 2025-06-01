class NetworkPos {
  final String endpoint;
  final String? clientId;

  NetworkPos({required this.endpoint, this.clientId});

  factory NetworkPos.fromJson(Map<String, dynamic> json) {
    return NetworkPos(
      endpoint: json['endpoint'] as String,
      clientId: json['clientId'] as String?,
    );
  }
}
