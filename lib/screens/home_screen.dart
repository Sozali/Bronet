import 'package:flutter/material.dart';
import '../theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCat = 0;

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.content_cut_rounded,       'label': 'Barbershop', 'color': 0xFFE8F0E4},
    {'icon': Icons.face_retouching_natural,   'label': 'Salon',      'color': 0xFFF8F0FC},
    {'icon': Icons.brush_rounded,             'label': 'Nails',      'color': 0xFFFCF0F8},
    {'icon': Icons.medical_services_rounded,  'label': 'Dental',     'color': 0xFFECF4FC},
    {'icon': Icons.flash_on_rounded,          'label': 'Laser',      'color': 0xFFFCFCE8},
    {'icon': Icons.directions_car_rounded,    'label': 'Auto',       'color': 0xFFEAECF4},
    {'icon': Icons.spa_rounded,               'label': 'Spa',        'color': 0xFFEAF4F0},
    {'icon': Icons.fitness_center_rounded,    'label': 'Gym',        'color': 0xFFFFF0E8},
    {'icon': Icons.local_hospital_rounded,    'label': 'Medical',    'color': 0xFFE8F4FC},
    {'icon': Icons.pets_rounded,              'label': 'Pet',        'color': 0xFFF4F0E8},
    {'icon': Icons.palette_rounded,           'label': 'Tattoo',     'color': 0xFFF0E8F4},
  ];

  final List<Map<String, dynamic>> _deals = [
    {'emoji': '✂️', 'name': 'Classic Haircut', 'old': '25', 'new': '15', 'off': '40%', 'color': 0xFFE8F0E4},
    {'emoji': '💅', 'name': 'Gel Manicure', 'old': '35', 'new': '20', 'off': '43%', 'color': 0xFFF0ECF8},
    {'emoji': '🧖', 'name': 'Spa Massage', 'old': '80', 'new': '50', 'off': '37%', 'color': 0xFFEAF4F0},
  ];

  final List<Map<String, dynamic>> _providers = [
    {'emoji': '✂️', 'name': 'Qehreman Barbershop', 'cat': 'Barbershop', 'rating': '4.9', 'dist': '0.3 km', 'from': '15', 'color': 0xFFE8F0E4},
    {'emoji': '🧖', 'name': 'Serenity Spa Baku', 'cat': 'Spa', 'rating': '4.9', 'dist': '0.9 km', 'from': '55', 'color': 0xFFEAF4F0},
    {'emoji': '🦷', 'name': 'SmilePro Dental', 'cat': 'Dental', 'rating': '4.8', 'dist': '1.4 km', 'from': '25', 'color': 0xFFECF4FC},
  ];

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
              _buildSectionTitle('Flash Deals'),
              _buildDealsRow(),
              _buildSectionTitle('Top Rated'),
              _buildProvidersRow(),
              const SizedBox(height: 24),
            ],
          ),
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
          Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: BronetColors.forest,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Center(
                child: Text('B', style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                )),
              ),
            ),
            const SizedBox(width: 9),
            RichText(text: const TextSpan(children: [
              TextSpan(text: "BRON'", style: TextStyle(
                color: Color(0xFF2C3528),
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              )),
              TextSpan(text: "ET", style: TextStyle(
                color: Color(0xFFA8B6A1),
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
              )),
            ])),
          ]),
          Row(children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: BronetColors.bgCard,
                borderRadius: BorderRadius.circular(11),
                boxShadow: BronetColors.shadow,
              ),
              child: const Center(
                child: Icon(Icons.notifications_rounded, size: 18),
              ),
            ),
            const SizedBox(width: 9),
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: BronetColors.forest,
                borderRadius: BorderRadius.circular(19),
              ),
              child: const Center(
                child: Icon(Icons.person_rounded, color: Colors.white, size: 18),
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 16),
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
              'Search service, clinic, barber...',
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
          final iconColor = selected
              ? Colors.white
              : BronetColors.forest;
          return GestureDetector(
            onTap: () => setState(() => _selectedCat = i),
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
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      height: 148,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2C3528), Color(0xFF1E2A1A)],
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
              const Text('FLASH SALE', style: TextStyle(
                color: Color(0xFFA8B6A1),
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              )),
              const Text('40% off\nall barber services', style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                height: 1.2,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Today only - 06:42 left',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 11,
                    )),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA8B6A1),
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Text('Book now', style: TextStyle(
                      color: Color(0xFF2C3528),
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
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF2C3528),
            letterSpacing: -0.2,
          )),
          Text('See all', style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: BronetColors.sageDark,
          )),
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
          return Container(
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
                      Text(d['name'] as String, style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2C3528),
                      )),
                      const SizedBox(height: 5),
                      Row(children: [
                        Text('${d['new']} AZN', style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: BronetColors.forest,
                        )),
                        const SizedBox(width: 6),
                        Text('${d['old']} AZN', style: TextStyle(
                          fontSize: 11,
                          color: BronetColors.textLight,
                          decoration: TextDecoration.lineThrough,
                        )),
                      ]),
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

  Widget _buildProvidersRow() {
    return SizedBox(
      height: 225,
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
                          Text(p['rating'] as String, style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF2C3528),
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
                      Text(p['name'] as String, style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF2C3528),
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
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: BronetColors.forest,
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Center(
                          child: Text('Book now', style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          )),
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

class _DotsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFA8B6A1).withOpacity(0.12)
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
