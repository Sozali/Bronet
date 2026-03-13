import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/booking_api.dart';
import '../services/auth_service.dart';

class ProviderServicesScreen extends StatefulWidget {
  final Map<String, dynamic> provider;
  const ProviderServicesScreen({super.key, required this.provider});

  @override
  State<ProviderServicesScreen> createState() => _ProviderServicesScreenState();
}

class _ProviderServicesScreenState extends State<ProviderServicesScreen> {
  static const Map<String, List<Map<String, dynamic>>> _catServices = {
    'Barbershop': [
      {'name': 'Klassik Saç Kəsimi',  'duration': '30 dəq',     'price': '15',  'emoji': '✂️',  'popular': true},
      {'name': 'Fade Kəsimi',         'duration': '45 dəq',     'price': '20',  'emoji': '✂️',  'popular': false},
      {'name': 'Saqqal Kəsimi',       'duration': '20 dəq',     'price': '8',   'emoji': '🪒',  'popular': true},
      {'name': 'Uşaq Saç Kəsimi',     'duration': '25 dəq',     'price': '12',  'emoji': '👦',  'popular': false},
      {'name': 'Saç + Saqqal Dəsti',  'duration': '60 dəq',     'price': '30',  'emoji': '💈',  'popular': false},
    ],
    'Salon': [
      {'name': 'Fenli Düzləndirmə',   'duration': '45 dəq',     'price': '25',  'emoji': '💁',  'popular': true},
      {'name': 'Saç Boyama',          'duration': '2 s',        'price': '60',  'emoji': '🎨',  'popular': false},
      {'name': 'Saç Aydınlatması',    'duration': '90 dəq',     'price': '80',  'emoji': '✨',  'popular': true},
      {'name': 'Dərin Qidalanma',     'duration': '30 dəq',     'price': '20',  'emoji': '💧',  'popular': false},
      {'name': 'Keratin Müalicəsi',   'duration': '3 s',        'price': '120', 'emoji': '💎',  'popular': false},
    ],
    'Nails': [
      {'name': 'Gel Manikür',         'duration': '45 dəq',     'price': '18',  'emoji': '💅',  'popular': true},
      {'name': 'Klassik Manikür',     'duration': '30 dəq',     'price': '12',  'emoji': '🌸',  'popular': false},
      {'name': 'Pedikür',             'duration': '45 dəq',     'price': '20',  'emoji': '🦶',  'popular': true},
      {'name': 'Dırnaq Dizaynı',      'duration': '60 dəq',     'price': '25',  'emoji': '🎨',  'popular': false},
      {'name': 'Akril Dəsti',         'duration': '90 dəq',     'price': '35',  'emoji': '💎',  'popular': false},
    ],
    'Dental': [
      {'name': 'Diş Müayinəsi',       'duration': '30 dəq',     'price': '25',  'emoji': '🦷',  'popular': true},
      {'name': 'Diş Ağardılması',     'duration': '60 dəq',     'price': '120', 'emoji': '✨',  'popular': true},
      {'name': 'Diş Təmizlənməsi',    'duration': '45 dəq',     'price': '55',  'emoji': '🪥',  'popular': false},
      {'name': 'Diş Dolğusu',         'duration': '50 dəq',     'price': '80',  'emoji': '🔧',  'popular': false},
      {'name': 'Breket Məsləhəti',    'duration': '30 dəq',     'price': '40',  'emoji': '📋',  'popular': false},
    ],
    'Laser': [
      {'name': 'Ayaq Lazeri',         'duration': '30 dəq',     'price': '60',  'emoji': '✨',  'popular': true},
      {'name': 'Qoltuqaltı Lazer',    'duration': '20 dəq',     'price': '40',  'emoji': '💫',  'popular': true},
      {'name': 'Üz Lazeri',           'duration': '25 dəq',     'price': '50',  'emoji': '🌟',  'popular': false},
      {'name': 'Tam Bədən Lazeri',    'duration': '90 dəq',     'price': '180', 'emoji': '⭐',  'popular': false},
      {'name': 'Bikini Lazeri',       'duration': '25 dəq',     'price': '55',  'emoji': '🔆',  'popular': false},
    ],
    'Auto': [
      {'name': 'Avtomobil Yuma',      'duration': '30 dəq',     'price': '15',  'emoji': '🚿',  'popular': true},
      {'name': 'Tam Detaylı Yuma',    'duration': '3 s',        'price': '80',  'emoji': '✨',  'popular': false},
      {'name': 'Yağ Dəyişimi',        'duration': '45 dəq',     'price': '35',  'emoji': '🔧',  'popular': true},
      {'name': 'Təkər Balansı',       'duration': '30 dəq',     'price': '25',  'emoji': '⚙️',  'popular': false},
      {'name': 'Kondisioner Servis',  'duration': '60 dəq',     'price': '50',  'emoji': '❄️',  'popular': false},
    ],
    'Spa': [
      {'name': 'İsveç Masajı',        'duration': '60 dəq',     'price': '55',  'emoji': '🧖',  'popular': true},
      {'name': 'İsti Daş Masajı',     'duration': '75 dəq',     'price': '70',  'emoji': '🪨',  'popular': false},
      {'name': 'Dərin Toxuma Masajı', 'duration': '60 dəq',     'price': '65',  'emoji': '💆',  'popular': true},
      {'name': 'Üz Müalicəsi',        'duration': '45 dəq',     'price': '45',  'emoji': '🌸',  'popular': false},
      {'name': 'Tam Bədən Sarğısı',   'duration': '90 dəq',     'price': '90',  'emoji': '🌿',  'popular': false},
    ],
    'Gym': [
      {'name': 'Günlük Giriş',        'duration': '1 gün',      'price': '10',  'emoji': '🏋️', 'popular': true},
      {'name': 'Şəxsi Məşq',          'duration': '60 dəq',     'price': '30',  'emoji': '💪',  'popular': true},
      {'name': 'Qrup Dərsi',          'duration': '45 dəq',     'price': '15',  'emoji': '🤸',  'popular': false},
      {'name': 'Yoga Seansı',         'duration': '60 dəq',     'price': '20',  'emoji': '🧘',  'popular': false},
      {'name': 'Aylıq Abunəlik',      'duration': 'Tam giriş',  'price': '80',  'emoji': '🎫',  'popular': false},
    ],
    'Medical': [
      {'name': 'Ümumi Konsultasiya',  'duration': '30 dəq',     'price': '30',  'emoji': '👨‍⚕️','popular': true},
      {'name': 'Qan Testi',           'duration': '20 dəq',     'price': '50',  'emoji': '🩸',  'popular': false},
      {'name': 'EKQ',                 'duration': '20 dəq',     'price': '40',  'emoji': '💓',  'popular': false},
      {'name': 'Fiziki Müayinə',      'duration': '45 dəq',     'price': '60',  'emoji': '🩺',  'popular': true},
      {'name': 'Dermatoloq Ziyarəti', 'duration': '30 dəq',     'price': '45',  'emoji': '🔬',  'popular': false},
    ],
    'Pet': [
      {'name': 'İt Baxımı',           'duration': '60 dəq',     'price': '35',  'emoji': '🐕',  'popular': true},
      {'name': 'Pişik Baxımı',        'duration': '45 dəq',     'price': '28',  'emoji': '🐱',  'popular': false},
      {'name': 'Baytarlıq Məsləhəti', 'duration': '30 dəq',     'price': '30',  'emoji': '👨‍⚕️','popular': true},
      {'name': 'Peyvənd',             'duration': '20 dəq',     'price': '25',  'emoji': '💉',  'popular': false},
      {'name': 'Diş Təmizlənməsi',    'duration': '45 dəq',     'price': '40',  'emoji': '🦷',  'popular': false},
    ],
    'Tattoo': [
      {'name': 'Konsultasiya',        'duration': '20 dəq',     'price': '0',   'emoji': '💬',  'popular': false},
      {'name': 'Kiçik Tattoo',        'duration': '1 s',        'price': '80',  'emoji': '✏️',  'popular': true},
      {'name': 'Orta Tattoo',         'duration': '2-3 s',      'price': '150', 'emoji': '🎨',  'popular': true},
      {'name': 'Böyük Tattoo',        'duration': '4-6 s',      'price': '280', 'emoji': '🖼️',  'popular': false},
      {'name': 'Retouş',              'duration': '30 dəq',     'price': '40',  'emoji': '✨',  'popular': false},
    ],
  };

