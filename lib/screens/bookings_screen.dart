import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/booking_api.dart';
import 'feedback_screen.dart';

class BookingsScreen extends StatefulWidget {
  final VoidCallback? onBrowseServices;
  const BookingsScreen({super.key, this.onBrowseServices});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Gələcək', 'Tamamlandı', 'Ləğv edildi'];

  // Live bookings from server
  final List<Map<String, dynamic>> _liveBookings = [];
  final Set<String> _notifiedIds = {};
  Timer? _pollTimer;

  final List<Map<String, dynamic>> _upcoming = [
    {
      'emoji': '✂️',
      'service': 'Klassik Saç + Saqqal',
      'provider': 'Qehreman Barbershop',
      'specialist': 'Rauf M.',
      'date': 'Bu gün',
      'time': '14:30',
      'price': '15 AZN',
      'status': 'confirmed',
      'color': 0xFFE6F0FA,
      'id': '#BRN-2841',
    },
    {
      'emoji': '🦷',
      'service': 'Diş Ağardılması',
      'provider': 'SmilePro Dental',
      'specialist': 'Dr. Nigar H.',
      'date': 'Sabah',
      'time': '11:00',
      'price': '72 AZN',
      'status': 'confirmed',
      'color': 0xFFECF4FC,
      'id': '#BRN-2842',
    },
    {
      'emoji': '🧖',
      'service': 'İsveç Masajı 60dəq',
      'provider': 'Serenity Spa Baku',
      'specialist': 'Leyla A.',
      'date': '12 Mar',
      'time': '16:00',
      'price': '50 AZN',
      'status': 'pending',
      'color': 0xFFE8F3FC,
      'id': '#BRN-2843',
    },
  ];

