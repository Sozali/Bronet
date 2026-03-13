// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
// ignore: avoid_web_libraries_in_flutter
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import 'provider_services_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedCat = 0;
  int _selectedSort = 0;
  bool _showMap = false;
  static bool _mapRegistered = false;

  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  final List<Map<String, String>> _categories = [
    {'emoji': '🌟', 'label': 'Hamısı'},
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

  final List<String> _sorts = ['Ən yaxın', 'Ən yaxşı', 'Qiymət ↑'];

  final List<Map<String, dynamic>> _providers = [
    // ── Barbershop (catIndex: 1) ──
    {'emoji': '✂️', 'name': 'Qehreman Barbershop', 'cat': 'Barbershop', 'catIndex': 1, 'rating': '4.9', 'reviews': '318', 'dist': '0.3 km', 'from': '15', 'badge': 'TOP',  'open': true,  'color': 0xFFE6F0FA, 'lat': 40.4065, 'lng': 49.8640},
    {'emoji': '✂️', 'name': 'Royal Cuts Baku',     'cat': 'Barbershop', 'catIndex': 1, 'rating': '4.8', 'reviews': '210', 'dist': '0.8 km', 'from': '12', 'badge': 'HOT',  'open': true,  'color': 0xFFD4EAFB, 'lat': 40.4020, 'lng': 49.8600},
    {'emoji': '✂️', 'name': 'Urban Fade Studio',   'cat': 'Barbershop', 'catIndex': 1, 'rating': '4.7', 'reviews': '156', 'dist': '1.2 km', 'from': '10', 'badge': 'NEW',  'open': true,  'color': 0xFFDFF0FA, 'lat': 40.4190, 'lng': 49.8710},
    // ── Salon (catIndex: 2) ──
    {'emoji': '💇', 'name': 'Glamour Studio AZ',   'cat': 'Salon',      'catIndex': 2, 'rating': '4.8', 'reviews': '241', 'dist': '0.8 km', 'from': '35', 'badge': 'HOT',  'open': true,  'color': 0xFFF8F0FC, 'lat': 40.4000, 'lng': 49.8750},
    {'emoji': '💇', 'name': 'Glam & Go Salon',     'cat': 'Salon',      'catIndex': 2, 'rating': '4.8', 'reviews': '193', 'dist': '0.9 km', 'from': '25', 'badge': 'HOT',  'open': true,  'color': 0xFFEEF0FB, 'lat': 40.4170, 'lng': 49.8600},
    {'emoji': '💇', 'name': 'Silk & Shine Salon',  'cat': 'Salon',      'catIndex': 2, 'rating': '4.6', 'reviews': '88',  'dist': '2.1 km', 'from': '20', 'badge': '',     'open': true,  'color': 0xFFF4F0FC, 'lat': 40.3920, 'lng': 49.8520},
    // ── Nails (catIndex: 3) ──
    {'emoji': '💅', 'name': 'Pearl Nail Studio',   'cat': 'Nails',      'catIndex': 3, 'rating': '4.7', 'reviews': '189', 'dist': '1.1 km', 'from': '18', 'badge': 'NEW',  'open': true,  'color': 0xFFFCF0F8, 'lat': 40.4190, 'lng': 49.8770},
    {'emoji': '💅', 'name': 'Pink Polish Studio',  'cat': 'Nails',      'catIndex': 3, 'rating': '4.9', 'reviews': '241', 'dist': '0.6 km', 'from': '18', 'badge': 'TOP',  'open': true,  'color': 0xFFFAEAF4, 'lat': 40.4050, 'lng': 49.8620},
    {'emoji': '💅', 'name': 'Luxe Nail Bar',       'cat': 'Nails',      'catIndex': 3, 'rating': '4.7', 'reviews': '132', 'dist': '1.8 km', 'from': '22', 'badge': '',     'open': false, 'color': 0xFFF8E8F2, 'lat': 40.3950, 'lng': 49.8850},
    // ── Dental (catIndex: 4) ──
    {'emoji': '🦷', 'name': 'SmilePro Dental',     'cat': 'Dental',     'catIndex': 4, 'rating': '4.9', 'reviews': '156', 'dist': '1.4 km', 'from': '25', 'badge': 'TOP',  'open': true, 'color': 0xFFECF4FC, 'lat': 40.4230, 'lng': 49.8680},
    {'emoji': '🦷', 'name': 'Denta Clinic Baku',   'cat': 'Dental',     'catIndex': 4, 'rating': '4.8', 'reviews': '198', 'dist': '0.9 km', 'from': '30', 'badge': 'HOT',  'open': true,  'color': 0xFFE8F3FD, 'lat': 40.4010, 'lng': 49.8760},
    {'emoji': '🦷', 'name': 'WhiteSmile Center',   'cat': 'Dental',     'catIndex': 4, 'rating': '4.6', 'reviews': '144', 'dist': '2.3 km', 'from': '25', 'badge': 'NEW',  'open': true,  'color': 0xFFD4EAFB, 'lat': 40.3880, 'lng': 49.8500},
    // ── Laser (catIndex: 5) ──
    {'emoji': '✨', 'name': 'LaserZone Baku',       'cat': 'Laser',      'catIndex': 5, 'rating': '4.8', 'reviews': '203', 'dist': '1.8 km', 'from': '20', 'badge': 'SALE', 'open': true,  'color': 0xFFFCFCE8, 'lat': 40.4260, 'lng': 49.8800},
    {'emoji': '✨', 'name': 'SmoothSkin Clinic',    'cat': 'Laser',      'catIndex': 5, 'rating': '4.8', 'reviews': '167', 'dist': '1.4 km', 'from': '60', 'badge': 'TOP',  'open': true,  'color': 0xFFEFF6FF, 'lat': 40.4220, 'lng': 49.8560},
    {'emoji': '✨', 'name': 'Glow Laser Baku',      'cat': 'Laser',      'catIndex': 5, 'rating': '4.7', 'reviews': '98',  'dist': '2.8 km', 'from': '55', 'badge': '',     'open': true,  'color': 0xFFE8F0FB, 'lat': 40.3840, 'lng': 49.8550},
    // ── Auto (catIndex: 6) ──
    {'emoji': '🚗', 'name': 'AutoMaster Express',  'cat': 'Auto',       'catIndex': 6, 'rating': '4.6', 'reviews': '127', 'dist': '2.1 km', 'from': '38', 'badge': '',     'open': true,  'color': 0xFFEAECF4, 'lat': 40.4300, 'lng': 49.8500},
    {'emoji': '🚗', 'name': 'CarCare Express',      'cat': 'Auto',       'catIndex': 6, 'rating': '4.6', 'reviews': '189', 'dist': '1.1 km', 'from': '35', 'badge': 'HOT',  'open': true,  'color': 0xFFEAEEF8, 'lat': 40.4180, 'lng': 49.8800},
    {'emoji': '🚗', 'name': 'Elite Auto Service',  'cat': 'Auto',       'catIndex': 6, 'rating': '4.5', 'reviews': '112', 'dist': '3.2 km', 'from': '40', 'badge': '',     'open': false, 'color': 0xFFE4EAF8, 'lat': 40.4370, 'lng': 49.8360},
    // ── Spa (catIndex: 7) ──
    {'emoji': '🧖', 'name': 'Serenity Spa Baku',   'cat': 'Spa',        'catIndex': 7, 'rating': '4.9', 'reviews': '298', 'dist': '0.9 km', 'from': '55', 'badge': 'TOP',  'open': true,  'color': 0xFFE8F3FC, 'lat': 40.4010, 'lng': 49.8680},
    {'emoji': '🧖', 'name': 'Zen Garden Spa',       'cat': 'Spa',        'catIndex': 7, 'rating': '4.9', 'reviews': '278', 'dist': '0.7 km', 'from': '45', 'badge': 'TOP',  'open': true,  'color': 0xFFE8F5F0, 'lat': 40.4060, 'lng': 49.8750},
    {'emoji': '🧖', 'name': 'BlissPoint Wellness',  'cat': 'Spa',        'catIndex': 7, 'rating': '4.7', 'reviews': '154', 'dist': '1.9 km', 'from': '40', 'badge': '',     'open': true,  'color': 0xFFEEF8F4, 'lat': 40.3920, 'lng': 49.8810},
    // ── Gym (catIndex: 8) ──
    {'emoji': '💪', 'name': 'FitPeak Gym',          'cat': 'Gym',        'catIndex': 8, 'rating': '4.7', 'reviews': '412', 'dist': '0.5 km', 'from': '10', 'badge': 'HOT',  'open': true,  'color': 0xFFFFF0E8, 'lat': 40.4050, 'lng': 49.8710},
    {'emoji': '💪', 'name': 'PowerHouse Gym',        'cat': 'Gym',        'catIndex': 8, 'rating': '4.7', 'reviews': '312', 'dist': '0.5 km', 'from': '30', 'badge': 'HOT',  'open': true,  'color': 0xFFFFF4E8, 'lat': 40.4055, 'lng': 49.8740},
    {'emoji': '💪', 'name': 'ActiveLife Studio',    'cat': 'Gym',        'catIndex': 8, 'rating': '4.5', 'reviews': '167', 'dist': '2.4 km', 'from': '25', 'badge': 'NEW',  'open': true,  'color': 0xFFFAF0E0, 'lat': 40.4310, 'lng': 49.8470},
    // ── Medical (catIndex: 9) ──
    {'emoji': '🏥', 'name': 'MedPlus Clinic',       'cat': 'Medical',    'catIndex': 9, 'rating': '4.8', 'reviews': '176', 'dist': '1.6 km', 'from': '30', 'badge': '',     'open': true,  'color': 0xFFE8F4FC, 'lat': 40.4240, 'lng': 49.8740},
    {'emoji': '🏥', 'name': 'HealthFirst Center',   'cat': 'Medical',    'catIndex': 9, 'rating': '4.8', 'reviews': '223', 'dist': '1.0 km', 'from': '50', 'badge': 'TOP',  'open': true,  'color': 0xFFE6F2FB, 'lat': 40.4010, 'lng': 49.8820},
    {'emoji': '🏥', 'name': 'CityMed Clinic',       'cat': 'Medical',    'catIndex': 9, 'rating': '4.6', 'reviews': '178', 'dist': '2.2 km', 'from': '40', 'badge': '',     'open': true,  'color': 0xFFDFF0FA, 'lat': 40.3870, 'lng': 49.8860},
    // ── Pet (catIndex: 10) ──
    {'emoji': '🐾', 'name': 'PawPerfect Grooming', 'cat': 'Pet',        'catIndex': 10, 'rating': '4.7', 'reviews': '93',  'dist': '1.2 km', 'from': '28', 'badge': 'NEW',  'open': false, 'color': 0xFFF4F0E8, 'lat': 40.4195, 'lng': 49.8750},
    {'emoji': '🐾', 'name': 'Happy Paws Clinic',   'cat': 'Pet',        'catIndex': 10, 'rating': '4.8', 'reviews': '145', 'dist': '1.3 km', 'from': '35', 'badge': 'HOT',  'open': true,  'color': 0xFFF5F2E8, 'lat': 40.3970, 'lng': 49.8820},
    {'emoji': '🐾', 'name': 'PetVet Baku',          'cat': 'Pet',        'catIndex': 10, 'rating': '4.6', 'reviews': '98',  'dist': '3.0 km', 'from': '30', 'badge': '',     'open': true,  'color': 0xFFF2EEE0, 'lat': 40.4360, 'lng': 49.8320},
    // ── Tattoo (catIndex: 11) ──
    {'emoji': '🎨', 'name': 'Inkstone Studio',      'cat': 'Tattoo',     'catIndex': 11, 'rating': '4.9', 'reviews': '141', 'dist': '2.3 km', 'from': '60', 'badge': 'TOP',  'open': true,  'color': 0xFFF0E8F4, 'lat': 40.3880, 'lng': 49.8580},
    {'emoji': '🎨', 'name': 'Black Needle Studio',  'cat': 'Tattoo',     'catIndex': 11, 'rating': '4.8', 'reviews': '187', 'dist': '1.1 km', 'from': '80', 'badge': 'TOP',  'open': true,  'color': 0xFFEEE4F4, 'lat': 40.4175, 'lng': 49.8660},
    {'emoji': '🎨', 'name': 'ArtSkin Tattoo',       'cat': 'Tattoo',     'catIndex': 11, 'rating': '4.7', 'reviews': '143', 'dist': '2.5 km', 'from': '70', 'badge': '',     'open': true,  'color': 0xFFEAE0F0, 'lat': 40.3860, 'lng': 49.8470},
  ];

  List<Map<String, dynamic>> get _filtered {
    var list = _providers.where((p) {
      final matchCat = _selectedCat == 0 || p['catIndex'] == _selectedCat;
      final matchSearch = _searchText.isEmpty ||
          (p['name'] as String).toLowerCase().contains(_searchText.toLowerCase()) ||
          (p['cat'] as String).toLowerCase().contains(_searchText.toLowerCase());
      return matchCat && matchSearch;
    }).toList();

    switch (_selectedSort) {
      case 0:
        list.sort((a, b) =>
          double.parse((a['dist'] as String).split(' ')[0])
            .compareTo(double.parse((b['dist'] as String).split(' ')[0])));
        break;
      case 1:
        list.sort((a, b) =>
          double.parse(b['rating'] as String)
            .compareTo(double.parse(a['rating'] as String)));
        break;
      case 2:
        list.sort((a, b) =>
          int.parse(a['from'] as String)
            .compareTo(int.parse(b['from'] as String)));
        break;
    }
    return list;
  }

  // ── Map HTML Builder ──────────────────────────────────────────────
  String _buildMapHtml() {
    final filtered = _filtered;
    final markersParts = filtered.map((p) {
      final name = (p['name'] as String).replaceAll("'", "\\'");
      final cat  = (p['cat']  as String).replaceAll("'", "\\'");
      final em   = p['emoji'] as String;
      return '{lat:${p['lat']},lng:${p['lng']},name:"$name",cat:"$cat",emoji:"$em",'
             'rating:"${p['rating']}",from:"${p['from']}",open:${p['open']}}';
    }).join(',');

    return '''<!DOCTYPE html><html><head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"/>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<style>
*{margin:0;padding:0;box-sizing:border-box;}
html,body,#map{width:100%;height:100%;font-family:sans-serif;}
.pm{width:38px;height:38px;border-radius:50%;display:flex;align-items:center;justify-content:center;
    font-size:17px;box-shadow:0 2px 10px rgba(0,0,0,0.25);border:2.5px solid #1A6CC5;background:#fff;cursor:pointer;}
.pm.closed{border-color:#999;opacity:.7;}
.leaflet-popup-content-wrapper{border-radius:14px;box-shadow:0 4px 20px rgba(0,0,0,.15);}
.leaflet-popup-content{margin:12px 14px;font-size:13px;line-height:1.5;}
.pp-name{font-weight:800;font-size:14px;margin-bottom:2px;}
.pp-cat{color:#78A0C0;font-size:11px;margin-bottom:4px;}
.pp-row{display:flex;align-items:center;gap:6px;margin-top:3px;}
.pp-badge{padding:2px 8px;border-radius:6px;font-size:11px;font-weight:700;}
.open-b{background:#E8F8F0;color:#3DAD7F;}
.closed-b{background:#FEE;color:#E53935;}
</style>
</head><body>
<div id="map"></div>
<script>
var map=L.map('map',{zoomControl:true,attributionControl:false}).setView([40.4093,49.8671],14);
L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);
L.control.attribution({prefix:'© OpenStreetMap'}).addTo(map);
var data=[$markersParts];
data.forEach(function(p){
  var ic=L.divIcon({html:'<div class="pm'+(p.open?'':' closed')+'">'+p.emoji+'</div>',
    className:'',iconSize:[38,38],iconAnchor:[19,19],popupAnchor:[0,-22]});
  L.marker([p.lat,p.lng],{icon:ic}).addTo(map).bindPopup(
    '<div class="pp-name">'+p.emoji+' '+p.name+'</div>'
    +'<div class="pp-cat">'+p.cat+'</div>'
    +'<div class="pp-row">⭐ '+p.rating+' &nbsp;·&nbsp; <b style="color:#1A6CC5">from '+p.from+' AZN</b></div>'
    +'<div class="pp-row"><span class="pp-badge '+(p.open?'open-b':'closed-b')+'">'+(p.open?'Open':'Closed')+'</span></div>'
  );
});
</script></body></html>''';
  }

  void _ensureMapRegistered() {
    if (_mapRegistered) return;
    _mapRegistered = true;
    ui_web.platformViewRegistry.registerViewFactory('bronet-baku-map', (int id) {
      final el = html.IFrameElement()
        ..srcdoc = _buildMapHtml()
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = '100%';
      return el;
    });
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
            if (!_showMap) _buildSortBar(),
            Expanded(child: _showMap ? _buildMapView() : _buildProviderList()),
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
          const Text('Kəşf Et', style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w900,
            color: BronetColors.textPrimary, letterSpacing: -0.5,
          )),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: BronetColors.sageBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: BronetColors.sage.withOpacity(0.3)),
            ),
            child: Text('${_filtered.length} yer',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: BronetColors.sageDark)),
          ),
          const Spacer(),
          // Map / List toggle
          GestureDetector(
            onTap: () {
              if (!_showMap) _ensureMapRegistered();
              setState(() => _showMap = !_showMap);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: _showMap ? BronetColors.forest : BronetColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _showMap ? BronetColors.forest : BronetColors.sage.withOpacity(0.3)),
                boxShadow: BronetColors.shadow,
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(
                  _showMap ? Icons.list_rounded : Icons.map_rounded,
                  size: 16,
                  color: _showMap ? Colors.white : BronetColors.sageDark,
                ),
                const SizedBox(width: 5),
                Text(_showMap ? 'Siyahı' : 'Xəritə',
                  style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: _showMap ? Colors.white : BronetColors.sageDark,
                  )),
              ]),
            ),
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
          Icon(Icons.search_rounded, color: BronetColors.textLight, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              autofocus: false,
              onChanged: (v) => setState(() => _searchText = v),
              decoration: InputDecoration(
                hintText: 'Xidmət axtarın...',
                hintStyle: TextStyle(color: BronetColors.textLight, fontSize: 13),
                border: InputBorder.none, isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
              style: TextStyle(fontSize: 13, color: BronetColors.textPrimary),
            ),
          ),
          if (_searchText.isNotEmpty)
            GestureDetector(
              onTap: () { _searchController.clear(); setState(() => _searchText = ''); },
              child: Icon(Icons.close_rounded, color: BronetColors.textLight, size: 16),
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
                  color: selected ? BronetColors.forest : BronetColors.sage.withOpacity(0.25)),
                boxShadow: selected ? BronetColors.shadow : [],
              ),
              child: Row(children: [
                Text(_categories[i]['emoji']!, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 5),
                Text(_categories[i]['label']!,
                  style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
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
      child: Row(children: [
        Text('Sıralama:', style: TextStyle(
          fontSize: 12, color: BronetColors.textMuted, fontWeight: FontWeight.w600)),
        const SizedBox(width: 10),
        ...List.generate(_sorts.length, (i) {
          final selected = _selectedSort == i;
          return GestureDetector(
            onTap: () => setState(() => _selectedSort = i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? BronetColors.sage.withOpacity(0.15) : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? BronetColors.sage : BronetColors.sage.withOpacity(0.2)),
              ),
              child: Text(_sorts[i], style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w700,
                color: selected ? BronetColors.sageDark : BronetColors.textMuted)),
            ),
          );
        }),
      ]),
    );
  }

  // ── Map View ─────────────────────────────────────────────────────
  Widget _buildMapView() {
    return Stack(children: [
      const HtmlElementView(viewType: 'bronet-baku-map'),
      // District labels overlay
      Positioned(
        top: 12, left: 12,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(12),
            boxShadow: BronetColors.shadow,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Bakı, Azərbaycan', style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w800, color: BronetColors.forest)),
            const SizedBox(height: 2),
            Text('${_filtered.length} yaxın təminatçı',
              style: TextStyle(fontSize: 10, color: BronetColors.textMuted)),
          ]),
        ),
      ),
      // Legend
      Positioned(
        bottom: 16, right: 12,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            borderRadius: BorderRadius.circular(12),
            boxShadow: BronetColors.shadow,
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(
                color: BronetColors.forest, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text('Açıq', style: TextStyle(fontSize: 10, color: BronetColors.textMuted)),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              Container(width: 12, height: 12, decoration: const BoxDecoration(
                color: Color(0xFF999999), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text('Bağlı', style: TextStyle(fontSize: 10, color: BronetColors.textMuted)),
            ]),
          ]),
        ),
      ),
    ]);
  }

  // ── List View ─────────────────────────────────────────────────────
  Widget _buildProviderList() {
    final list = _filtered;
    if (list.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('🔍', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 16),
        Text('Nəticə tapılmadı', style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w700, color: BronetColors.textMuted)),
        const SizedBox(height: 8),
        Text('Fərqli kateqoriya və ya axtarış sözü sınayın',
          style: TextStyle(fontSize: 13, color: BronetColors.textLight)),
      ]));
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
      itemCount: list.length,
      itemBuilder: (context, i) => _buildProviderCard(list[i]),
    );
  }

  Widget _buildProviderCard(Map<String, dynamic> p) {
    final badge = p['badge'] as String;
    final open  = p['open']  as bool;

    Color badgeColor = BronetColors.forest;
    if (badge == 'HOT')  badgeColor = BronetColors.red;
    if (badge == 'NEW')  badgeColor = BronetColors.green;
    if (badge == 'SALE') badgeColor = BronetColors.amber;

    return GestureDetector(
      onTap: () => Navigator.push(context,
        MaterialPageRoute(builder: (_) => ProviderServicesScreen(provider: p))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: BronetColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          boxShadow: BronetColors.shadow,
        ),
        child: Row(children: [
          // Emoji box
          Container(
            width: 88, height: 88,
            decoration: BoxDecoration(
              color: Color(p['color'] as int),
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
            ),
            child: Stack(children: [
              Center(child: Text(p['emoji'] as String, style: const TextStyle(fontSize: 34))),
              if (badge.isNotEmpty)
                Positioned(top: 7, left: 7,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(6)),
                    child: Text(badge, style: const TextStyle(
                      color: Colors.white, fontSize: 8, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  )),
            ]),
          ),
          // Content
          Expanded(child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(p['cat'] as String, style: TextStyle(
                  fontSize: 9, fontWeight: FontWeight.w800,
                  color: BronetColors.sageDark, letterSpacing: 0.8)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: open
                        ? BronetColors.green.withOpacity(0.12)
                        : BronetColors.red.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(open ? 'Açıq' : 'Bağlı',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                      color: open ? BronetColors.green : BronetColors.red)),
                ),
              ]),
              const SizedBox(height: 3),
              Text(p['name'] as String, style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.w800, color: BronetColors.textPrimary),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 5),
              Row(children: [
                const Icon(Icons.star_rounded, size: 12, color: Color(0xFFFFB830)),
                const SizedBox(width: 3),
                Text(p['rating'] as String, style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w700, color: BronetColors.textPrimary)),
                Text(' (${p['reviews']})', style: TextStyle(fontSize: 11, color: BronetColors.textLight)),
                const SizedBox(width: 8),
                Icon(Icons.location_on_rounded, size: 11, color: BronetColors.textLight),
                const SizedBox(width: 2),
                Text(p['dist'] as String, style: TextStyle(fontSize: 11, color: BronetColors.textMuted)),
              ]),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('${p['from']} AZN-dən',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: BronetColors.sageDark)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: BronetColors.forest, borderRadius: BorderRadius.circular(10)),
                  child: const Text('Xidmətlərə Bax',
                    style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
                ),
              ]),
            ]),
          )),
        ]),
      ),
    );
  }
}