  static const Map<String, List<Map<String, dynamic>>> _catStaff = {
    'Dental': [
      {'name': 'Dr. Anar Hüseynov', 'role': 'Həkim', 'exp': '12 years', 'rating': '4.9', 'emoji': '👨‍⚕️'},
      {'name': 'Dr. Günel Məmmədova', 'role': 'Ortodont', 'exp': '8 years', 'rating': '4.8', 'emoji': '👩‍⚕️'},
      {'name': 'İstənilən mütəxəssis', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
    'Barbershop': [
      {'name': 'Elçin Babayev', 'role': 'Baş Bərbər', 'exp': '7 years', 'rating': '4.9', 'emoji': '💈'},
      {'name': 'Nicat Əliyev', 'role': 'Bərbər', 'exp': '3 years', 'rating': '4.7', 'emoji': '✂️'},
      {'name': 'İstənilən mövcud', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
    'Salon': [
      {'name': 'Aynur Qasımova', 'role': 'Baş Stilist', 'exp': '10 years', 'rating': '4.9', 'emoji': '💇‍♀️'},
      {'name': 'Leyla Rzayeva', 'role': 'Kolorist', 'exp': '5 years', 'rating': '4.8', 'emoji': '🎨'},
      {'name': 'İstənilən mövcud', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
    'Nails': [
      {'name': 'Narmin Hacıyeva', 'role': 'Dırnaq Texniki', 'exp': '6 years', 'rating': '4.9', 'emoji': '💅'},
      {'name': 'Könül Abbasova', 'role': 'Dırnaq Ustası', 'exp': '4 years', 'rating': '4.7', 'emoji': '🌸'},
      {'name': 'İstənilən mövcud', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
    'Spa': [
      {'name': 'Rəna Əliyeva', 'role': 'Baş Terapevt', 'exp': '9 years', 'rating': '4.9', 'emoji': '🧘‍♀️'},
      {'name': 'Kamran Mustafayev', 'role': 'Masaj Terapevti', 'exp': '5 years', 'rating': '4.8', 'emoji': '💆'},
      {'name': 'İstənilən mövcud', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
    'Gym': [
      {'name': 'Tural Hüseynov', 'role': 'Şəxsi Məşqçi', 'exp': '6 years', 'rating': '4.8', 'emoji': '💪'},
      {'name': 'İstənilən məşqçi', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
    'Medical': [
      {'name': 'Dr. Farid Babayev', 'role': 'Ümumi Həkim', 'exp': '15 years', 'rating': '4.9', 'emoji': '👨‍⚕️'},
      {'name': 'Dr. Sevinc Rəhimova', 'role': 'Mütəxəssis', 'exp': '10 years', 'rating': '4.8', 'emoji': '👩‍⚕️'},
      {'name': 'İstənilən həkim', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
    'Laser': [
      {'name': 'Lalə Müseyibova', 'role': 'Lazer Mütəxəssisi', 'exp': '7 years', 'rating': '4.8', 'emoji': '✨'},
      {'name': 'İstənilən mütəxəssis', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
    'Auto': [
      {'name': 'Elnur Abdullayev', 'role': 'Baş Mexanik', 'exp': '12 years', 'rating': '4.7', 'emoji': '🔧'},
      {'name': 'İstənilən mexanik', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
    'Pet': [
      {'name': 'Dr. Aysel Quliyeva', 'role': 'Baytarlıq Həkimi', 'exp': '8 years', 'rating': '4.9', 'emoji': '🐾'},
      {'name': 'İstənilən mütəxəssis', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
    'Tattoo': [
      {'name': 'Rauf Əlizadə', 'role': 'Tattoo Ustası', 'exp': '10 years', 'rating': '4.9', 'emoji': '🎨'},
      {'name': 'İstənilən artist', 'role': 'Fərq etməz', 'exp': '', 'rating': '', 'emoji': '🎲'},
    ],
  };

  void _showBookingSheet(Map<String, dynamic> service) {
    final p = widget.provider;
    int _selectedDate = 0;
    int _selectedTime = -1;
    int _selectedStaff = -1;
    bool _loading = false;
    final staffList = _catStaff[p['cat'] as String] ?? [];

    final dates = List.generate(7, (i) {
      final d = DateTime.now().add(Duration(days: i));
      return {'label': i == 0 ? 'Bu gün' : i == 1 ? 'Sabah' : _weekday(d.weekday), 'day': d.day.toString()};
    });
    final times = ['09:00','09:30','10:00','10:30','11:00','11:30','13:00','13:30','14:00','14:30','15:00','16:00'];
    final blocked = {'10:00','11:30','14:30'};

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => Container(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(width: 40, height: 4,
              decoration: BoxDecoration(color: BronetColors.bgMuted, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Row(children: [
              Text(service['emoji'] as String, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(service['name'] as String, style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w800, color: BronetColors.textPrimary)),
                Text(p['name'] as String, style: TextStyle(fontSize: 13, color: BronetColors.textMuted)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: BronetColors.sageBg, borderRadius: BorderRadius.circular(10)),
                child: Text('${service['price'] == '0' ? 'Pulsuz' : service['price'] + ' AZN'}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: BronetColors.forest))),
            ]),
            const SizedBox(height: 4),
            Row(children: [
              const SizedBox(width: 46),
              Icon(Icons.schedule_rounded, size: 12, color: BronetColors.textLight),
              const SizedBox(width: 4),
              Text(service['duration'] as String, style: TextStyle(fontSize: 12, color: BronetColors.textMuted)),
            ]),
            // ── Staff Selection ──────────────────────────────────────
            if (staffList.isNotEmpty) ...[
              const SizedBox(height: 20),
              Align(alignment: Alignment.centerLeft, child: Text('Sizi kim xidmət edəcək?',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: BronetColors.textPrimary))),
              const SizedBox(height: 10),
              SizedBox(height: 100, child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: staffList.length,
                itemBuilder: (_, si) {
                  final staff = staffList[si];
                  final sel = _selectedStaff == si;
                  final noExp = (staff['exp'] as String).isEmpty;
                  return GestureDetector(
                    onTap: () => setS(() => _selectedStaff = si),
                    child: Container(
                      width: 90,
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: sel ? BronetColors.forest.withOpacity(0.08) : BronetColors.bgApp,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: sel ? BronetColors.forest : BronetColors.sage.withOpacity(0.3),
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text(staff['emoji'] as String, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(staff['name'] as String,
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800,
                            color: sel ? BronetColors.forest : BronetColors.textPrimary),
                          textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis),
                        if (!noExp) ...[
                          const SizedBox(height: 2),
                          Text('⭐ ${staff['rating']}', style: TextStyle(fontSize: 8, color: BronetColors.textMuted)),
                        ],
                        if (noExp)
                          Text(staff['role'] as String, style: TextStyle(fontSize: 8, color: BronetColors.textLight)),
                      ]),
                    ),
                  );
                },
              )),
            ],
            const SizedBox(height: 20),
            Align(alignment: Alignment.centerLeft, child: Text('Tarix Seçin',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: BronetColors.textPrimary))),
            const SizedBox(height: 10),
            SizedBox(height: 62, child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dates.length,
              itemBuilder: (_, i) {
                final sel = _selectedDate == i;
                return GestureDetector(
                  onTap: () => setS(() => _selectedDate = i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 50,
                    decoration: BoxDecoration(
                      color: sel ? BronetColors.forest : BronetColors.bgApp,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: sel ? BronetColors.forest : BronetColors.sage.withOpacity(0.3)),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(dates[i]['label']!, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                        color: sel ? Colors.white70 : BronetColors.textLight)),
                      const SizedBox(height: 2),
                      Text(dates[i]['day']!, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900,
                        color: sel ? Colors.white : BronetColors.textPrimary)),
                    ]),
                  ),
                );
              },
            )),
            const SizedBox(height: 16),
            Align(alignment: Alignment.centerLeft, child: Text('Vaxt Seçin',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: BronetColors.textPrimary))),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: times.map((t) {
              final isBlocked = blocked.contains(t);
              final sel = _selectedTime == times.indexOf(t);
              return GestureDetector(
                onTap: isBlocked ? null : () => setS(() => _selectedTime = times.indexOf(t)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: sel ? BronetColors.forest : isBlocked ? BronetColors.bgMuted : BronetColors.bgApp,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: sel ? BronetColors.forest
                        : isBlocked ? Colors.transparent
                        : BronetColors.sage.withOpacity(0.3)),
                  ),
                  child: Text(t, style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700,
                    color: sel ? Colors.white : isBlocked ? BronetColors.textLight : BronetColors.textPrimary,
                    decoration: isBlocked ? TextDecoration.lineThrough : null,
                  )),
                ),
              );
            }).toList()),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity,
              child: GestureDetector(
                onTap: _selectedTime < 0 || _loading ? null : () async {
                  setS(() => _loading = true);
                  final specialist = _selectedStaff >= 0 && staffList.isNotEmpty
                      ? staffList[_selectedStaff]['name'] as String
                      : 'İstənilən mütəxəssis';
                  final result = await BookingApi.createBooking(
                    clientName: AuthService.clientName,
                    service: service['name'] as String,
                    provider: p['name'] as String,
                    specialist: specialist,
                    date: dates[_selectedDate]['label']!,
                    time: times[_selectedTime],
                    price: '${service['price']} AZN',
                  );
                  if (!mounted) return;
                  Navigator.pop(ctx);
                  final id = result?['id'] ?? '';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(id.isNotEmpty
                        ? 'Rezervasiya göndərildi! $id — təsdiq gözlənilir 📲'
                        : 'Rezervasiya təsdiqləndi! 🎉'),
                    backgroundColor: BronetColors.forest,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: _selectedTime >= 0
                        ? const LinearGradient(colors: [BronetColors.forest, BronetColors.forestDeep])
                        : null,
                    color: _selectedTime < 0 ? BronetColors.bgMuted : null,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(child: _loading
                    ? const SizedBox(width: 22, height: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : Text(
                        _selectedTime < 0 ? 'Tarix və Vaxt Seçin' : 'Rezervasiyanı Təsdiqlə ✓',
                        style: TextStyle(
                          color: _selectedTime < 0 ? BronetColors.textLight : Colors.white,
                          fontSize: 15, fontWeight: FontWeight.w800,
                        ))),
                ),
              )),
          ])),
        ),
      ),
    );
  }

  String _weekday(int w) {
    const days = ['B.E','Ç.A','Çər','C.A','Cüm','Şnb','Baz'];
    return days[(w - 1) % 7];
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.provider;
    final services = _catServices[p['cat'] as String] ?? [];
    final open = p['open'] as bool;
    final color = Color(p['color'] as int);

    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      body: CustomScrollView(
        slivers: [
          // ── Header ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [BronetColors.forest, BronetColors.forestDeep],
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 38, height: 38,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(children: [
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
                        child: Center(child: Text(p['emoji'] as String, style: const TextStyle(fontSize: 34))),
                      ),
                      const SizedBox(width: 16),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: open ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(open ? '🟢 İndi Açıq' : '🔴 Bağlı',
                            style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w700,
                              color: open ? const Color(0xFF88FFB0) : const Color(0xFFFFAAAA),
                            )),
                        ),
                        const SizedBox(height: 6),
                        Text(p['name'] as String, style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.star_rounded, size: 13, color: Color(0xFFFFB830)),
                          const SizedBox(width: 3),
                          Text('${p['rating']} (${p['reviews']} rəy)',
                            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                        ]),
                        const SizedBox(height: 2),
                        Row(children: [
                          Icon(Icons.location_on_rounded, size: 13, color: Colors.white.withOpacity(0.6)),
                          const SizedBox(width: 3),
                          Text('${p['dist']} · Baku',
                            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
                        ]),
                      ])),
                    ]),
                  ]),
                ),
              ),
            ),
          ),

          // ── Services header ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 8),
              child: Row(children: [
                const Text('Mövcud Xidmətlər', style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: BronetColors.textPrimary)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: BronetColors.sageBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('${services.length}', style: TextStyle(
                    fontSize: 11, fontWeight: FontWeight.w700, color: BronetColors.sageDark)),
                ),
              ]),
            ),
          ),

          // ── Services list ────────────────────────────────────────────
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (ctx, i) {
                final s = services[i];
                final popular = s['popular'] as bool;
                final isFree = s['price'] == '0';
                return Container(
                  margin: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: BronetColors.bgCard,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: BronetColors.shadow,
                    border: popular
                        ? Border.all(color: BronetColors.forest.withOpacity(0.2))
                        : null,
                  ),
                  child: Row(children: [
                    // Emoji icon
                    Container(
                      width: 48, height: 48,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(child: Text(s['emoji'] as String,
                        style: const TextStyle(fontSize: 22))),
                    ),
                    const SizedBox(width: 14),
                    // Name + duration
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Flexible(child: Text(s['name'] as String, style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w800, color: BronetColors.textPrimary))),
                        if (popular) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: BronetColors.forest.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text('Populyar', style: TextStyle(
                              fontSize: 8, fontWeight: FontWeight.w800, color: BronetColors.forest)),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 3),
                      Row(children: [
                        Icon(Icons.schedule_rounded, size: 12, color: BronetColors.textLight),
                        const SizedBox(width: 4),
                        Text(s['duration'] as String, style: TextStyle(
                          fontSize: 12, color: BronetColors.textMuted)),
                      ]),
                    ])),
                    const SizedBox(width: 10),
                    // Price + Book button
                    Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text(isFree ? 'Pulsuz' : '${s['price']} AZN',
                        style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w900,
                          color: isFree ? BronetColors.green : BronetColors.forest)),
                      const SizedBox(height: 6),
                      GestureDetector(
                        onTap: open ? () => _showBookingSheet(s) : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                          decoration: BoxDecoration(
                            color: open ? BronetColors.forest : BronetColors.bgMuted,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(open ? 'Rezerv et' : 'Bağlı',
                            style: TextStyle(
                              color: open ? Colors.white : BronetColors.textLight,
                              fontSize: 12, fontWeight: FontWeight.w800)),
                        ),
                      ),
                    ]),
                  ]),
                );
              },
              childCount: services.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
