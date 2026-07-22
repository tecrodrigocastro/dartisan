class Tokenization {
  final String accessToken;
  final String refreshToken;

  const Tokenization({required this.accessToken, required this.refreshToken});

  factory Tokenization.fromJson(Map<String, dynamic> json) => Tokenization(
    accessToken: json['access_token'] as String,
    refreshToken: json['refresh_token'] as String,
  );
}
