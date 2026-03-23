import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app_text_styles.dart';
import '../models/ticket_model.dart';
import '../state/cart_notifier.dart';
import 'payment_success_screen.dart';

class PaymentProcessingScreen extends ConsumerStatefulWidget {
  final String visitorName;
  final String mobileNumber;
  final int ticketsCount;
  final int cameraFee;
  final int gstAmount;
  final int totalAmount;
  final DateTime visitDate;
  final String paymentMethod;
  final List<String> attractions;

  const PaymentProcessingScreen({
    super.key,
    required this.visitorName,
    required this.mobileNumber,
    this.ticketsCount = 0,
    this.cameraFee = 0,
    this.gstAmount = 0,
    this.totalAmount = 0,
    required this.visitDate,
    required this.paymentMethod,
    required this.attractions,
  });

  @override
  ConsumerState<PaymentProcessingScreen> createState() =>
      _PaymentProcessingScreenState();
}

class _PaymentProcessingScreenState
    extends ConsumerState<PaymentProcessingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final ticket = TicketModel.create(
        visitorName: widget.visitorName,
        mobileNumber: widget.mobileNumber,
        ticketCount: widget.ticketsCount,
        visitDate: widget.visitDate,
        totalPaid: widget.totalAmount,
        paymentMethod: widget.paymentMethod,
        attractions: widget.attractions,
      );

      ref.read(cartProvider.notifier).clear();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => PaymentSuccessScreen(ticket: ticket)),
        (route) => route.isFirst,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('Processing Payment...', style: AppTextStyles.body),
            ],
          ),
        ),
      ),
    );
  }
}
