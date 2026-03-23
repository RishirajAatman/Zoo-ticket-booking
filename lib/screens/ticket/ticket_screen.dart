import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../app_colors.dart';
import '../../app_text_styles.dart';
import '../../models/ticket_model.dart';
import '../../services/ticket_storage_service.dart';
import '../../widgets/booking_compact_header.dart';
import '../../widgets/primary_button.dart';
import '../ticket_selection_screen.dart';
import 'my_tickets_screen.dart';

class TicketScreen extends StatefulWidget {
  final TicketModel ticket;
  final bool persistOnOpen;
  final bool showSuccessBanner;

  const TicketScreen({
    super.key,
    required this.ticket,
    this.persistOnOpen = false,
    this.showSuccessBanner = false,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  bool _isSaving = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    _hydrateSavedState();
  }

  Future<void> _hydrateSavedState() async {
    final alreadySaved = await TicketStorageService.instance.containsTicket(
      widget.ticket.ticketId,
    );

    if (!mounted) return;

    setState(() => _isSaved = alreadySaved);

    if (!alreadySaved && widget.persistOnOpen) {
      await _saveTicket(showFeedback: false);
    }
  }

  Future<void> _saveTicket({bool showFeedback = true}) async {
    if (_isSaving || _isSaved) {
      if (showFeedback) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ticket already saved offline.')),
        );
      }
      return;
    }

    setState(() => _isSaving = true);
    await TicketStorageService.instance.saveTicket(widget.ticket);

    if (!mounted) return;

    setState(() {
      _isSaving = false;
      _isSaved = true;
    });

    if (showFeedback) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ticket saved for offline access.')),
      );
    }
  }

  void _openHome() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const TicketSelectionScreen()),
      (route) => false,
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
    final dayText = DateFormat('EEEE').format(widget.ticket.visitDate);
    final dateText = DateFormat('d MMMM y').format(widget.ticket.visitDate);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        fit: StackFit.expand,
        children: [
          BookingCompactHeader(
            dayText: dayText,
            dateText: dateText,
            trailingIcon: Icons.home_rounded,
            onTrailingTap: _openHome,
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
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.showSuccessBanner) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryGreen,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Payment successful',
                                    style: AppTextStyles.title.copyWith(
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Your tourist pass is ready to scan at the entrance.',
                                    style: AppTextStyles.body,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: QrImageView(
                          data: widget.ticket.qrPayload,
                          version: QrVersions.auto,
                          size: 220,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: AppColors.primaryGreen,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            color: AppColors.primaryGreen,
                            dataModuleShape: QrDataModuleShape.square,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ticket Details',
                            style: AppTextStyles.title.copyWith(
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          const SizedBox(height: 16),
                          _DetailRow(
                            label: 'Ticket ID',
                            value: widget.ticket.ticketId,
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(
                            label: 'Visitor Name',
                            value: widget.ticket.visitorName,
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(
                            label: 'Date',
                            value: DateFormat(
                              'EEE, d MMM y',
                            ).format(widget.ticket.visitDate),
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(
                            label: 'Visitors',
                            value: '${widget.ticket.ticketCount}',
                          ),
                          const SizedBox(height: 12),
                          _DetailRow(
                            label: 'Payment',
                            value: widget.ticket.paymentMethod,
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: widget.ticket.attractions
                                .map(
                                  (item) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: Text(
                                      item,
                                      style: AppTextStyles.caption.copyWith(
                                        color: AppColors.primaryGreen,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(growable: false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      text: _isSaved
                          ? 'Saved Offline'
                          : _isSaving
                          ? 'Saving...'
                          : 'Save Ticket',
                      onPressed: _isSaving ? null : _saveTicket,
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: _openMyTickets,
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        foregroundColor: AppColors.primaryGreen,
                        side: BorderSide(
                          color: AppColors.primaryGreen.withValues(alpha: 0.3),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Open My Tickets'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(fontSize: 13),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