  final List<Map<String, dynamic>> _completed = [
    {
      'emoji': '✂️',
      'service': 'Klassik Saç Kəsimi',
      'provider': 'Qehreman Barbershop',
      'specialist': 'Rauf M.',
      'date': '1 Mar',
      'time': '13:00',
      'price': '15 AZN',
      'status': 'completed',
      'color': 0xFFE6F0FA,
      'id': '#BRN-2831',
      'rated': true,
      'rating': 5,
    },
    {
      'emoji': '💅',
      'service': 'Gel Manikür',
      'provider': 'Pearl Nail Studio',
      'specialist': 'Aysel K.',
      'date': '24 Fev',
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
      'service': 'Şəxsi Məşq',
      'provider': 'FitPeak Gym',
      'specialist': 'Kamran T.',
      'date': '18 Fev',
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
      'service': 'Avtomobil Diaqnostikası',
      'provider': 'AutoMaster Express',
      'specialist': 'Elshan B.',
      'date': '20 Fev',
      'time': '10:00',
      'price': '48 AZN',
      'status': 'cancelled',
      'color': 0xFFEAECF4,
      'id': '#BRN-2815',
      'reason': 'İstifadəçi tərəfindən ləğv edildi',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) => _pollServer());
    _pollServer();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _pollServer() async {
    final serverBookings = await BookingApi.fetchBookings();
    if (!mounted) return;
    setState(() {
      for (final sb in serverBookings) {
        final id = sb['id'] as String? ?? '';
        final newStatus = sb['status'] as String? ?? 'pending';
        final idx = _liveBookings.indexWhere((b) => b['id'] == id);
        if (idx < 0) {
          // Brand new booking from server — add to live list
          _liveBookings.add({
            'emoji': '✨',
            'service': sb['service'] as String? ?? 'Xidmət',
            'provider': sb['provider'] as String? ?? '',
            'specialist': sb['specialist'] as String? ?? 'Bilinmir',
            'date': sb['date'] as String? ?? 'Bilinmir',
            'time': sb['time'] as String? ?? 'Bilinmir',
            'price': '${sb['price'] ?? '0'} AZN',
            'status': newStatus,
            'color': 0xFFD4EAFB,
            'id': id,
            'isLive': true,
          });
        } else {
          // Check for status change
          final oldStatus = _liveBookings[idx]['status'] as String;
          if (oldStatus != newStatus && !_notifiedIds.contains('$id-$newStatus')) {
            _liveBookings[idx] = {..._liveBookings[idx], 'status': newStatus};
            _notifiedIds.add('$id-$newStatus');
            final svc = sb['service'] as String? ?? 'booking';
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              if (newStatus == 'confirmed') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('✅ $svc rezervasiyası təsdiqləndi!'),
                  backgroundColor: BronetColors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                ));
              } else if (newStatus == 'declined') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('❌ $svc rezervasiyası rədd edildi'),
                  backgroundColor: BronetColors.red,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                ));
              } else if (newStatus == 'completed') {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('🎉 $svc tamamlandı! Təcrübənizi qiymətləndirin'),
                  backgroundColor: BronetColors.sageDark,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                ));
              }
            });
          }
        }
      }
    });
  }

  List<Map<String, dynamic>> get _current {
    if (_selectedTab == 0) {
      final liveUpcoming = _liveBookings.where(
        (b) => b['status'] != 'completed' && b['status'] != 'cancelled').toList();
      return [..._upcoming, ...liveUpcoming];
    }
    if (_selectedTab == 1) return _completed;
    return _cancelled;
  }

  void _cancelBooking(Map<String, dynamic> b) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Rezervi Ləğv Et', style: TextStyle(
          fontWeight: FontWeight.w800, color: BronetColors.textPrimary)),
        content: Text(
          '${b['service']} rezervini ləğv etmək istəyirsiniz?\n\nBu əməliyyat geri qaytarıla bilməz.',
          style: TextStyle(fontSize: 14, color: BronetColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Saxla', style: TextStyle(color: BronetColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _upcoming.remove(b);
                final cancelled = Map<String, dynamic>.from(b);
                cancelled['status'] = 'cancelled';
                cancelled['reason'] = 'İstifadəçi tərəfindən ləğv edildi';
                _cancelled.add(cancelled);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Rezerv ləğv edildi'),
                backgroundColor: BronetColors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ));
            },
            child: Text('Ləğv Et',
              style: TextStyle(color: BronetColors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _rescheduleBooking(Map<String, dynamic> b) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(
            primary: BronetColors.forest,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: BronetColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null && mounted) {
      final months = ['Yan','Fev','Mar','Apr','May','İyn',
                      'İyl','Avq','Sen','Okt','Noy','Dek'];
      final label = picked.day == DateTime.now().day &&
              picked.month == DateTime.now().month
          ? 'Bu gün'
          : picked.day == DateTime.now().add(const Duration(days: 1)).day &&
              picked.month == DateTime.now().month
          ? 'Sabah'
          : '${months[picked.month - 1]} ${picked.day}';
      setState(() => b['date'] = label);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Yenidən planlandı: $label!'),
        backgroundColor: BronetColors.forest,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
    }
  }

  void _showRatingDialog(Map<String, dynamic> b) async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => FeedbackScreen(
        serviceName: b['service'] as String,
        providerName: b['provider'] as String,
        emoji: b['emoji'] as String? ?? '⭐',
      )),
    );
    if (result != null && mounted) {
      setState(() {
        b['rated'] = true;
        b['rating'] = result['stars'] as int? ?? 5;
      });
    }
  }

  void _rebookService(Map<String, dynamic> b) {
    setState(() {
      _cancelled.remove(b);
      final rebooking = Map<String, dynamic>.from(b);
      rebooking['status'] = 'pending';
      rebooking['date'] = 'Gözlənilir';
      rebooking['time'] = 'TBD';
      rebooking.remove('reason');
      _upcoming.add(rebooking);
      _selectedTab = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${b['service']} üçün yenidən rezerv sorğusu göndərildi!'),
      backgroundColor: BronetColors.forest,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }

  void _showBookingDetails(Map<String, dynamic> b) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: BronetColors.bgMuted,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(child: Text(b['emoji'] as String, style: const TextStyle(fontSize: 48))),
            const SizedBox(height: 12),
            Center(child: Text(b['service'] as String, style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: BronetColors.textPrimary))),
            const SizedBox(height: 4),
            Center(child: Text(b['provider'] as String, style: TextStyle(
              fontSize: 13, color: BronetColors.textMuted))),
            const SizedBox(height: 24),
            _detailRow(Icons.tag_rounded, 'Rezerv ID', b['id'] as String),
            _detailRow(Icons.person_rounded, 'Mütəxəssis', b['specialist'] as String),
            _detailRow(Icons.calendar_today_rounded, 'Tarix & Vaxt', '${b['date']} · ${b['time']}'),
            _detailRow(Icons.payments_rounded, 'Məbləğ', b['price'] as String),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: BronetColors.forest),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Bağla', style: TextStyle(
                  color: BronetColors.forest, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: BronetColors.bgMuted,
                borderRadius: BorderRadius.circular(2),
              ),
            )),
            const SizedBox(height: 20),
            Text('Rezervləri Filtrele', style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900,
              color: BronetColors.textPrimary)),
            const SizedBox(height: 6),
            Text('Status seçin', style: TextStyle(
              fontSize: 13, color: BronetColors.textMuted)),
            const SizedBox(height: 20),
            Text('VƏZİYYƏT', style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w800,
              letterSpacing: 1.5, color: BronetColors.textLight)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _filterChip(ctx, 'Hamısı', -1, Icons.list_rounded),
                _filterChip(ctx, 'Gələcək (${_upcoming.length})', 0, Icons.upcoming_rounded),
                _filterChip(ctx, 'Tamamlandı (${_completed.length})', 1, Icons.check_circle_rounded),
                _filterChip(ctx, 'Ləğv edildi (${_cancelled.length})', 2, Icons.cancel_rounded),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(BuildContext ctx, String label, int tabIndex, IconData icon) {
    final selected = tabIndex == _selectedTab || (tabIndex == -1 && false);
    return GestureDetector(
      onTap: () {
        if (tabIndex >= 0) setState(() => _selectedTab = tabIndex);
        Navigator.pop(ctx);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? BronetColors.forest : BronetColors.bgSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? BronetColors.forest : BronetColors.sage.withOpacity(0.3)),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 14,
            color: selected ? Colors.white : BronetColors.sageDark),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: selected ? Colors.white : BronetColors.textPrimary,
          )),
        ]),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: BronetColors.sageBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(child: Icon(icon, size: 16, color: BronetColors.sageDark)),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 11, color: BronetColors.textLight)),
          Text(value, style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w700, color: BronetColors.textPrimary)),
        ]),
      ]),
    );
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
          Text('Rezervlərim', style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: BronetColors.textPrimary,
            letterSpacing: -0.5,
          )),
          GestureDetector(
            onTap: _showFilterSheet,
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: BronetColors.bgCard,
                borderRadius: BorderRadius.circular(12),
                boxShadow: BronetColors.shadow,
              ),
              child: Icon(Icons.filter_list_rounded,
                color: BronetColors.forest, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final totalSpent = _completed.fold(0, (sum, b) {
      final price = (b['price'] as String).replaceAll(RegExp(r'[^\d]'), '');
      return sum + (int.tryParse(price) ?? 0);
    });
    final statIcons = [Icons.receipt_long_rounded, Icons.alarm_rounded, Icons.credit_card_rounded];
    final statValues = [
      '${_upcoming.length + _completed.length + _cancelled.length}',
      '${_upcoming.length}',
      '$totalSpent ₼',
    ];
    final statLabels = ['Cəmi', 'Gələcək', 'Xərcləndi'];
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [BronetColors.forest, BronetColors.forestDeep],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: BronetColors.shadowStrong,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(3, (i) => Column(children: [
          Icon(statIcons[i], color: Colors.white.withOpacity(0.75), size: 22),
          const SizedBox(height: 5),
          Text(statValues[i], style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          )),
          Text(statLabels[i], style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 11,
          )),
        ])),
      ),
    );
  }

  Widget _buildTabs() {
    final counts = [_upcoming.length, _completed.length, _cancelled.length];
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
                  child: Text('${_tabs[i]} (${counts[i]})', style: TextStyle(
                    fontSize: 11,
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('📭', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 16),
            Text('Rezerv yoxdur',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: BronetColors.textMuted,
              )),
            const SizedBox(height: 8),
            Text(_selectedTab == 0
                ? 'Başlamaq üçün xidmət rezerv edin'
                : 'Rezervləriniz burada görünəcək',
              style: TextStyle(
                fontSize: 13,
                color: BronetColors.textLight,
              )),
            if (_selectedTab == 0) ...[
              const SizedBox(height: 20),
              GestureDetector(
                onTap: widget.onBrowseServices,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: BronetColors.forest,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: BronetColors.shadow,
                  ),
                  child: const Text('Xidmətlərə bax',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    )),
                ),
              ),
            ],
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
    final isLive = b['isLive'] == true;

    Color statusColor;
    String statusLabel;
    switch (status) {
      case 'confirmed':
        statusColor = BronetColors.green;
        statusLabel = 'Təsdiqlənmiş';
        break;
      case 'pending':
        statusColor = BronetColors.amber;
        statusLabel = 'Gözlənilir';
        break;
      case 'completed':
        statusColor = BronetColors.sageDark;
        statusLabel = 'Tamamlandı';
        break;
      default:
        statusColor = BronetColors.red;
        statusLabel = 'Ləğv edildi';
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
                            child: Row(children: [
                              if (isLive) ...[
                                Container(
                                  width: 7, height: 7,
                                  decoration: BoxDecoration(
                                    color: BronetColors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 5),
                              ],
                              Expanded(
                                child: Text(b['service'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: BronetColors.textPrimary,
                                  ), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ),
                            ]),
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
                      Text(b['provider'] as String, style: TextStyle(
                        fontSize: 12,
                        color: BronetColors.textMuted,
                      )),
                      const SizedBox(height: 5),
                      Row(children: [
                        Icon(Icons.person_rounded,
                          size: 12, color: BronetColors.textLight),
                        const SizedBox(width: 3),
                        Text(b['specialist'] as String, style: TextStyle(
                          fontSize: 11,
                          color: BronetColors.textMuted,
                        )),
                        const SizedBox(width: 10),
                        Icon(Icons.access_time_rounded,
                          size: 12, color: BronetColors.textLight),
                        const SizedBox(width: 3),
                        Text('${b['date']} • ${b['time']}',
                          style: TextStyle(
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
                Text(b['id'] as String, style: TextStyle(
                  fontSize: 11,
                  color: BronetColors.textLight,
                  fontWeight: FontWeight.w600,
                )),
                Row(children: [
                  Text(b['price'] as String, style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: BronetColors.forest,
                  )),
                  const SizedBox(width: 10),
                  if (status == 'confirmed' || status == 'pending')
                    _actionButton('Yenidən planla',
                      BronetColors.sageBg, BronetColors.sageDark,
                      () => _rescheduleBooking(b)),
                  if (status == 'completed' && b['rated'] == false)
                    _actionButton('Qiymətləndir ⭐',
                      BronetColors.amber.withOpacity(0.12), BronetColors.amber,
                      () => _showRatingDialog(b)),
                  if (status == 'completed' && b['rated'] == true)
                    Row(children: List.generate(b['rating'] as int, (_) =>
                      const Text('⭐', style: TextStyle(fontSize: 12)))),
                  if (status == 'cancelled')
                    _actionButton('Yenidən rezerv et',
                      BronetColors.sageBg, BronetColors.sageDark,
                      () => _rebookService(b)),
                ]),
              ],
            ),
          ),
          // Action buttons for upcoming bookings
          if (status == 'confirmed' || status == 'pending')
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _cancelBooking(b),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: BronetColors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: BronetColors.red.withOpacity(0.2)),
                      ),
                      child: Center(
                        child: Text('Ləğv et', style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: BronetColors.red,
                        )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _showBookingDetails(b),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: BronetColors.forest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('Ətraflı bax', style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
        ],
      ),
    );
  }

  Widget _actionButton(String label, Color bg, Color textColor, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
