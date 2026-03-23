import 'package:flutter_test/flutter_test.dart';

import 'package:zoo_ticket_booking/main.dart';

void main() {
  testWidgets('shows tourist booking home actions after splash', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ZooBookingApp());

    expect(find.text('Zoo Booking'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Zoo Map'), findsOneWidget);
    expect(find.text('My Tickets'), findsOneWidget);
    expect(find.text('Choose Your Attractions'), findsOneWidget);
    expect(
      find.text(
        'Start with the Main Zoo ticket, then add extra experiences for your group.',
      ),
      findsOneWidget,
    );
  });
}
