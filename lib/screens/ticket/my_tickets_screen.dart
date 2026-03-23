import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app_colors.dart';
import '../../app_text_styles.dart';
import '../../models/ticket_model.dart';
import '../../services/ticket_storage_service.dart';
import '../../widgets/booking_compact_header.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/ticket_card.dart';
import '../ticket_selection_screen.dart';
import 'ticket_screen.dart';

class MyTicketsScreen extends StatefulWidget {
  const MyTicketsScreen({super.key});

  @override
  State<MyTicketsScreen> createState() => _MyTicketsScreenState();
}

class _MyTicketsScreenState extends State<MyTicketsScreen> {
  late Future<List<TicketModel>> _ticketsFuture;

  @override
  void initState() {
    super.initState();
    _ticketsFuture = TicketStorageService.instance.getTickets();
  }

  Future<void> _reloadTickets() async {
    final future = TicketStorageService.instance.getTickets();
    setState(() => _ticketsFuture = future);
    await future;
  }

  void _openTicket(TicketModel ticket) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TicketScreen(ticket: ticket)),
    ).then((_) => _reloadTickets());
  }

  void _openHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TicketSelectionScreen()),
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
              child: RefreshIndicator(
                onRefresh: _reloadTickets,
                child: FutureBuilder<List<TicketModel>>(
                  future: _ticketsFuture,
                  builder: (context, snapshot) {
                    final tickets = snapshot.data ?? const <TicketModel>[];

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                      children: [
                        Text(
                          'My Tickets',
                          style: AppTextStyles.heading.copyWith(
                            fontSize: 24,
                            color: AppColors.primaryGreen,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Reopen saved QR passes even when you are offline.',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (snapshot.connectionState == ConnectionState.waiting)
                          const Center(child: CircularProgressIndicator())
                        else if (tickets.isEmpty)
                          _EmptyState(onBookNow: _openHome)
                        else
                          ...tickets.map(
                            (ticket) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TicketCard(
                                ticket: ticket,
                                onTap: () => _openTicket(ticket),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onBookNow;

  const _EmptyState({required this.onBookNow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.confirmation_number_outlined,
            size: 52,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(height: 16),
          Text(
            'No saved tickets yet',
            style: AppTextStyles.title.copyWith(color: AppColors.primaryGreen),
          ),
          const SizedBox(height: 8),
          Text(
            'Book your visit and keep the QR pass on this device for quick entry.',
            style: AppTextStyles.body,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          PrimaryButton(text: 'Book Tickets', onPressed: onBookNow),
        ],
      ),
    );
  }
}
