import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedCat = 0;
  int _selectedSort = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final List<Map<String, String>> _categories = [
    {'emoji': '🌟', 'label': 'All'},
    {'emoji': '✂️', 'label': 'Barbershop'},
    {'emoji': '💇', 'label': 'Salon'},
    {'emoji': '💅', 'label': 'Nails'},
    {'emoji': '🦷', 'label': 'Dental'},
    {'emoji': '✨', 'label': 'Laser'},
    {'emoji': '🚗', 'label': 'Auto'},
    {'emoji': '🧖', 'label': 'Spa'},
    {'emoji': '💪', 'label': 'Gym'},
    {'emoji': '🏥', 'label': 'Medical'},
    {'emoji': '🐾', 'label': 'Pet'},
    {'emoji': '🎨', 'label': 'Tattoo'},
  ];

  final List<String> _sorts = ['Nearest', 'Top Rated', 'Price ↑'];

  final List<Map<String, dynamic>> _providers = [
    {
      'emoji': '✂️',
      'name': 'Qehreman Barbershop',
      'cat': 'Barbershop',
      'catIndex': 1,
      'rating': '4.9',
      'reviews': '318',
      'dist': '0.3 km',
      'from': '15',
      'badge': 'TOP',
      'open': true,
      'color': 0xFFE8F0E4,
    },
    {
      'emoji': '🧖',
      'name': 'Serenity Spa Baku',
      'cat': 'Spa',
      'catIndex': 7,
      'rating': '4.9',
      'reviews': '298',
      'dist': '0.9 km',
      'from': '55',
      'badge': 'TOP',
      'open': true,
      'color': 0xFFEAF4F0,
    },
    {
      'emoji': '💪',
      'name': 'FitPeak Gym',
      'cat': 'Gym',
      'catIndex': 8,
      'rating': '4.7',
      'reviews': '412',
      'dist': '0.5 km',
      'from': '10',
      'badge': 'HOT',
      'open': true,
      'color': 0xFFFFF0E8,
    },
    {
      'emoji': '💇',
      'name': 'Glamour Studio AZ',
      'cat': 'Salon',
      'catIndex': 2,
      'rating': '4.8',
      'reviews': '241',
      'dist': '0.8 km',
      'from': '35',
      'badge': 'HOT',
      'open': true,
      'color': 0xFFF8F0FC,
    },
    {
      'emoji': '💅',
      'name': 'Pearl Nail Studio',
      'cat': 'Nails',
      'catIndex': 3,
      'rating': '4.7',
      'reviews': '189',
      'dist': '1.1 km',
      'from': '18',
      'badge': 'NEW',
      'open': true,
      'color': 0xFFFCF0F8,
    },
    {
      'emoji': '🦷',
      'name': 'SmilePro Dental',
      'cat': 'Dental',
      'catIndex': 4,
      'rating': '4.9',
      'reviews': '156',
      'dist': '1.4 km',
      'from': '25',
      'badge': 'TOP',
      'open': false,
      'color': 0xFFECF4FC,
    },
    {
      'emoji': '✨',
      'name': 'LaserZone Baku',
      'cat': 'Laser',
      'catIndex': 5,
      'rating': '4.8',
      'reviews': '203',
      'dist': '1.8 km',
      'from': '20',
      'badge': 'SALE',
      'open': true,
      'color': 0xFFFCFCE8,
    },
    {
      'emoji': '🚗',
      'name': 'AutoMaster Express',
      'cat': 'Auto',
      'catIndex': 6,
      'rating': '4.6',
      'reviews': '127',
      'dist': '2.1 km',
      'from': '38',
      'badge': '',
      'open': true,
      'color': 0xFFEAECF4,
    },
    {
      'emoji': '🏥',
      'name': 'MedPlus Clinic',
      'cat': 'Medical',
      'catIndex': 9,
      'rating': '4.8',
      'reviews': '176',
      'dist': '1.6 km',
      'from': '30',
      'badge': '',
      'open': true,
      'color': 0xFFE8F4FC,
    },
    {
      'emoji': '🐾',
      'name': 'PawPerfect Grooming',
      'cat': 'Pet',
      'catIndex': 10,
      'rating': '4.7',
      'reviews': '93',
      'dist': '1.2 km',
      'from': '28',
      'badge': 'NEW',
      'open': false,
      'color': 0xFFF4F0E8,
    },
    {
      'emoji': '🎨',
      'name': 'Inkstone Studio',
      'cat': 'Tattoo',
      'catIndex': 11,
      'rating': '4.9',
      'reviews': '141',
      'dist': '2.3 km',
      'from': '60',
      'badge': 'TOP',
      'open': true,
      'color': 0xFFF0E8F4,
    },
  ];

  List<Map<String, dynamic>> get _filtered {
    return _providers.where((p) {
      final matchCat = _selectedCat == 0 || p['catIndex'] == _selectedCat;
      final matchSearch = _searchText.isEmpty ||
          (p['name'] as String).toLowerCase().contains(_searchText.toLowerCase()) ||
          (p['cat'] as String).toLowerCase().contains(_searchText.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategoryFilter(),
            _buildSortBar(),
            Expanded(child: _buildProviderList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      child: Row(
        children: [
          const Text('Explore', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: Color(0xFF2C3528),
            letterSpacing: -0.5,
          )),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: BronetColors.sageBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: BronetColors.sage.withOpacity(0.3)),
            ),
            child: Text('${_filtered.length} places',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: BronetColors.sageDark,
              )),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: BronetColors.bgCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: BronetColors.sage.withOpacity(0.25)),
          boxShadow: BronetColors.shadow,
        ),
        child: Row(children: [
          const Icon(Icons.search_rounded, color: BronetColors.textLight, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchText = v),
              decoration: const InputDecoration(
                hintText: 'Search providers...',
                hintStyle: TextStyle(
                  color: BronetColors.textLight,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              style: const TextStyle(
                fontSize: 13,
                color: BronetColors.textPrimary,
              ),
            ),
          ),
          if (_searchText.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchText = '');
              },
              child: const Icon(Icons.close_rounded,
                color: BronetColors.textLight, size: 16),
            ),
        ]),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        itemCount: _categories.length,
        itemBuilder: (context, i) {
          final selected = _selectedCat == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedCat = i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
              child: Row(children: [
                selected
                  ? ColorFiltered(
                      colorFilter: const ColorFilter.mode(
                        Colors.white, BlendMode.srcIn),
                      child: Text(_categories[i]['emoji']!,
                        style: const TextStyle(fontSize: 12)),
                    )
                  : Text(_categories[i]['emoji']!,
                      style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 5),
                Text(_categories[i]['label']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : BronetColors.textMuted,
                  )),
              ]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 8),
      child: Row(
        children: [
          const Text('Sort by:',
            style: TextStyle(
              fontSize: 12,
              color: BronetColors.textMuted,
              fontWeight: FontWeight.w600,
            )),
          const SizedBox(width: 10),
          ...List.generate(_sorts.length, (i) {
            final selected = _selectedSort == i;
            return GestureDetector(
              onTap: () => setState(() => _selectedSort = i),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: selected
                      ? BronetColors.sage.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected
                        ? BronetColors.sage
                        : BronetColors.sage.withOpacity(0.2),
                  ),
                ),
                child: Text(_sorts[i], style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: selected ? BronetColors.sageDark : BronetColors.textMuted,
                )),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProviderList() {
    final list = _filtered;
    if (list.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🔍', style: TextStyle(fontSize: 48)),
            SizedBox(height: 16),
            Text('No providers found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BronetColors.textMuted,
              )),
            SizedBox(height: 8),
            Text('Try a different category or search',
              style: TextStyle(
                fontSize: 13,
                color: BronetColors.textLight,
              )),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
      itemCount: list.length,
      itemBuilder: (context, i) => _buildProviderCard(list[i]),
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> p) {
    final badge = p['badge'] as String;
    final open = p['open'] as bool;

    Color badgeColor = BronetColors.forest;
    if (badge == 'HOT') badgeColor = BronetColors.red;
    if (badge == 'NEW') badgeColor = BronetColors.green;
    if (badge == 'SALE') badgeColor = BronetColors.amber;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: BronetColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BronetColors.shadow,
      ),
      child: Row(
        children: [
          // Left emoji box
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: Color(p['color'] as int),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(20),
              ),
            ),
            child: Stack(children: [
              Center(child: Text(p['emoji'] as String,
                style: const TextStyle(fontSize: 34))),
              if (badge.isNotEmpty)
                Positioned(
                  top: 7, left: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(badge, style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    )),
                  ),
                ),
            ]),
          ),
          // Right content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(p['cat'] as String, style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: BronetColors.sageDark,
                        letterSpacing: 0.8,
                      )),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: open
                              ? BronetColors.green.withOpacity(0.12)
                              : BronetColors.red.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(open ? 'Open' : 'Closed',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: open ? BronetColors.green : BronetColors.red,
                          )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(p['name'] as String, style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2C3528),
                  ), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 5),
                  Row(children: [
                    const Icon(Icons.star_rounded,
                      size: 12, color: Color(0xFFFFB830)),
                    const SizedBox(width: 3),
                    Text(p['rating'] as String, style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: BronetColors.textPrimary,
                    )),
                    Text(' (${p['reviews']})', style: const TextStyle(
                      fontSize: 11,
                      color: BronetColors.textLight,
                    )),
                    const SizedBox(width: 8),
                    const Icon(Icons.location_on_rounded,
                      size: 11, color: BronetColors.textLight),
                    const SizedBox(width: 2),
                    Text(p['dist'] as String, style: const TextStyle(
                      fontSize: 11,
                      color: BronetColors.textMuted,
                    )),
                  ]),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('from ${p['from']} AZN',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: BronetColors.sageDark,
                        )),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: BronetColors.forest,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Book',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
