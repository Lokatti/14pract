class Requisite {
  final int requisitesId;
  final String cardNumber;
  final double balance;

  Requisite({
    required this.requisitesId,
    required this.cardNumber,
    required this.balance,
  });

  factory Requisite.fromJson(Map<String, dynamic> json) {
    return Requisite(
      requisitesId: json['requisitesId'],
      cardNumber: json['cardNumber'],
      balance: json['balance'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requisitesId': requisitesId,
      'cardNumber': cardNumber,
      'balance': balance,
    };
  }
}
