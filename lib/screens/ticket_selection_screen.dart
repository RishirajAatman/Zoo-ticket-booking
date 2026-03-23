import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../app_colors.dart';
import '../app_text_styles.dart';
import '../screens/events/today_at_zoo_screen.dart';
import '../screens/home/attraction_info_modal.dart';
import '../screens/map/zoo_map_screen.dart';
import '../screens/ticket/my_tickets_screen.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/rounded_option_card.dart';
import 'billing_details_screen.dart';

// ---------------------------------------------------------------------------
// Public entry‑point aliases (kept for backward compatibility)
// ---------------------------------------------------------------------------

class TicketListScreen extends StatelessWidget {
  const TicketListScreen({super.key});

  @override
  Widget build(BuildContext context) => const TicketSelectionScreen();
}

// ---------------------------------------------------------------------------
// Main screen
// ---------------------------------------------------------------------------

class TicketSelectionScreen extends StatefulWidget {
  const TicketSelectionScreen({super.key});

  @override
  State<TicketSelectionScreen> createState() => _TicketSelectionScreenState();
}

class _TicketSelectionScreenState extends State<TicketSelectionScreen> {
  static const int _mainZooIndex = 1;
  static const Set<int> _dependentTicketIndexes = {0, 2, 3};

  // ---- ticket data --------------------------------------------------------
  static const List<_TicketData> _tickets = [
    _TicketData(
      title: 'Snake Tunnel Ticket',
      subtitle: 'Indoor reptile trail',
      price: 10,
      imageAsset: 'assets/images/snake_tunnel.png',
      info: AttractionInfo(
        title: 'Snake Tunnel',
        description:
            'A cool indoor walkthrough designed for quick family visits.',
        recommendedTime: '15 minutes',
        highlights: [
          '20+ snake species',
          'Indoor exhibit',
          'Best visited before noon crowds',
        ],
      ),
    ),
    _TicketData(
      title: 'Main Zoo Ticket',
      subtitle: 'Full day access',
      price: 30,
      imageAsset: 'assets/images/main_zoo.png',
      info: AttractionInfo(
        title: 'Main Zoo',
        description:
            'Access to the central animal trail and family viewing zones.',
        recommendedTime: '2 to 3 hours',
        highlights: [
          'Covers core animal enclosures',
          'Easy access to food court and washrooms',
          'Required before adding other attraction tickets',
        ],
      ),
    ),
    _TicketData(
      title: 'Birds Cage Ticket',
      subtitle: 'Walk-through aviary',
      price: 30,
      imageAsset: 'assets/images/birds_cage.png',
      info: AttractionInfo(
        title: 'Birds Cage',
        description: 'A shaded aviary with close-range bird viewing paths.',
        recommendedTime: '20 minutes',
        highlights: [
          'Bright tropical birds',
          'Good family photo spot',
          'Covered pathway',
        ],
      ),
    ),
    _TicketData(
      title: 'Camera Ticket',
      subtitle: 'Photo access add-on',
      price: 200,
      imageAsset: 'assets/images/camer.png',
      info: AttractionInfo(
        title: 'Camera Pass',
        description: 'Bring dedicated photography gear into the zoo grounds.',
        recommendedTime: 'Full visit',
        highlights: [
          'Single visit camera permit',
          'Useful for safari and aviary zones',
          'Add-on to main ticket only',
        ],
      ),
    ),
  ];

  late final List<int> _quantities = List<int>.filled(_tickets.length, 0);

  // ---- helpers ------------------------------------------------------------
  void _updateQty(int index, int delta) {
    setState(() {
      if (index == _mainZooIndex) {
        final nextMainQty = (_quantities[index] + delta).clamp(0, 99);
        _quantities[index] = nextMainQty;

        for (final dependentIndex in _dependentTicketIndexes) {
          if (_quantities[dependentIndex] > nextMainQty) {
            _quantities[dependentIndex] = nextMainQty;
          }
        }
        return;
      }

      if (delta > 0) {
        final mainZooQty = _quantities[_mainZooIndex];
        if (mainZooQty == 0) return;

        final nextDependentQty = (_quantities[index] + delta).clamp(
          0,
          mainZooQty,
        );
        _quantities[index] = nextDependentQty;
        return;
      }

      final next = _quantities[index] + delta;
      _quantities[index] = next.clamp(0, 99);
    });
  }

