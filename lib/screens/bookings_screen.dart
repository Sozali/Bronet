import 'package:flutter/material.dart';
import '../theme/colors.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Upcoming', 'Completed', 'Cancelled'];

  final List<Map<String, dynamic>> _upcoming = [
    {
      'emoji': '✂️',
      'service': 'Classic Haircut + Beard',
      'provider': 'Qehreman Barbershop',
      'specialist': 'Rauf M.',
      'date': 'Today',
      'time': '14:30',
      'price': '15 AZN',
      'status': 'confirmed',
      'color': 0xFFE8F0E4,
      'id': '#BRN-2841',
    },
    {
      'emoji': '🦷',
      'service': 'Teeth Whitening',
      'provider': 'SmilePro Dental',
      'specialist': 'Dr. Nigar H.',
      'date': 'Tomorrow',
      'time': '11:00',
      'price': '72 AZN',
      'status': 'confirmed',
      'color': 0xFFECF4FC,
      'id': '#BRN-2842',
    },
    {
      'emoji': '🧖',
      'service': 'Swedish Massage 60min',
      'provider': 'Serenity Spa Baku',
      'specialist': 'Leyla A.',
      'date': 'Mar 12',
      'time': '16:00',
      'price': '50 AZN',
      'status': 'pending',
      'color': 0xFFEAF4F0,
      'id': '#BRN-2843',
    },
  ];

  final List<Map<String, dynamic>> _completed = [
    {
      'emoji': '✂️',
      'service': 'Classic Haircut',
      'provider': 'Qehreman Barbershop',
      'specialist': 'Rauf M.',
      'date': 'Mar 1',
      'time': '13:00',
      'price': '15 AZN',
      'status': 'completed',
      'color': 0xFFE8F0E4,
      'id': '#BRN-2831',
      'rated': true,
      'rating': 5,
    },
    {
      'emoji': '💅',
      'service': 'Gel Manicure',
      'provider': 'Pearl Nail Studio',
      'specialist': 'Aysel K.',
      'date': 'Feb 24',
      'time': '15:30',
      'price': '20 AZN',
      'status': 'completed',
      'color': 0xFFF0ECF8,
      'id': '#BRN-2820',
      'rated': false,
      'rating': 0,
    },
    {
      'emoji': '💪',
      'service': 'Personal Training',
      'provider': 'FitPeak Gym',
      'specialist': 'Kamran T.',
      'date': 'Feb 18',
      'time': '09:00',
      'price': '35 AZN',
      'status': 'completed',
      'color': 0xFFFFF0E8,
      'id': '#BRN-2810',
      'rated': true,
      'rating': 4,
    },
  ];

  final List<Map<String, dynamic>> _cancelled = [
    {
      'emoji': '🚗',
      'service': 'Full Car Diagnostics',
      'provider': 'AutoMaster Express',
      'specialist': 'Elshan B.',
      'date': 'Feb 20',
      'time': '10:00',
      'price': '48 AZN',
      'status': 'cancelled',
      'color': 0xFFEAECF4,
      'id': '#BRN-2815',
      'reason': 'Cancelled by user',
    },
  ];

  List<Map<String, dynamic>> get _current {
    if (_selectedTab == 0) return _upcoming;
    if (_selectedTab == 1) return _completed;
    return _cancelled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildStats(),
            _buildTabs(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('My Bookings', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2C3528),
            letterSpacing: -0.5,
          )),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: BronetColors.bgCard,
              borderRadius: BorderRadius.circular(12),
              boxShadow: BronetColors.shadow,
            ),
            child: const Icon(Icons.filter_list_rounded,
              color: BronetColors.forest, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final stats = [
      {'label': 'Total', 'value': '7', 'icon': '📋'},
      {'label': 'Upcoming', 'value': '3', 'icon': '⏰'},
      {'label': 'Spent', 'value': '284 ₼', 'icon': '💳'},
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3528), Color(0xFF1E2A1A)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: BronetColors.shadowStrong,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((s) => Column(children: [
          Text(s['icon']!, style: const TextStyle(fontSize: 20)),
          const SizedBox(height: 5),
          Text(s['value']!, style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          )),
          Text(s['label']!, style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11,
          )),
        ])).toList(),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final selected = _selectedTab == i;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: Container(
                margin: EdgeInsets.only(right: i < _tabs.length - 1 ? 8 : 0),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? BronetColors.forest : BronetColors.bgCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected
                        ? BronetColors.forest
                        : BronetColors.sage.withOpacity(0.2),
                  ),
                  boxShadow: selected ? BronetColors.shadow : [],
                ),
                child: Center(
                  child: Text(_tabs[i], style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : BronetColors.textMuted,
                  )),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildList() {
    final list = _current;
    if (list.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('📭', style: TextStyle(fontSize: 52)),
            SizedBox(height: 16),
            Text('No bookings here',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BronetColors.textMuted,
              )),
            SizedBox(height: 8),
            Text('Your bookings will appear here',
              style: TextStyle(
                fontSize: 13,
                color: BronetColors.textLight,
              )),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      itemCount: list.length,
      itemBuilder: (context, i) => _buildBookingCard(list[i]),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> b) {
    final status = b['status'] as String;

    Color statusColor;
    String statusLabel;
    switch (status) {
      case 'confirmed':
        statusColor = BronetColors.green;
        statusLabel = 'Confirmed';
        break;
      case 'pending':
        statusColor = BronetColors.amber;
        statusLabel = 'Pending';
        break;
      case 'completed':
        statusColor = BronetColors.sageDark;
        statusLabel = 'Completed';
        break;
      default:
        statusColor = BronetColors.red;
        statusLabel = 'Cancelled';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: BronetColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BronetColors.shadow,
      ),
      child: Column(
        children: [
          // Top row
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // Emoji box
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: Color(b['color'] as int),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(b['emoji'] as String,
                      style: const TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(b['service'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2C3528),
                              ), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(statusLabel, style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            )),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(b['provider'] as String, style: const TextStyle(
                        fontSize: 12,
                        color: BronetColors.textMuted,
                      )),
                      const SizedBox(height: 5),
                      Row(children: [
                        const Icon(Icons.person_rounded,
                          size: 12, color: BronetColors.textLight),
                        const SizedBox(width: 3),
                        Text(b['specialist'] as String, style: const TextStyle(
                          fontSize: 11,
                          color: BronetColors.textMuted,
                        )),
                        const SizedBox(width: 10),
                        const Icon(Icons.access_time_rounded,
                          size: 12, color: BronetColors.textLight),
                        const SizedBox(width: 3),
                        Text('${b['date']} • ${b['time']}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: BronetColors.textMuted,
                          )),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Divider
          Container(height: 1, color: BronetColors.bgMuted),
          // Bottom row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(b['id'] as String, style: const TextStyle(
                  fontSize: 11,
                  color: BronetColors.textLight,
                  fontWeight: FontWeight.w600,
                )),
                Row(children: [
                  Text(b['price'] as String, style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: BronetColors.forest,
                  )),
                  const SizedBox(width: 10),
                  // Action button based on status
                  if (status == 'upcoming' || status == 'confirmed' || status == 'pending')
                    _actionButton('Reschedule', BronetColors.sageBg, BronetColors.sageDark),
                  if (status == 'completed' && b['rated'] == false)
                    _actionButton('Rate ⭐', BronetColors.amber.withOpacity(0.12), BronetColors.amber),
                  if (status == 'completed' && b['rated'] == true)
                    Row(children: List.generate(b['rating'] as int, (_) =>
                      const Text('⭐', style: TextStyle(fontSize: 12)))),
                  if (status == 'cancelled')
                    _actionButton('Rebook', BronetColors.sageBg, BronetColors.sageDark),
                ]),
              ],
            ),
          ),
          // Cancel button for upcoming
          if (status == 'confirmed' || status == 'pending')
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: BronetColors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: BronetColors.red.withOpacity(0.2)),
                    ),
                    child: const Center(
                      child: Text('Cancel Booking', style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: BronetColors.red,
                      )),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: BronetColors.forest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text('View Details', style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                    ),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: textColor,
      )),
    );
  }
}
