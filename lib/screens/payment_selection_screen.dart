import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/booking_compact_header.dart';
import 'payment_processing_screen.dart';
import 'ticket/my_tickets_screen.dart';
import 'ticket_selection_screen.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final String visitorName;
  final String mobileNumber;
  final int ticketsCount;
  final int cameraFee;
  final int gstAmount;
  final int totalAmount;
  final DateTime visitDate;
  final List<String> attractions;

  const PaymentSelectionScreen({
    super.key,
    required this.visitorName,
    required this.mobileNumber,
    this.ticketsCount = 0,
    this.cameraFee = 0,
    this.gstAmount = 0,
    this.totalAmount = 0,
    required this.visitDate,
    required this.attractions,
  });

  @override
  State<PaymentSelectionScreen> createState() => _PaymentSelectionScreenState();
}

class _PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  String? selectedPaymentMethod;

  void _selectMethod(String method) {
    setState(() => selectedPaymentMethod = method);
  }

  void _goToNextStep() {
    if (selectedPaymentMethod == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentProcessingScreen(
          visitorName: widget.visitorName,
          mobileNumber: widget.mobileNumber,
          ticketsCount: widget.ticketsCount,
          cameraFee: widget.cameraFee,
          gstAmount: widget.gstAmount,
          totalAmount: widget.totalAmount,
          visitDate: widget.visitDate,
          paymentMethod: selectedPaymentMethod!,
          attractions: widget.attractions,
        ),
      ),
    );
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TicketSelectionScreen()),
    );
  }

  void _openMyTickets() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MyTicketsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayText = DateFormat('EEEE').format(now);
    final dateText = DateFormat('d MMMM y').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        fit: StackFit.expand,
        children: [
          BookingCompactHeader(
            dayText: dayText,
            dateText: dateText,
            trailingIcon: Icons.arrow_back_rounded,
            onTrailingTap: () => Navigator.pop(context),
          ),
          Positioned(
            top: 124,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF3F3F3),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 140),
                child: Column(
                  children: [
                    const _PaymentTitle(),
                    const SizedBox(height: 20),
                    _OrderSummaryCard(
                      visitorName: widget.visitorName,
                      totalAmount: widget.totalAmount,
                      ticketsCount: widget.ticketsCount,
                    ),
                    const SizedBox(height: 16),
                    _MethodSection(
                      title: 'Preferred Payment',
                      children: [
                        _MethodRow(
                          logoType: _PaymentLogoType.googlePay,
                          label: 'Google Pay',
                          subtitle: 'Fastest checkout for mobile tourists',
                          selected: selectedPaymentMethod == 'Google Pay',
                          onTap: () => _selectMethod('Google Pay'),
                        ),
                        const SizedBox(height: 10),
                        _MethodRow(
                          logoType: _PaymentLogoType.phonePe,
                          label: 'PhonePe',
                          subtitle: 'Pay directly with UPI',
                          selected: selectedPaymentMethod == 'PhonePe',
                          onTap: () => _selectMethod('PhonePe'),
                        ),
                        const SizedBox(height: 10),
                        _MethodRow(
                          logoType: _PaymentLogoType.upi,
                          label: 'UPI ID',
                          subtitle: 'Use any supported UPI handle',
                          selected: selectedPaymentMethod == 'UPI ID',
                          onTap: () => _selectMethod('UPI ID'),
                        ),
                        const SizedBox(height: 10),
                        _MethodRow(
                          logoType: _PaymentLogoType.mastercard,
                          label: 'Debit / Credit Card',
                          subtitle: 'One-time secure card payment',
                          selected:
                              selectedPaymentMethod == 'Debit / Credit Card',
                          onTap: () => _selectMethod('Debit / Credit Card'),
                        ),
                        const SizedBox(height: 10),
                        _MethodRow(
                          logoType: _PaymentLogoType.addCard,
                          label: 'Net Banking',
                          subtitle: 'Alternative bank redirect flow',
                          selected: selectedPaymentMethod == 'Net Banking',
                          onTap: () => _selectMethod('Net Banking'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavigation(
              currentTab: NavigationTab.home,
              onArrowTap: _goToNextStep,
              onHomeTap: _goHome,
              onProfileTap: _openMyTickets,
              arrowEnabled: selectedPaymentMethod != null,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentTitle extends StatelessWidget {
  const _PaymentTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Payment',
          style: AppTextStyles.heading.copyWith(
            fontSize: 22,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 48,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.secondaryGreen,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final String visitorName;
  final int totalAmount;
  final int ticketsCount;

  const _OrderSummaryCard({
    required this.visitorName,
    required this.totalAmount,
    required this.ticketsCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            visitorName,
            style: AppTextStyles.title.copyWith(color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 6),
          Text(
            '$ticketsCount tickets ready for checkout',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 12),
          Text(
            'Pay ₹$totalAmount',
            style: AppTextStyles.heading.copyWith(
              fontSize: 26,
              color: AppColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _MethodSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.secondaryGreen.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.title.copyWith(
              fontSize: 15,
              color: AppColors.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }
}

class _MethodRow extends StatelessWidget {
  final _PaymentLogoType logoType;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _MethodRow({
    required this.logoType,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFE8F5E9) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.primaryGreen.withValues(alpha: 0.35)
                : AppColors.secondaryGreen.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          children: [
            _MethodLogo(type: logoType),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? AppColors.primaryGreen
                      : AppColors.textSecondary.withValues(alpha: 0.45),
                  width: 1.8,
                ),
              ),
              child: selected
                  ? const Center(
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor: AppColors.primaryGreen,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

enum _PaymentLogoType { googlePay, phonePe, upi, mastercard, addCard }

class _MethodLogo extends StatelessWidget {
  final _PaymentLogoType type;

  const _MethodLogo({required this.type});

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case _PaymentLogoType.googlePay:
        return _LogoBox(
          child: RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: 'G',
                  style: TextStyle(
                    color: Color(0xFF4285F4),
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: 'Pay',
                  style: TextStyle(
                    color: Color(0xFF202124),
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      case _PaymentLogoType.phonePe:
        return _LogoBox(
          background: const Color(0xFF5F259F),
          child: const Text(
            'पे',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        );
      case _PaymentLogoType.upi:
        return _LogoBox(
          child: const Text(
            'UPI',
            style: TextStyle(
              color: Color(0xFF1B5E20),
              fontWeight: FontWeight.w800,
              fontSize: 10,
            ),
          ),
        );
      case _PaymentLogoType.mastercard:
        return _LogoBox(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 8,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEB001B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 8,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF79E1B),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );
      case _PaymentLogoType.addCard:
        return _LogoBox(
          child: const Icon(
            Icons.account_balance_rounded,
            size: 18,
            color: AppColors.primaryGreen,
          ),
        );
    }
  }
}

class _LogoBox extends StatelessWidget {
  final Widget child;
  final Color background;

  const _LogoBox({
    required this.child,
    this.background = const Color(0xFFE8F5E9),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}
