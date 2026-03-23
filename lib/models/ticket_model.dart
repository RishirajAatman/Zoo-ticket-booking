import 'dart:convert';

class TicketModel {
  final String ticketId;
  final String visitorName;
  final String mobileNumber;
  final int ticketCount;
  final DateTime visitDate;
  final DateTime issuedAt;
  final int totalPaid;
  final String paymentMethod;
  final List<String> attractions;

  const TicketModel({
    required this.ticketId,
    required this.visitorName,
    required this.mobileNumber,
    required this.ticketCount,
    required this.visitDate,
    required this.issuedAt,
    required this.totalPaid,
    required this.paymentMethod,
    required this.attractions,
  });

  factory TicketModel.create({
    required String visitorName,
    required String mobileNumber,
    required int ticketCount,
    required DateTime visitDate,
    required int totalPaid,
    required String paymentMethod,
    required List<String> attractions,
  }) {
    final issuedAt = DateTime.now();
    final ticketSuffix = issuedAt.millisecondsSinceEpoch.toString().substring(
      6,
    );

    return TicketModel(
      ticketId: 'ZOO-$ticketSuffix',
      visitorName: visitorName,
      mobileNumber: mobileNumber,
      ticketCount: ticketCount,
      visitDate: visitDate,
      issuedAt: issuedAt,
      totalPaid: totalPaid,
      paymentMethod: paymentMethod,
      attractions: attractions,
    );
  }

  String get qrPayload => jsonEncode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'ticketId': ticketId,
      'visitorName': visitorName,
      'mobileNumber': mobileNumber,
      'ticketCount': ticketCount,
      'visitDate': visitDate.toIso8601String(),
      'issuedAt': issuedAt.toIso8601String(),
      'totalPaid': totalPaid,
      'paymentMethod': paymentMethod,
      'attractions': attractions,
    };
  }

  factory TicketModel.fromMap(Map<String, dynamic> map) {
    return TicketModel(
      ticketId: map['ticketId'] as String,
      visitorName: map['visitorName'] as String,
      mobileNumber: map['mobileNumber'] as String,
      ticketCount: map['ticketCount'] as int,
      visitDate: DateTime.parse(map['visitDate'] as String),
      issuedAt: DateTime.parse(map['issuedAt'] as String),
      totalPaid: map['totalPaid'] as int,
      paymentMethod: map['paymentMethod'] as String,
      attractions: List<String>.from(map['attractions'] as List<dynamic>),
    );
  }
}
