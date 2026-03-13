import 'package:flutter/material.dart';
import 'dart:async';
import '../theme/colors.dart';
import '../services/booking_api.dart';
import '../services/auth_service.dart';

class DealsScreen extends StatefulWidget {
  const DealsScreen({super.key});

  @override
  State<DealsScreen> createState() => _DealsScreenState();
}

class _DealsScreenState extends State<DealsScreen> {
  int _selectedTab = 0;
  final List<String> _tabs = ['Hamısı', 'Sürətli', 'Həftəlik', 'Yeni İstifadəçi', '⭐ Xallar'];

  void _showBookingSheet(Map<String, dynamic> d) {
    final int price = int.tryParse(d['newPrice'].toString()) ?? 0;
    final int ptsNeeded = (price * 200).round(); // 1 AZN = 200 pts
    final int? earnPts = d['pts'] as int?;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        bool usePoints = false;
        int currentPts = 0;
        bool loadingPts = true;

        return StatefulBuilder(builder: (ctx, setSheet) {
          // Load points on first build
          if (loadingPts) {
            BookingApi.getPoints(AuthService.clientName).then((pts) {
              setSheet(() { currentPts = pts; loadingPts = false; });
            });
          }

          final bool canPayWithPts = !loadingPts && currentPts >= ptsNeeded;

          return Container(
            padding: EdgeInsets.fromLTRB(24, 12, 24,
                MediaQuery.of(ctx).viewInsets.bottom + 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: BronetColors.bgMuted,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                Text(d['emoji'] as String, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 10),
                Text(d['name'] as String, style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w800,
                  color: BronetColors.textPrimary)),
                const SizedBox(height: 3),
                Text(d['provider'] as String, style: const TextStyle(
                  fontSize: 13, color: BronetColors.textMuted)),
                const SizedBox(height: 16),

                // Price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(usePoints ? '0 AZN' : '${d['newPrice']} AZN',
                      style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w900,
                        color: usePoints ? BronetColors.green : BronetColors.textPrimary,
                      )),
                    const SizedBox(width: 10),
                    Text('${d['oldPrice']} AZN', style: const TextStyle(
                      fontSize: 15, color: BronetColors.textLight,
                      decoration: TextDecoration.lineThrough)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: BronetColors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('-${d['off']}%', style: const TextStyle(
                        color: Colors.white, fontSize: 12, fontWeight: FontWeight.w800)),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Points balance display
                if (!loadingPts)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: BronetColors.bgSurface,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Text('⭐', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 5),
                      Text('Balansınız: ${_fmtPts(currentPts)} xal',
                        style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w700,
                          color: BronetColors.textMuted)),
                    ]),
                  ),

                // Pay with points toggle (only when user has enough)
                if (!loadingPts && canPayWithPts) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: usePoints
                          ? const Color(0xFFFFB830).withOpacity(0.10)
                          : BronetColors.bgSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: usePoints
                            ? const Color(0xFFFFB830).withOpacity(0.4)
                            : BronetColors.sage.withOpacity(0.2)),
                    ),
                    child: Row(children: [
                      const Text('⭐', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 10),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${_fmtPts(ptsNeeded)} xalla ödə',
                            style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w800,
                              color: Color(0xFFD48A00))),
                          Text('${d['newPrice']} ₼ qənaət  ·  ${_fmtPts(currentPts - ptsNeeded)} xal qalır',
                            style: const TextStyle(
                              fontSize: 11, color: BronetColors.textMuted)),
                        ],
                      )),
                      Switch(
                        value: usePoints,
                        onChanged: (v) => setSheet(() => usePoints = v),
                        activeColor: const Color(0xFFD48A00),
                        activeTrackColor: const Color(0xFFFFB830).withOpacity(0.3),
                        inactiveThumbColor: BronetColors.textLight,
                        inactiveTrackColor: BronetColors.bgMuted,
                      ),
                    ]),
                  ),
                ] else if (earnPts != null && !loadingPts) ...[
                  // Earn pts badge when NOT paying with pts
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB830).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFFFB830).withOpacity(0.3)),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Text('⭐', style: TextStyle(fontSize: 14)),
                      const SizedBox(width: 5),
                      Text('+$earnPts sadiqlik xalı qazanın', style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: Color(0xFFD48A00))),
                    ]),
                  ),
                ],

                const SizedBox(height: 8),
                Text(d['left'] as String, style: TextStyle(
                  fontSize: 12, color: BronetColors.red,
                  fontWeight: FontWeight.w600)),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      if (usePoints) {
                        await BookingApi.addPoints(
                            AuthService.clientName, -ptsNeeded);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              '${_fmtPts(ptsNeeded)} xalla ödənildi! '
                              '${d['name']} rezerv edildi ✅'),
                          backgroundColor: const Color(0xFFD48A00),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ));
                      } else {
                        if (earnPts != null) {
                          await BookingApi.addPoints(
                              AuthService.clientName, earnPts);
                        }
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(earnPts != null
                              ? 'Rezerv edildi: ${d['name']}! +$earnPts xal qazanıldı ⭐'
                              : 'Rezerv edildi: ${d['name']}! 🎉'),
                          backgroundColor: BronetColors.forest,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: usePoints
                          ? const Color(0xFFD48A00)
                          : BronetColors.forest,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text(
                      usePoints
                          ? 'Pay ${_fmtPts(ptsNeeded)} pts ⭐'
                          : (earnPts != null
                              ? 'Book & Earn $earnPts pts ⭐'
                              : 'Confirm Booking'),
                      style: const TextStyle(
                        color: Colors.white, fontSize: 15,
                        fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  String _fmtPts(int pts) => pts.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');

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

  // pts = null means no points (money-only deals like car/gym/laser)
  final List<Map<String, dynamic>> _deals = [
    {
      'emoji': '✂️',
      'name': 'Klassik Saç Kəsimi + Saqqal',
      'provider': 'Qehreman Barbershop',
      'cat': 'Barbershop',
      'oldPrice': '35',
      'newPrice': '21',
      'off': '40',
      'tag': 'FLAŞ',
      'tagColor': 0xFFFF4D6A,
      'color': 0xFFE6F0FA,
      'rating': '4.9',
      'left': '8 yer qaldı',
      'timer': true,
      'pts': 70,
    },
    {
      'emoji': '💅',
      'name': 'Gel Manikür + Pedikür',
      'provider': 'Pearl Nail Studio',
      'cat': 'Nails',
      'oldPrice': '55',
      'newPrice': '31',
      'off': '43',
      'tag': 'FLAŞ',
      'tagColor': 0xFFFF4D6A,
      'color': 0xFFF0ECF8,
      'rating': '4.7',
      'left': '5 yer qaldı',
      'timer': true,
      'pts': 103,
    },
    {
      'emoji': '🧖',
      'name': 'İsveç Tam Bədən Masajı',
      'provider': 'Serenity Spa Baku',
      'cat': 'Spa',
      'oldPrice': '80',
      'newPrice': '50',
      'off': '37',
      'tag': 'HƏFTƏLIK',
      'tagColor': 0xFF4A88BB,
      'color': 0xFFE8F3FC,
      'rating': '4.9',
      'left': '12 yer qaldı',
      'timer': false,
      'pts': 167,
    },
    {
      'emoji': '🦷',
      'name': 'Diş Ağardılması Seansı',
      'provider': 'SmilePro Dental',
      'cat': 'Dental',
      'oldPrice': '120',
      'newPrice': '72',
      'off': '40',
      'tag': 'HƏFTƏLIK',
      'tagColor': 0xFF4A88BB,
      'color': 0xFFECF4FC,
      'rating': '4.9',
      'left': '3 yer qaldı',
      'timer': false,
      'pts': 240,
    },
    {
      'emoji': '✨',
      'name': 'Lazer Epilyasiya (ayaqlar)',
      'provider': 'LaserZone Baku',
      'cat': 'Laser',
      'oldPrice': '150',
      'newPrice': '75',
      'off': '50',
      'tag': 'YENİ İSTİFADƏÇİ',
      'tagColor': 0xFF7C6FED,
      'color': 0xFFFCFCE8,
      'rating': '4.8',
      'left': 'Limitsiz',
      'timer': false,
    },
    {
      'emoji': '💪',
      'name': 'Aylıq Gym Üzvlüyü',
      'provider': 'FitPeak Gym',
      'cat': 'Gym',
      'oldPrice': '60',
      'newPrice': '36',
      'off': '40',
      'tag': 'YENİ İSTİFADƏÇİ',
      'tagColor': 0xFF7C6FED,
      'color': 0xFFFFF0E8,
      'rating': '4.7',
      'left': 'Limitsiz',
      'timer': false,
    },
    {
      'emoji': '🚗',
      'name': 'Tam Avtomobil Diaqnostikası',
      'provider': 'AutoMaster Express',
      'cat': 'Auto',
      'oldPrice': '80',
      'newPrice': '48',
      'off': '40',
      'tag': 'FLAŞ',
      'tagColor': 0xFFFF4D6A,
      'color': 0xFFEAECF4,
      'rating': '4.6',
      'left': '4 yer qaldı',
      'timer': true,
    },
    {
      'emoji': '🎨',
      'name': 'Kiçik Döymə Seansı',
      'provider': 'Inkstone Studio',
      'cat': 'Tattoo',
      'oldPrice': '100',
      'newPrice': '60',
      'off': '40',
      'tag': 'HƏFTƏLIK',
      'tagColor': 0xFF4A88BB,
      'color': 0xFFF0E8F4,
      'rating': '4.9',
      'left': '6 yer qaldı',
      'timer': false,
      'pts': 200,
    },
  ];

  // ── Points Deals ─────────────────────────────────────────────────
  final List<Map<String, dynamic>> _pointsDeals = [
    {'emoji': '✂️', 'name': 'Ekspress Saç Kəsimi',   'provider': 'Qehreman Barbershop', 'cat': 'Barbershop', 'pts': 3000,  'color': 0xFFE6F0FA, 'desc': '30 dəq seans · 15 AZN qənaət'},
    {'emoji': '🪒', 'name': 'Saqqal Qırxımı',         'provider': 'Royal Cuts Baku',    'cat': 'Barbershop', 'pts': 1600,  'color': 0xFFD4EAFB, 'desc': '20 dəq seans · 8 AZN qənaət'},
    {'emoji': '💅', 'name': 'Klassik Manikür',         'provider': 'Pearl Nail Studio',  'cat': 'Nails',      'pts': 2400,  'color': 0xFFFCF0F8, 'desc': '30 dəq seans · 12 AZN qənaət'},
    {'emoji': '🏋️','name': 'Gym Günlük Bilet',        'provider': 'FitPeak Gym',        'cat': 'Gym',        'pts': 2000,  'color': 0xFFFFF0E8, 'desc': 'Tam günlük giriş · 10 AZN qənaət'},
    {'emoji': '🧖', 'name': 'Aromaterapiya Masajı',   'provider': 'Zen Garden Spa',     'cat': 'Spa',        'pts': 9000,  'color': 0xFFE8F5F0, 'desc': '45 dəq seans · 45 AZN qənaət'},
    {'emoji': '🌸', 'name': 'Ekspress Üz Baxımı',     'provider': 'Glam & Go Salon',    'cat': 'Salon',      'pts': 5000,  'color': 0xFFEEF0FB, 'desc': '30 dəq müalicə · 25 AZN qənaət'},
    {'emoji': '🦷', 'name': 'Diş Müayinəsi',           'provider': 'Denta Clinic Baku',  'cat': 'Dental',     'pts': 5000,  'color': 0xFFE8F3FD, 'desc': '30 dəq müayinə · 25 AZN qənaət'},
    {'emoji': '✨', 'name': 'Qoltuqaltı Lazer',        'provider': 'SmoothSkin Clinic',  'cat': 'Laser',      'pts': 8000,  'color': 0xFFEFF6FF, 'desc': '20 dəq seans · 40 AZN qənaət'},
    {'emoji': '🎨', 'name': 'Döymə Retouşu',           'provider': 'Inkstone Studio',    'cat': 'Tattoo',     'pts': 8000,  'color': 0xFFF0E8F4, 'desc': '30 dəq seans · 40 AZN qənaət'},
    {'emoji': '🐕', 'name': 'İt Qulluğu',              'provider': 'Happy Paws Clinic',  'cat': 'Pet',        'pts': 7000,  'color': 0xFFF5F2E8, 'desc': '60 dəq qulluq · 35 AZN qənaət'},
  ];

  void _showPointsDealSheet(Map<String, dynamic> d) {
    final int pts = d['pts'] as int;
    int currentPts = 0;
    bool loading = true;
    bool fetchStarted = false;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) {
          if (loading && !fetchStarted) {
            fetchStarted = true;
            BookingApi.getPoints(AuthService.clientName).then((p) {
              try { setS(() { currentPts = p; loading = false; }); } catch (_) {}
            });
          }
          final enough = !loading && currentPts >= pts;
          return Container(
            padding: EdgeInsets.fromLTRB(24, 12, 24,
              MediaQuery.of(ctx).viewInsets.bottom + 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 40, height: 4,
                decoration: BoxDecoration(color: BronetColors.bgMuted,
                  borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              Text(d['emoji'] as String, style: const TextStyle(fontSize: 52)),
              const SizedBox(height: 10),
              Text(d['name'] as String, style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: BronetColors.textPrimary)),
              const SizedBox(height: 3),
              Text(d['provider'] as String, style: TextStyle(fontSize: 13, color: BronetColors.textMuted)),
              const SizedBox(height: 4),
              Text(d['desc'] as String, style: TextStyle(fontSize: 12, color: BronetColors.textLight)),
              const SizedBox(height: 18),
              // Points price pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFB830).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFFB830).withOpacity(0.4)),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Text('⭐', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Text('${_fmtPts(pts)} pts', style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFFD48A00))),
                ]),
              ),
              const SizedBox(height: 12),
              // Balance
              if (!loading) Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: BronetColors.bgSurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Icon(Icons.account_balance_wallet_rounded,
                    size: 14, color: enough ? BronetColors.green : BronetColors.red),
                  const SizedBox(width: 6),
                  Text(
                    enough
                      ? 'Balance: ${_fmtPts(currentPts)} pts  (${_fmtPts(currentPts - pts)} remaining)'
                      : 'Balance: ${_fmtPts(currentPts)} pts  (need ${_fmtPts(pts - currentPts)} more)',
                    style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: enough ? BronetColors.textMuted : BronetColors.red)),
                ]),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: enough ? () async {
                    await BookingApi.addPoints(AuthService.clientName, -pts);
                    if (!mounted) return;
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${_fmtPts(pts)} xal istifadə edildi: ${d['name']}! ✅'),
                      backgroundColor: const Color(0xFFD48A00),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ));
                  } : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: enough ? const Color(0xFFD48A00) : BronetColors.bgMuted,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(child: loading
                      ? const SizedBox(width: 22, height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : Text(
                          enough
                            ? 'Redeem ${_fmtPts(pts)} pts ⭐'
                            : 'Not Enough Points',
                          style: TextStyle(
                            color: enough ? Colors.white : BronetColors.textLight,
                            fontSize: 15, fontWeight: FontWeight.w800))),
                  ),
                ),
              ),
            ]),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> get _filtered {
    if (_selectedTab == 4) return []; // points tab handled separately
    if (_selectedTab == 0) return _deals;
    final tagMap = {1: 'FLAŞ', 2: 'HƏFTƏLIK', 3: 'YENİ İSTİFADƏÇİ'};
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
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Sıcaq Endirimlər', style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: BronetColors.textPrimary,
              letterSpacing: -0.5,
            )),
            Text('Böyük qənaət · Sadiqlik xalları qazanın',
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
              Icon(Icons.local_fire_department_rounded,
                color: BronetColors.red, size: 16),
              const SizedBox(width: 5),
              Text('${_filtered.length} deals',
                style: TextStyle(
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
          colors: [BronetColors.forest, BronetColors.forestDeep],
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
              const Text('Sürətli Endirim bitir', style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              )),
              Text('Bitməmişdən əvvəl alın!',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                )),
            ]),
          ]),
          // Points info pill
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(children: [
              const Text('⭐', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 4),
              Text('1000 pts = 5 ₼', style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              )),
            ]),
          ),
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
    if (_selectedTab == 4) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 24),
        children: [
          // Points intro card
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD48A00), Color(0xFFFFB830)],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: BronetColors.shadow,
            ),
            child: Row(children: [
              const Text('⭐', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Xallarla Ödə', style: TextStyle(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text('1,000 xal = 5 AZN  ·  Hər rezervdə xal qazanın',
                  style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 11)),
              ])),
            ]),
          ),
          ..._pointsDeals.map((d) => _buildPointsDealCard(d)).toList(),
        ],
      );
    }
    final list = _filtered;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      itemCount: list.length,
      itemBuilder: (context, i) => _buildDealCard(list[i]),
    );
  }

  Widget _buildPointsDealCard(Map<String, dynamic> d) {
    final pts = d['pts'] as int;
    return GestureDetector(
      onTap: () => _showPointsDealSheet(d),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: BronetColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          boxShadow: BronetColors.shadow,
          border: Border.all(color: const Color(0xFFFFB830).withOpacity(0.25)),
        ),
        child: Row(children: [
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: Color(d['color'] as int),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text(d['emoji'] as String,
              style: const TextStyle(fontSize: 28))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d['cat'] as String, style: TextStyle(
              fontSize: 9, fontWeight: FontWeight.w800,
              color: BronetColors.sageDark, letterSpacing: 0.8)),
            const SizedBox(height: 2),
            Text(d['name'] as String, style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w800, color: BronetColors.textPrimary)),
            const SizedBox(height: 2),
            Text(d['provider'] as String, style: TextStyle(
              fontSize: 11, color: BronetColors.textMuted)),
            const SizedBox(height: 2),
            Text(d['desc'] as String, style: TextStyle(
              fontSize: 10, color: BronetColors.textLight)),
          ])),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFFB830).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFFFB830).withOpacity(0.4)),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                const Text('⭐', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Text('${_fmtPts(pts)} pts', style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFD48A00))),
              ]),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0xFFD48A00),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('Ödə', style: TextStyle(
                color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800)),
            ),
          ]),
        ]),
      ),
    );
  }

  Widget _buildDealCard(Map<String, dynamic> d) {
    final tagColor = Color(d['tagColor'] as int);
    final hasTimer = d['timer'] as bool;
    final pts = d['pts'] as int?;

    return GestureDetector(
      onTap: () => _showBookingSheet(d),
      child: Container(
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
              // Points badge (if deal earns points)
              if (pts != null)
                Positioned(
                  bottom: 8, left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB830),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      const Text('⭐', style: TextStyle(fontSize: 10)),
                      const SizedBox(width: 3),
                      Text('+$pts pts', style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      )),
                    ]),
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
                    Text(d['cat'] as String, style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: BronetColors.sageDark,
                      letterSpacing: 0.8,
                    )),
                    Row(children: [
                      const Icon(Icons.star_rounded,
                        size: 12, color: Color(0xFFFFB830)),
                      const SizedBox(width: 3),
                      Text(d['rating'] as String, style: TextStyle(
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
                  color: BronetColors.textPrimary,
                )),
                const SizedBox(height: 3),
                Text(d['provider'] as String, style: TextStyle(
                  fontSize: 12,
                  color: BronetColors.textMuted,
                )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('${d['newPrice']} AZN', style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: BronetColors.forest,
                        )),
                        const SizedBox(width: 8),
                        Text('${d['oldPrice']} AZN', style: TextStyle(
                          fontSize: 13,
                          color: BronetColors.textLight,
                          decoration: TextDecoration.lineThrough,
                        )),
                      ]),
                      Text(d['left'] as String, style: TextStyle(
                        fontSize: 11,
                        color: BronetColors.red,
                        fontWeight: FontWeight.w600,
                      )),
                    ]),
                    GestureDetector(
                      onTap: () => _showBookingSheet(d),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: pts != null ? 14.0 : 22.0, vertical: 12),
                        decoration: BoxDecoration(
                          color: BronetColors.forest,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: BronetColors.shadow,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('İndi Rezerv Et', style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            )),
                            if (pts != null)
                              Text('+$pts pts', style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
