import 'package:flutter/material.dart';

import '../models/ticket_model.dart';
import 'ticket/ticket_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final TicketModel ticket;

  const PaymentSuccessScreen({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return TicketScreen(
      ticket: ticket,
      persistOnOpen: true,
      showSuccessBanner: true,
    );
  }
}
