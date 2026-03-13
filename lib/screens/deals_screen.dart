import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/colors.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['All', 'Flash', 'Weekly', 'New User'];

  // Countdown timers
  late Timer _timer;
  int _flashSeconds = 6 * 3600 + 42 * 60 + 17;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_flashSeconds > 0) {
        setState(() => _flashSeconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timerText {
    final h = _flashSeconds ~/ 3600;
    final m = (_flashSeconds % 3600) ~/ 60;
    final s = _flashSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  final List<Map<String, dynamic>> _deals = [
    {
      'emoji': '✂️',
      'name': 'Classic Haircut + Beard',
      'provider': 'Qehreman Barbershop',
      'cat': 'Barbershop',
      'oldPrice': '35',
      'newPrice': '21',
      'off': '40',
      'tag': 'FLASH',
      'tagColor': 0xFFFF4D6A,
      'color': 0xFFE8F0E4,
      'rating': '4.9',
      'left': '8 slots left',
      'timer': true,
    },
    {
      'emoji': '💅',
      'name': 'Gel Manicure + Pedicure',
      'provider': 'Pearl Nail Studio',
      'cat': 'Nails',
      'oldPrice': '55',
      'newPrice': '31',
      'off': '43',
      'tag': 'FLASH',
      'tagColor': 0xFFFF4D6A,
      'color': 0xFFF0ECF8,
      'rating': '4.7',
      'left': '5 slots left',
      'timer': true,
    },
    {
      'emoji': '🧖',
      'name': 'Swedish Full Body Massage',
      'provider': 'Serenity Spa Baku',
      'cat': 'Spa',
      'oldPrice': '80',
      'newPrice': '50',
      'off': '37',
      'tag': 'WEEKLY',
      'tagColor': 0xFF5A7A54,
      'color': 0xFFEAF4F0,
      'rating': '4.9',
      'left': '12 slots left',
      'timer': false,
    },
    {
      'emoji': '🦷',
      'name': 'Teeth Whitening Session',
      'provider': 'SmilePro Dental',
      'cat': 'Dental',
      'oldPrice': '120',
      'newPrice': '72',
      'off': '40',
      'tag': 'WEEKLY',
      'tagColor': 0xFF5A7A54,
      'color': 0xFFECF4FC,
      'rating': '4.9',
      'left': '3 slots left',
      'timer': false,
    },
    {
      'emoji': '✨',
      'name': 'Laser Hair Removal (legs)',
      'provider': 'LaserZone Baku',
      'cat': 'Laser',
      'oldPrice': '150',
      'newPrice': '75',
      'off': '50',
      'tag': 'NEW USER',
      'tagColor': 0xFF7C6FED,
      'color': 0xFFFCFCE8,
      'rating': '4.8',
      'left': 'Unlimited',
      'timer': false,
    },
    {
      'emoji': '💪',
      'name': 'Monthly Gym Membership',
      'provider': 'FitPeak Gym',
      'cat': 'Gym',
      'oldPrice': '60',
      'newPrice': '36',
      'off': '40',
      'tag': 'NEW USER',
      'tagColor': 0xFF7C6FED,
      'color': 0xFFFFF0E8,
      'rating': '4.7',
      'left': 'Unlimited',
      'timer': false,
    },
    {
      'emoji': '🚗',
      'name': 'Full Car Diagnostics',
      'provider': 'AutoMaster Express',
      'cat': 'Auto',
      'oldPrice': '80',
      'newPrice': '48',
      'off': '40',
      'tag': 'FLASH',
      'tagColor': 0xFFFF4D6A,
      'color': 0xFFEAECF4,
      'rating': '4.6',
      'left': '4 slots left',
      'timer': true,
    },
    {
      'emoji': '🎨',
      'name': 'Small Tattoo Session',
      'provider': 'Inkstone Studio',
      'cat': 'Tattoo',
      'oldPrice': '100',
      'newPrice': '60',
      'off': '40',
      'tag': 'WEEKLY',
      'tagColor': 0xFF5A7A54,
      'color': 0xFFF0E8F4,
      'rating': '4.9',
      'left': '6 slots left',
      'timer': false,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    if (_selectedTab == 0) return _deals;
    final tagMap = {1: 'FLASH', 2: 'WEEKLY', 3: 'NEW USER'};
    return _deals.where((d) => d['tag'] == tagMap[_selectedTab]).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildFlashTimer(),
            _buildTabs(),
            Expanded(child: _buildDealsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Hot Deals', style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Color(0xFF2C3528),
              letterSpacing: -0.5,
            )),
            Text('Save big on top services',
              style: TextStyle(
                fontSize: 13,
                color: BronetColors.textMuted,
              )),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: BronetColors.red.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: BronetColors.red.withOpacity(0.2)),
            ),
            child: Row(children: [
              const Icon(Icons.local_fire_department_rounded,
                color: BronetColors.red, size: 16),
              const SizedBox(width: 5),
              Text('${_filtered.length} deals',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: BronetColors.red,
                )),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashTimer() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 4, 18, 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C3528), Color(0xFF1E2A1A)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: BronetColors.shadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            const Text('⚡', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Flash Sale ends in', style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              )),
              Text('Grab it before it\'s gone!',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                )),
            ]),
          ]),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: BronetColors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(_timerText, style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              fontFeatures: [FontFeature.tabularFigures()],
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _tabs.length,
        itemBuilder: (context, i) {
          final selected = _selectedTab == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? BronetColors.forest : BronetColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? BronetColors.forest
                      : BronetColors.sage.withOpacity(0.25),
                ),
                boxShadow: selected ? BronetColors.shadow : [],
              ),
              child: Text(_tabs[i], style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : BronetColors.textMuted,
              )),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDealsList() {
    final list = _filtered;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      itemCount: list.length,
      itemBuilder: (context, i) => _buildDealCard(list[i]),
    );
  }

  Widget _buildDealCard(Map<String, dynamic> d) {
    final tagColor = Color(d['tagColor'] as int);
    final hasTimer = d['timer'] as bool;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: BronetColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BronetColors.shadow,
      ),
      child: Column(
        children: [
          // Top image row
          Container(
            height: 110,
            decoration: BoxDecoration(
              color: Color(d['color'] as int),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Stack(children: [
              Center(child: Text(d['emoji'] as String,
                style: const TextStyle(fontSize: 44))),
              // Tag badge
              Positioned(
                top: 10, left: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: tagColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(d['tag'] as String, style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  )),
                ),
              ),
              // Discount badge
              Positioned(
                top: 10, right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: BronetColors.forest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('-${d['off']}%', style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  )),
                ),
              ),
              // Timer if flash
              if (hasTimer)
                Positioned(
                  bottom: 8, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(children: [
                      const Icon(Icons.timer_outlined,
                        color: Colors.white, size: 10),
                      const SizedBox(width: 4),
                      Text(_timerText, style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      )),
                    ]),
                  ),
                ),
            ]),
          ),
          // Bottom content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(d['cat'] as String, style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: BronetColors.sageDark,
                      letterSpacing: 0.8,
                    )),
                    Row(children: [
                      const Icon(Icons.star_rounded,
                        size: 12, color: Color(0xFFFFB830)),
                      const SizedBox(width: 3),
                      Text(d['rating'] as String, style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: BronetColors.textPrimary,
                      )),
                    ]),
                  ],
                ),
                const SizedBox(height: 4),
                Text(d['name'] as String, style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2C3528),
                )),
                const SizedBox(height: 3),
                Text(d['provider'] as String, style: const TextStyle(
                  fontSize: 12,
                  color: BronetColors.textMuted,
                )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('${d['newPrice']} AZN', style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: BronetColors.forest,
                        )),
                        const SizedBox(width: 8),
                        Text('${d['oldPrice']} AZN', style: const TextStyle(
                          fontSize: 13,
                          color: BronetColors.textLight,
                          decoration: TextDecoration.lineThrough,
                        )),
                      ]),
                      Text(d['left'] as String, style: const TextStyle(
                        fontSize: 11,
                        color: BronetColors.red,
                        fontWeight: FontWeight.w600,
                      )),
                    ]),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 12),
                      decoration: BoxDecoration(
                        color: BronetColors.forest,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: BronetColors.shadow,
                      ),
                      child: const Text('Book Now', style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
