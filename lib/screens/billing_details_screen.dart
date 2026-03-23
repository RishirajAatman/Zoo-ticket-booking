import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/booking_compact_header.dart';
import 'payment_selection_screen.dart';
import 'ticket/my_tickets_screen.dart';
import 'ticket_selection_screen.dart';

class BillingScreen extends StatelessWidget {
  final int snakeTickets;
  final int zooTickets;
  final int birdTickets;
  final int cameraTickets;

  const BillingScreen({
    super.key,
    this.snakeTickets = 0,
    this.zooTickets = 0,
    this.birdTickets = 0,
    this.cameraTickets = 0,
  });

  @override
  Widget build(BuildContext context) {
    return BillingDetailsScreen(
      snakeTickets: snakeTickets,
      zooTickets: zooTickets,
      birdTickets: birdTickets,
      cameraTickets: cameraTickets,
    );
  }
}

class BillingDetailsScreen extends StatefulWidget {
  final int snakeTickets;
  final int zooTickets;
  final int birdTickets;
  final int cameraTickets;

  const BillingDetailsScreen({
    super.key,
    this.snakeTickets = 0,
    this.zooTickets = 0,
    this.birdTickets = 0,
    this.cameraTickets = 0,
  });

  @override
  State<BillingDetailsScreen> createState() => _BillingDetailsScreenState();
}

class _BillingDetailsScreenState extends State<BillingDetailsScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();

  bool _hasName = false;
  bool _hasValidPhone = false;
  bool _isOtpValid = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _mobileController.addListener(_onFormChanged);
    _otpController.addListener(_onFormChanged);
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFormChanged);
    _mobileController.removeListener(_onFormChanged);
    _otpController.removeListener(_onFormChanged);
    _nameController.dispose();
    _mobileController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    final nextHasName = _nameController.text.trim().isNotEmpty;
    final nextHasPhone = _mobileController.text.trim().length == 10;
    final nextHasOtp = _otpController.text.trim().length == 4;

    if (nextHasName == _hasName &&
        nextHasPhone == _hasValidPhone &&
        nextHasOtp == _isOtpValid) {
      return;
    }

    setState(() {
      _hasName = nextHasName;
      _hasValidPhone = nextHasPhone;
      _isOtpValid = nextHasOtp;
    });
  }

  int get _ticketSubtotal =>
      (widget.snakeTickets * 10) +
      (widget.zooTickets * 30) +
      (widget.birdTickets * 30);

  int get _cameraFee => widget.cameraTickets * 200;
  int get _subtotal => _ticketSubtotal + _cameraFee;
  int get _gst => (_subtotal * 0.05).round();

  int get _ticketsCount =>
      widget.snakeTickets +
      widget.zooTickets +
      widget.birdTickets +
      widget.cameraTickets;

  int get _total => _subtotal + _gst;

  bool get _canContinue =>
      _ticketsCount > 0 && _hasName && _hasValidPhone && _isOtpValid;

  List<String> get _selectedAttractions {
    final attractions = <String>[];

    if (widget.zooTickets > 0) attractions.add('Main Zoo');
    if (widget.snakeTickets > 0) attractions.add('Snake Tunnel');
    if (widget.birdTickets > 0) attractions.add('Birds Cage');
    if (widget.cameraTickets > 0) attractions.add('Camera Pass');

    return attractions;
  }

  void _goToPayment() {
    if (!_canContinue) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentSelectionScreen(
          visitorName: _nameController.text.trim(),
          mobileNumber: _mobileController.text.trim(),
          ticketsCount: _ticketsCount,
          cameraFee: _cameraFee,
          gstAmount: _gst,
          totalAmount: _total,
          visitDate: DateTime.now(),
          attractions: _selectedAttractions,
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
                    const _BillingTitle(),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Guest booking only. Enter your name, mobile number, and a 4-digit OTP to complete checkout.',
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _SummaryGrid(
                      ticketsCount: _ticketsCount,
                      cameraFee: _cameraFee,
                      gst: _gst,
                      total: _total,
                    ),
                    const SizedBox(height: 24),
                    _StyledField(
                      controller: _nameController,
                      hint: 'Full Name',
                      icon: Icons.person_outline,
                      keyboardType: TextInputType.name,
                    ),
                    const SizedBox(height: 14),
                    _StyledField(
                      controller: _mobileController,
                      hint: 'Mobile Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                    ),
                    const SizedBox(height: 20),
                    _OtpRow(otpController: _otpController),
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
              onArrowTap: _goToPayment,
              onHomeTap: _goHome,
              onProfileTap: _openMyTickets,
              arrowEnabled: _canContinue,
            ),
          ),
        ],
      ),
    );
  }
}

class _BillingTitle extends StatelessWidget {
  const _BillingTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Billing',
          style: AppTextStyles.heading.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryGreen,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
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

class _SummaryGrid extends StatelessWidget {
  final int ticketsCount;
  final int cameraFee;
  final int gst;
  final int total;

  const _SummaryGrid({
    required this.ticketsCount,
    required this.cameraFee,
    required this.gst,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(label: 'Tickets', value: '$ticketsCount'),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _SummaryCard(label: 'Camera', value: '₹$cameraFee'),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(label: 'GST', value: '₹$gst'),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _SummaryCard(
                label: 'Total',
                value: '₹$total',
                highlight: true,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _SummaryCard({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: highlight ? const Color(0xFFC8E6C9) : const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            value,
            style: AppTextStyles.heading.copyWith(
              fontSize: 24,
              color: const Color(0xFF1B5E20),
            ),
          ),
        ],
      ),
    );
  }
}

class _StyledField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;
  final int? maxLength;

  const _StyledField({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.keyboardType,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.secondaryGreen.withValues(alpha: 0.26),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLength,
              inputFormatters: keyboardType == TextInputType.phone
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                border: InputBorder.none,
                counterText: '',
                hintText: hint,
                hintStyle: AppTextStyles.body.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.65),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OtpRow extends StatelessWidget {
  final TextEditingController otpController;

  const _OtpRow({required this.otpController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.secondaryGreen.withValues(alpha: 0.26),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.lock_outline_rounded, color: AppColors.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: AppTextStyles.heading.copyWith(
                fontSize: 22,
                letterSpacing: 8,
                color: AppColors.primaryGreen,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '----',
                counterText: '',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