  void _openBilling() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BillingScreen(
          snakeTickets: _quantities[0],
          zooTickets: _quantities[1],
          birdTickets: _quantities[2],
          cameraTickets: _quantities[3],
        ),
      ),
    );
  }

  void _openMap() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ZooMapScreen()),
    );
  }

  void _openTodayAtZoo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TodayAtZooScreen()),
    );
  }

  void _openMyTickets() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MyTicketsScreen()),
    );
  }

  int get _totalSelected => _quantities.fold(0, (sum, entry) => sum + entry);

  // ---- build --------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayText = DateFormat('EEEE').format(now);
    final dateText = DateFormat('d MMMM').format(now);
    final ticketCards = List<Widget>.generate(_tickets.length, (index) {
      final ticket = _tickets[index];

      return _AnimatedTicketCard(
        index: index,
        child: _AttractionTicketCard(
          title: ticket.title,
          subtitle: ticket.subtitle,
          price: ticket.price,
          imageAsset: ticket.imageAsset,
          quantity: _quantities[index],
          onIncrement: () => _updateQty(index, 1),
          onDecrement: () => _updateQty(index, -1),
          onInfoTap: () => showAttractionInfoModal(context, ticket.info),
        ),
      );
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CustomScrollView(
            slivers: [
              _HomeSliverHeader(
                dayText: dayText,
                dateText: dateText,
                onMapTap: _openMap,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _QuickActionsSection(
                    onOpenMap: _openMap,
                    onOpenTodayAtZoo: _openTodayAtZoo,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _SectionTitle(),
                ),
              ),
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: _SectionDescription(),
                ),
              ),
              SliverList(delegate: SliverChildListDelegate(ticketCards)),
              const SliverToBoxAdapter(child: SizedBox(height: 140)),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomNavigation(
              currentTab: NavigationTab.home,
              onArrowTap: _openBilling,
              onHomeTap: _goHome,
              onProfileTap: _openMyTickets,
              arrowEnabled: _totalSelected > 0,
            ),
          ),
        ],
      ),
    );
  }

  void _goHome() {}
}

class _HomeSliverHeader extends StatelessWidget {
  final String dayText;
  final String dateText;
  final VoidCallback onMapTap;

  const _HomeSliverHeader({
    required this.dayText,
    required this.dateText,
    required this.onMapTap,
  });

  static String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning \u{1F44B}';
    if (hour < 17) return 'Good Afternoon \u{1F44B}';
    return 'Good Evening \u{1F44B}';
  }

  @override
  Widget build(BuildContext context) {
    const headerHeight = 110.0;

    return SliverAppBar(
      expandedHeight: headerHeight,
      collapsedHeight: headerHeight,
      toolbarHeight: headerHeight,
      pinned: true,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      elevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1B5E20), Color(0xFF43A047)],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              left: -48,
              right: 140,
              bottom: -70,
              child: Opacity(
                opacity: 0.18,
                child: Container(
                  height: 132,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F4F1A),
                    borderRadius: BorderRadius.circular(140),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 120,
              right: -80,
              bottom: -90,
              child: Opacity(
                opacity: 0.16,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32),
                    borderRadius: BorderRadius.circular(140),
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _greeting(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: onMapTap,
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 14,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.map_outlined,
                                color: AppColors.primaryGreen,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$dayText, $dateText',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  final VoidCallback onOpenMap;
  final VoidCallback onOpenTodayAtZoo;

  const _QuickActionsSection({
    required this.onOpenMap,
    required this.onOpenTodayAtZoo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: RoundedOptionCard(
                icon: Icons.map_outlined,
                title: 'Zoo Map',
                subtitle: 'Find attractions fast',
                onTap: onOpenMap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RoundedOptionCard(
                icon: Icons.event_outlined,
                title: 'Today at the Zoo',
                subtitle: 'See today\'s shows & events',
                onTap: onOpenTodayAtZoo,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// SECTION TITLE  ("Book Your Zoo Ticket →")
// ===========================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Choose Your Attractions',
      style: AppTextStyles.title.copyWith(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryGreen,
      ),
    );
  }
}

class _SectionDescription extends StatelessWidget {
  const _SectionDescription();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Start with the Main Zoo ticket for complete access.',
      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
    );
  }
}

// ===========================================================================
// TICKET CARD
// ===========================================================================

class _AttractionTicketCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int price;
  final String imageAsset;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onInfoTap;

  const _AttractionTicketCard({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageAsset,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: 72,
                  height: 72,
                  child: Image.asset(
                    imageAsset,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF2F6F2),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.title.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1B5E20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkResponse(
                          onTap: onInfoTap,
                          radius: 20,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F6F1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.info_outline_rounded,
                              color: AppColors.primaryGreen,
                              size: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Text(
                            '₹$price',
                            style: AppTextStyles.body.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _CapsuleQuantitySelector(
                          quantity: quantity,
                          onIncrement: onIncrement,
                          onDecrement: onDecrement,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedTicketCard extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedTicketCard({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 24, end: 0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      builder: (context, value, animatedChild) {
        return Transform.translate(
          offset: Offset(0, value),
          child: Opacity(
            opacity: (1 - (value / 24)).clamp(0.0, 1.0),
            child: animatedChild,
          ),
        );
      },
      child: child,
    );
  }
}

// ===========================================================================
// CAPSULE QUANTITY SELECTOR
// ===========================================================================

class _CapsuleQuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CapsuleQuantitySelector({
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtySegmentButton(icon: Icons.remove, onTap: onDecrement),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              '$quantity',
              style: AppTextStyles.title.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryGreen,
              ),
            ),
          ),
          _QtySegmentButton(icon: Icons.add, filled: true, onTap: onIncrement),
        ],
      ),
    );
  }
}

class _QtySegmentButton extends StatelessWidget {
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  const _QtySegmentButton({
    required this.icon,
    this.filled = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: filled ? AppColors.primaryGreen : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Icon(
            icon,
            size: 16,
            color: filled ? Colors.white : AppColors.primaryGreen,
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// DATA MODEL (private)
// ===========================================================================

class _TicketData {
  final String title;
  final String subtitle;
  final int price;
  final String imageAsset;
  final AttractionInfo info;

  const _TicketData({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.imageAsset,
    required this.info,
  });
}
