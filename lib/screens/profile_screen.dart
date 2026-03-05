import 'package:flutter/material.dart';
import '../theme/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notifications = true;
  bool _locationAccess = true;
  bool _faceId = false;

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
              _buildSectionLabel('Account'),
              _buildMenuItem(Icons.person_outline_rounded, 'Edit Profile', 'Update your info', null, () {}),
              _buildMenuItem(Icons.location_on_outlined, 'Saved Addresses', '3 addresses', null, () {}),
              _buildMenuItem(Icons.credit_card_rounded, 'Payment Methods', 'Visa •• 4242', null, () {}),
              _buildMenuItem(Icons.favorite_outline_rounded, 'Favourites', '12 saved', null, () {}),
              _buildSectionLabel('Preferences'),
              _buildToggleItem(Icons.notifications_outlined, 'Notifications', 'Booking reminders & deals', _notifications, (v) => setState(() => _notifications = v)),
              _buildToggleItem(Icons.location_searching_rounded, 'Location Access', 'For nearby providers', _locationAccess, (v) => setState(() => _locationAccess = v)),
              _buildToggleItem(Icons.fingerprint_rounded, 'Face ID / Fingerprint', 'Quick login', _faceId, (v) => setState(() => _faceId = v)),
              _buildSectionLabel('Support'),
              _buildMenuItem(Icons.help_outline_rounded, 'Help Center', 'FAQ & guides', null, () {}),
              _buildMenuItem(Icons.chat_bubble_outline_rounded, 'Live Chat', 'We reply in minutes', null, () {}),
              _buildMenuItem(Icons.star_outline_rounded, 'Rate the App', 'Love Bronet? Tell us!', null, () {}),
              _buildMenuItem(Icons.share_outlined, 'Invite Friends', 'Get 10 AZN credit', const Color(0xFFA8B6A1), () {}),
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
          colors: [Color(0xFF2C3528), Color(0xFF1E2A1A)],
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
                  border: Border.all(color: const Color(0xFF2C3528), width: 2),
                ),
                child: const Center(
                  child: Icon(Icons.edit_rounded,
                    size: 10, color: Color(0xFF2C3528)),
                ),
              ),
            ),
          ]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ismayil Məmmədov', style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                )),
                const SizedBox(height: 3),
                Text('+994 50 123 45 67', style: TextStyle(
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
      {'value': '7', 'label': 'Bookings'},
      {'value': '4.9', 'label': 'Avg Rating'},
      {'value': '284₼', 'label': 'Total Spent'},
      {'value': '3', 'label': 'Favourites'},
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
                const Text('🎁', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text('Loyalty Points', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: BronetColors.forest,
                )),
              ]),
              Text('2,840 pts', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: BronetColors.sageDark,
              )),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.71,
              minHeight: 8,
              backgroundColor: BronetColors.bgMuted,
              valueColor: AlwaysStoppedAnimation<Color>(BronetColors.sage),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('2,840 / 4,000 pts to Platinum',
                style: TextStyle(
                  fontSize: 11,
                  color: BronetColors.textMuted,
                )),
              Text('1,160 pts left', style: TextStyle(
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

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
      child: GestureDetector(
        onTap: () {},
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
              Text('Log Out', style: TextStyle(
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
