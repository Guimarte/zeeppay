class CardData {
  final String number;
  final String? holderName;
  final String? expiryDate;

  CardData({
    required this.number,
    this.holderName,
    this.expiryDate,
  });

  factory CardData.fromString(String cardString) {
    // Parse do resultado do cartão que vem do GertecService
    // Assumindo formato similar ao que já existe
    return CardData(
      number: cardString,
    );
  }

  String get maskedNumber {
    if (number.length >= 4) {
      final lastFour = number.substring(number.length - 4);
      return '**** **** **** $lastFour';
    }
    return number;
  }
}