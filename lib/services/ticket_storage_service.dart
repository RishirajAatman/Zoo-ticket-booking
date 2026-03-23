import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/ticket_model.dart';

class TicketStorageService {
  TicketStorageService._();

  static final TicketStorageService instance = TicketStorageService._();
  static const String _storageKey = 'saved_zoo_tickets';

  Future<List<TicketModel>> getTickets() async {
    final prefs = await SharedPreferences.getInstance();
    final rawTickets = prefs.getStringList(_storageKey) ?? const [];

    final tickets =
        rawTickets
            .map((entry) => TicketModel.fromMap(jsonDecode(entry)))
            .toList()
          ..sort((left, right) => right.issuedAt.compareTo(left.issuedAt));

    return tickets;
  }

  Future<void> saveTicket(TicketModel ticket) async {
    final prefs = await SharedPreferences.getInstance();
    final tickets = await getTickets();
    final index = tickets.indexWhere(
      (entry) => entry.ticketId == ticket.ticketId,
    );

    if (index >= 0) {
      tickets[index] = ticket;
    } else {
      tickets.insert(0, ticket);
    }

    final encoded = tickets
        .map((entry) => jsonEncode(entry.toMap()))
        .toList(growable: false);

    await prefs.setStringList(_storageKey, encoded);
  }

  Future<bool> containsTicket(String ticketId) async {
    final tickets = await getTickets();
    return tickets.any((entry) => entry.ticketId == ticketId);
  }
}
