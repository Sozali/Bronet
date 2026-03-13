import 'package:flutter/material.dart';
import '../theme/colors.dart';
import '../services/booking_api.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'payment_screen.dart';
import 'subscription_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;
  bool _locationAccess = true;
  bool _faceId = false;
  int _points = 2840;
  bool _loadingPoints = false;

  @override
  void initState() {
    super.initState();
    _loadPoints();
  }

  Future<void> _loadPoints() async {
    setState(() => _loadingPoints = true);
    final pts = await BookingApi.getPoints(AuthService.clientName);
    if (mounted) setState(() { _points = pts; _loadingPoints = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildStatsRow(),
              _buildLoyaltyCard(),
              _buildSectionLabel('Hesab'),
              _buildMenuItem(Icons.person_outline_rounded, 'Profili Redaktə et', 'Məlumatlarınızı yeniləyin', null, () {}),
              _buildMenuItem(Icons.location_on_outlined, 'Yadda saxlanmış ünvanlar', '3 ünvan', null, () {}),
              _buildMenuItem(Icons.credit_card_rounded, 'Ödəniş Üsulları', 'Visa •• 4242', null, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentScreen()));
              }),
              _buildMenuItem(Icons.favorite_outline_rounded, 'Sevimlilər', '12 saxlanmış', null, () {}),
              _buildMenuItem(Icons.workspace_premium_rounded, 'Abunəlik Planı', 'Qızıl Üzv', BronetColors.amber, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionScreen()));
              }),
              _buildSectionLabel('Parametrlər'),
              _buildToggleItem(Icons.notifications_outlined, 'Bildirişlər', 'Rezerv xatırlatmaları', _notifications, (v) => setState(() => _notifications = v)),
              _buildToggleItem(Icons.location_searching_rounded, 'Yerə Giriş', 'Yaxın xidmət üçün', _locationAccess, (v) => setState(() => _locationAccess = v)),
              _buildToggleItem(Icons.fingerprint_rounded, 'Barmaq izi / Face ID', 'Sürətli giriş', _faceId, (v) => setState(() => _faceId = v)),
              _buildSectionLabel('Dəstək'),
              _buildMenuItem(Icons.help_outline_rounded, 'Kömək Mərkəzi', 'FAQ & bələdçilər', null, () {}),
              _buildMenuItem(Icons.chat_bubble_outline_rounded, 'Canlı Söhbət', 'Dəqiqələrdə cavab veririk', null, () {}),
              _buildMenuItem(Icons.star_outline_rounded, 'Tətbiqi Qiymətləndir', 'Bronet-i sevirsiniz?', null, () {}),
              _buildMenuItem(Icons.share_outlined, 'Dostları Dəvət Et', 'Hər dost üçün 500 xal', BronetColors.sage, () {}),
              _buildSectionLabel(''),
              _buildLogoutButton(),
              const SizedBox(height: 32),
              Text("BRON'ET v1.0.0", style: TextStyle(
                fontSize: 11,
                color: BronetColors.textLight,
              )),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [BronetColors.forest, BronetColors.forestDeep],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: BronetColors.shadowStrong,
      ),
      child: Row(
        children: [
          Stack(children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: BronetColors.sage.withOpacity(0.25),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(
                  color: BronetColors.sage.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text('👤', style: TextStyle(fontSize: 30)),
              ),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: BronetColors.sage,
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: BronetColors.forest, width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.edit_rounded,
                    size: 10, color: Colors.white),
                ),
              ),
            ),
          ]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AuthService.displayName, style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                )),
                const SizedBox(height: 3),
                Text(AuthService.phone, style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 13,
                )),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: BronetColors.sage.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: BronetColors.sage.withOpacity(0.35)),
                  ),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      width: 6, height: 6,
                      decoration: BoxDecoration(
                        color: BronetColors.sage,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text('Gold Member', style: TextStyle(
                      color: BronetColors.sage,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    )),
                  ]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.qr_code_rounded,
              color: Colors.white.withOpacity(0.7), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'value': '7', 'label': 'Rezervlər'},
      {'value': '4.9', 'label': 'Ort. Reytinq'},
      {'value': '284₼', 'label': 'Ümumi Xərc'},
      {'value': '3', 'label': 'Sevimlilər'},
    ];
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: BronetColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: BronetColors.shadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats.map((s) {
          return Column(children: [
            Text(s['value']!, style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: BronetColors.forest,
            )),
            const SizedBox(height: 3),
            Text(s['label']!, style: TextStyle(
              fontSize: 10,
              color: BronetColors.textMuted,
              fontWeight: FontWeight.w600,
            )),
          ]);
        }).toList(),
      ),
    );
  }

  Widget _buildLoyaltyCard() {
    const target = 4000;
    final progress = (_points / target).clamp(0.0, 1.0);
    final remaining = (target - _points).clamp(0, target);
    final azn = (_points / 200).floor(); // 1000 pts = 5 AZN → 200 pts = 1 AZN

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: BronetColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: BronetColors.sage.withOpacity(0.25)),
        boxShadow: BronetColors.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Text('⭐', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text('Sadiqlik Xalları', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: BronetColors.forest,
                )),
              ]),
              _loadingPoints
                  ? SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: BronetColors.sage,
                      ))
                  : GestureDetector(
                      onTap: _loadPoints,
                      child: Text(
                        '${_points.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} pts',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: BronetColors.sageDark,
                        )),
                    ),
            ],
          ),
          const SizedBox(height: 8),
          // Cash value line
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFFB830).withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.monetization_on_rounded,
                color: Color(0xFFD48A00), size: 14),
              const SizedBox(width: 5),
              Text('Dəyəri $azn ₼ · 1.000 xal = 5 ₼',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFD48A00),
                )),
            ]),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: BronetColors.bgMuted,
              valueColor: AlwaysStoppedAnimation<Color>(BronetColors.sage),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$_points / $target xal Platinuma',
                style: TextStyle(
                  fontSize: 11,
                  color: BronetColors.textMuted,
                )),
              Text('$remaining xal qaldı', style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: BronetColors.sageDark,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    if (label.isEmpty) return const SizedBox(height: 8);
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 18, 8),
      child: Text(label.toUpperCase(), style: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        color: BronetColors.textLight,
        letterSpacing: 1.5,
      )),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    Color? accentColor,
    VoidCallback onTap,
  ) {
    final color = accentColor ?? BronetColors.forest;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: BoxDecoration(
          color: BronetColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: BronetColors.shadow,
        ),
        child: Row(children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 19),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: BronetColors.textPrimary,
                )),
                Text(subtitle, style: TextStyle(
                  fontSize: 11,
                  color: BronetColors.textMuted,
                )),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded,
            color: BronetColors.textLight, size: 20),
        ]),
      ),
    );
  }

  Widget _buildToggleItem(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: BronetColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: BronetColors.shadow,
      ),
      child: Row(children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: BronetColors.forest.withOpacity(0.10),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Center(
            child: Icon(icon, color: BronetColors.forest, size: 19),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: BronetColors.textPrimary,
              )),
              Text(subtitle, style: TextStyle(
                fontSize: 11,
                color: BronetColors.textMuted,
              )),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: BronetColors.sage,
          activeTrackColor: BronetColors.sage.withOpacity(0.3),
          inactiveThumbColor: BronetColors.textLight,
          inactiveTrackColor: BronetColors.bgMuted,
        ),
      ]),
    );
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Çıxış', style: TextStyle(
          fontWeight: FontWeight.w800, color: BronetColors.textPrimary)),
        content: const Text('Çıxmaq istədiyinizdən əminsiniz?',
          style: TextStyle(fontSize: 14, color: BronetColors.textMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Ləğv et', style: TextStyle(color: BronetColors.textMuted)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              AuthService.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (_) => false,
              );
            },
            child: const Text('Çıxış',
              style: TextStyle(color: Color(0xFFFF4D6A), fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      child: GestureDetector(
        onTap: _confirmLogout,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            color: BronetColors.red.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: BronetColors.red.withOpacity(0.20)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: BronetColors.red, size: 18),
              const SizedBox(width: 8),
              Text('Çıxış', style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: BronetColors.red,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
