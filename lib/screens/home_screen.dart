import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/booking_api.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onExploreRequest;
  const HomeScreen({super.key, this.onExploreRequest});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCat = 0;
  int _livePoints = 2840;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    final pts = await BookingApi.getPoints(AuthService.clientName);
    if (mounted) setState(() => _livePoints = pts);
  }

  String _formatPts(int pts) {
    return pts.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }

  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Sabahınız xeyir';
    if (h < 17) return 'Günortanız xeyir';
    return 'Axşamınız xeyir';
  }

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.content_cut_rounded,       'label': 'Barbershop', 'color': 0xFFE6F0FA},
    {'icon': Icons.face_retouching_natural,   'label': 'Salon',      'color': 0xFFF0EAF8},
    {'icon': Icons.brush_rounded,             'label': 'Nails',      'color': 0xFFFAEAF4},
    {'icon': Icons.medical_services_rounded,  'label': 'Dental',     'color': 0xFFE8F3FD},
    {'icon': Icons.flash_on_rounded,          'label': 'Laser',      'color': 0xFFEFF6FF},
    {'icon': Icons.directions_car_rounded,    'label': 'Auto',       'color': 0xFFEAEEF8},
    {'icon': Icons.spa_rounded,               'label': 'Spa',        'color': 0xFFE8F5F0},
    {'icon': Icons.fitness_center_rounded,    'label': 'Gym',        'color': 0xFFFFF4E8},
    {'icon': Icons.local_hospital_rounded,    'label': 'Medical',    'color': 0xFFE6F2FB},
    {'icon': Icons.pets_rounded,              'label': 'Pet',        'color': 0xFFF5F2E8},
    {'icon': Icons.palette_rounded,           'label': 'Tattoo',     'color': 0xFFF2E8F5},
  ];

  final List<Map<String, dynamic>> _deals = [
    {'emoji': '✂️', 'name': 'Klassik Saç Kəsimi', 'old': '25', 'new': '15', 'off': '40%', 'color': 0xFFE6F0FA, 'provider': 'Qehreman Barbershop'},
    {'emoji': '💅', 'name': 'Gel Manikür',         'old': '35', 'new': '20', 'off': '43%', 'color': 0xFFF2E8F8, 'provider': 'Pearl Nail Studio'},
    {'emoji': '🧖', 'name': 'Spa Masajı',           'old': '80', 'new': '50', 'off': '37%', 'color': 0xFFE8F5F0, 'provider': 'Serenity Spa Baku'},
  ];

  final List<Map<String, dynamic>> _providers = [
    {'emoji': '✂️', 'name': 'Qehreman Barbershop', 'cat': 'Barbershop', 'rating': '4.9', 'dist': '0.3 km', 'from': '15', 'color': 0xFFE6F0FA},
    {'emoji': '🧖', 'name': 'Serenity Spa Baku',   'cat': 'Spa',        'rating': '4.9', 'dist': '0.9 km', 'from': '55', 'color': 0xFFE8F5F0},
    {'emoji': '🦷', 'name': 'SmilePro Dental',     'cat': 'Dental',     'rating': '4.8', 'dist': '1.4 km', 'from': '25', 'color': 0xFFE8F3FD},
  ];

  void _showBookingSheet({
    required String emoji,
    required String name,
    required String provider,
    required String price,
    String specialist = 'Dr. Nigar H.',
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _BookingSheetContent(
        emoji: emoji,
        name: name,
        provider: provider,
        price: price,
        onConfirmed: (String date, String time) async {
          // Fire-and-forget POST to local server
          final result = await BookingApi.createBooking(
            clientName: 'Ismayil M.',
            service: name,
            provider: provider,
            specialist: specialist,
            date: date,
            time: time,
            price: price,
          );
          if (!mounted) return;
          final id = result?['id'] ?? '';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                id.isNotEmpty
                    ? 'Rezervasiya göndərildi! $id — təsdiq gözlənilir 📲'
                    : '$name rezerv edildi! 🎉',
              ),
              backgroundColor: BronetColors.forest,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildCategories(),
              _buildPromoBanner(),
              _buildSectionTitle('Sürətli Endirimlər 🔥'),
              _buildDealsRow(),
              _buildSectionTitle('Ən Yaxşı Qiymətləndirilmiş ⭐'),
              _buildProvidersRow(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 22),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [BronetColors.forest, BronetColors.forestDeep],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // Top bar: logo + actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Text('B', style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    )),
                  ),
                ),
                const SizedBox(width: 10),
                RichText(text: TextSpan(children: [
                  const TextSpan(text: "BRON'", style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  )),
                  TextSpan(text: "ET", style: TextStyle(
                    color: BronetColors.sage,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  )),
                ])),
              ]),
              Row(children: [
                Stack(clipBehavior: Clip.none, children: [
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Icon(Icons.notifications_rounded,
                        color: Colors.white, size: 20),
                    ),
                  ),
                  Positioned(
                    top: -2, right: -2,
                    child: Container(
                      width: 17, height: 17,
                      decoration: BoxDecoration(
                        color: BronetColors.red,
                        shape: BoxShape.circle,
                        border: Border.all(color: BronetColors.forest, width: 2),
                      ),
                      child: const Center(
                        child: Text('3', style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                        )),
                      ),
                    ),
                  ),
                ]),
                const SizedBox(width: 8),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(
                    color: BronetColors.sage.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2), width: 1.5),
                  ),
                  child: const Center(
                    child: Icon(Icons.person_rounded,
                      color: Colors.white, size: 20),
                  ),
                ),
              ]),
            ],
          ),
          const SizedBox(height: 18),
          // Bottom row: greeting + points
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('$_greeting, ${AuthService.firstName} 👋', style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                )),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.location_on_rounded,
                    color: Colors.white.withOpacity(0.5), size: 13),
                  const SizedBox(width: 4),
                  Text('Bakı, Azərbaycan', style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 12,
                  )),
                ]),
              ]),
              // Loyalty points badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('⭐', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 5),
                  Text('${_formatPts(_livePoints)} pts', style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  )),
                ]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: widget.onExploreRequest,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: BronetColors.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BronetColors.sage.withOpacity(0.3)),
            boxShadow: BronetColors.shadow,
          ),
          child: Row(children: [
            Icon(Icons.search_rounded, color: BronetColors.textLight, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Xidmət axtarın...',
                style: TextStyle(color: BronetColors.textLight, fontSize: 14),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: BronetColors.sageBg,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(Icons.tune_rounded, color: BronetColors.sageDark, size: 16),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 82,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final selected = _selectedCat == i;
          final bgColor = selected
              ? BronetColors.forest
              : Color(_categories[i]['color'] as int);
          final iconColor = selected ? Colors.white : BronetColors.forest;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCat = i);
              widget.onExploreRequest?.call();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: BronetColors.shadow,
                    ),
                    child: Center(
                      child: Icon(
                        _categories[i]['icon'] as IconData,
                        color: iconColor,
                        size: 24,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _categories[i]['label']!,
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: selected ? BronetColors.forest : BronetColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPromoBanner() {
    return GestureDetector(
      onTap: () => _showBookingSheet(
        emoji: '✂️',
        name: 'Klassik Saç Kəsimi',
        provider: 'Qehreman Barbershop',
        price: '15',
      ),
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 16, 18, 8),
        height: 148,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A6CC5), Color(0xFF1155A8)],
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: BronetColors.shadowStrong,
        ),
        child: Stack(children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: CustomPaint(painter: _DotsPainter()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('SÜRƏTLI ENDİRİM', style: TextStyle(
                  color: Color(0xFF96C3E3),
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                )),
                const Text('40% endirim\nbütün barber xidmətlərindən', style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Yalnız bu gün — rezerv edin',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 11,
                      )),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF68A8D4),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Text('Rezerv et', style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: BronetColors.textPrimary,
            letterSpacing: -0.2,
          )),
          GestureDetector(
            onTap: widget.onExploreRequest,
            child: Text('Hamısına bax', style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: BronetColors.sageDark,
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildDealsRow() {
    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _deals.length,
        itemBuilder: (context, i) {
          final d = _deals[i];
          return GestureDetector(
            onTap: () => _showBookingSheet(
              emoji: d['emoji'] as String,
              name: d['name'] as String,
              provider: d['provider'] as String,
              price: d['new'] as String,
            ),
            child: Container(
              width: 155,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: BronetColors.bgCard,
                borderRadius: BorderRadius.circular(18),
                boxShadow: BronetColors.shadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 95,
                    decoration: BoxDecoration(
                      color: Color(d['color'] as int),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                    ),
                    child: Stack(children: [
                      Center(child: Text(d['emoji'] as String,
                        style: const TextStyle(fontSize: 36))),
                      Positioned(
                        top: 8, left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: BronetColors.red,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text('-${d['off']}', style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          )),
                        ),
                      ),
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(d['name'] as String, style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: BronetColors.textPrimary,
                        )),
                        const SizedBox(height: 5),
                        Row(children: [
                          Text('${d['new']} AZN', style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            color: BronetColors.forest,
                          )),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text('${d['old']} AZN',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: BronetColors.textLight,
                                decoration: TextDecoration.lineThrough,
                              )),
                          ),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProvidersRow() {
    return SizedBox(
      height: 235,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _providers.length,
        itemBuilder: (context, i) {
          final p = _providers[i];
          return Container(
            width: 185,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: BronetColors.bgCard,
              borderRadius: BorderRadius.circular(20),
              boxShadow: BronetColors.shadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 108,
                  decoration: BoxDecoration(
                    color: Color(p['color'] as int),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Stack(children: [
                    Center(child: Text(p['emoji'] as String,
                      style: const TextStyle(fontSize: 40))),
                    Positioned(
                      top: 8, right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(children: [
                          const Icon(Icons.star_rounded, size: 10, color: Color(0xFFFFB830)),
                          const SizedBox(width: 3),
                          Text(p['rating'] as String, style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: BronetColors.textPrimary,
                          )),
                        ]),
                      ),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(11),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['cat'] as String, style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: BronetColors.sageDark,
                        letterSpacing: 0.8,
                      )),
                      const SizedBox(height: 3),
                      Text(p['name'] as String, style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: BronetColors.textPrimary,
                      ), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 5),
                      Row(children: [
                        Icon(Icons.location_on_rounded, size: 11, color: BronetColors.textLight),
                        const SizedBox(width: 2),
                        Text(p['dist'] as String, style: TextStyle(
                          fontSize: 11, color: BronetColors.textMuted)),
                        const Spacer(),
                        Text('${p['from']} AZN', style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: BronetColors.sageDark,
                        )),
                      ]),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () => _showBookingSheet(
                          emoji: p['emoji'] as String,
                          name: p['name'] as String,
                          provider: p['cat'] as String,
                          price: p['from'] as String,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: BronetColors.forest,
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Center(
                            child: Text('Rezerv Et', style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ─── Booking Sheet with date + time selection ─────────────────
class _BookingSheetContent extends StatefulWidget {
  final String emoji, name, provider, price;
  final void Function(String date, String time) onConfirmed;

  const _BookingSheetContent({
    required this.emoji,
    required this.name,
    required this.provider,
    required this.price,
    required this.onConfirmed,
  });

  @override
  State<_BookingSheetContent> createState() => _BookingSheetContentState();
}

class _BookingSheetContentState extends State<_BookingSheetContent> {
  int _selectedDate = -1;
  int _selectedTime = -1;

  final List<String> _dates = _generateDates();
  final List<String> _times = [
    '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '13:00', '13:30', '14:00', '14:30', '15:00', '16:00',
  ];
  // Simulate a few booked slots
  final Set<int> _bookedSlots = {2, 5, 9};

  static List<String> _generateDates() {
    final days = ['B.E', 'Ç.A', 'Çər', 'C.A', 'Cüm', 'Şnb', 'Baz'];
    final now = DateTime.now();
    return List.generate(7, (i) {
      final d = now.add(Duration(days: i));
      final label = i == 0 ? 'Bu gün' : i == 1 ? 'Sabah' : days[d.weekday - 1];
      return '$label\n${d.day}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = _selectedDate >= 0 && _selectedTime >= 0;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: BronetColors.bgMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Service header
            Row(children: [
              Text(widget.emoji, style: const TextStyle(fontSize: 38)),
              const SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name, style: TextStyle(
                    fontSize: 17, fontWeight: FontWeight.w800,
                    color: BronetColors.textPrimary,
                  )),
                  Text(widget.provider, style: TextStyle(
                    fontSize: 13, color: BronetColors.textMuted,
                  )),
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: BronetColors.sageBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text('${widget.price} AZN', style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w900,
                  color: BronetColors.forest,
                )),
              ),
            ]),
            const SizedBox(height: 22),

            // Date selection
            Text('Tarix Seçin', style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w800,
              color: BronetColors.textPrimary,
            )),
            const SizedBox(height: 10),
            SizedBox(
              height: 62,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                itemBuilder: (_, i) {
                  final selected = _selectedDate == i;
                  final parts = _dates[i].split('\n');
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedDate = i;
                      _selectedTime = -1;
                    }),
                    child: Container(
                      width: 58,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: selected ? BronetColors.forest : BronetColors.bgSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selected ? BronetColors.forest : Colors.transparent,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(parts[0], style: TextStyle(
                            fontSize: 9, fontWeight: FontWeight.w700,
                            color: selected ? Colors.white.withOpacity(0.7) : BronetColors.textMuted,
                          )),
                          Text(parts[1], style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w900,
                            color: selected ? Colors.white : BronetColors.textPrimary,
                          )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 18),

            // Time selection
            Text('Vaxt Seçin', style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w800,
              color: BronetColors.textPrimary,
            )),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(_times.length, (i) {
                final selected = _selectedTime == i;
                final booked = _bookedSlots.contains(i);
                return GestureDetector(
                  onTap: booked || _selectedDate < 0
                      ? null
                      : () => setState(() => _selectedTime = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: booked
                          ? BronetColors.bgMuted
                          : selected
                              ? BronetColors.forest
                              : BronetColors.bgSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? BronetColors.forest : Colors.transparent,
                      ),
                    ),
                    child: Text(_times[i], style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: booked
                          ? BronetColors.textLight
                          : selected
                              ? Colors.white
                              : BronetColors.textPrimary,
                      decoration: booked ? TextDecoration.lineThrough : null,
                    )),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canConfirm
                    ? () {
                        final dateStr = _dates[_selectedDate].replaceAll('\n', ' ');
                        final timeStr = _times[_selectedTime];
                        Navigator.pop(context);
                        widget.onConfirmed(dateStr, timeStr);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BronetColors.forest,
                  disabledBackgroundColor: BronetColors.bgMuted,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: Text(
                  canConfirm ? 'Rezervasiyanı Təsdiqlə ✓' : 'Tarix və Vaxt Seçin',
                  style: TextStyle(
                    color: canConfirm ? Colors.white : BronetColors.textLight,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0x1E68A8D4)
      ..style = PaintingStyle.fill;
    const spacing = 16.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
