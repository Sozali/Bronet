import 'package:flutter/material.dart';
import '../theme/colors.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _defaultIdx = 0;

  final List<Map<String, dynamic>> _cards = [
    {'type': 'Visa', 'last4': '4242', 'expiry': '12/26', 'emoji': '💳'},
  ];

  void _showAddCardSheet() {
    final numberCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    final cvvCtrl = TextEditingController();
    final nameCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: BronetColors.bgMuted, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            const Center(child: Text('Kart əlavə et', style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900, color: BronetColors.textPrimary))),
            const SizedBox(height: 20),
            _field('Kart nömrəsi', '0000 0000 0000 0000', numberCtrl, TextInputType.number),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _field('Bitmə tarixi', 'MM/YY', expiryCtrl, TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: _field('CVV', '•••', cvvCtrl, TextInputType.number, obscure: true)),
            ]),
            const SizedBox(height: 12),
            _field('Kart sahibinin adı', 'Ad Soyad', nameCtrl, TextInputType.name),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (numberCtrl.text.length >= 4) {
                    final last4 = numberCtrl.text.replaceAll(' ', '');
                    final l4 = last4.length >= 4 ? last4.substring(last4.length - 4) : '0000';
                    setState(() => _cards.add({'type': 'Card', 'last4': l4, 'expiry': expiryCtrl.text, 'emoji': '💳'}));
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Kart uğurla əlavə edildi'),
                    backgroundColor: BronetColors.forest,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BronetColors.forest,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Kartı Əlavə Et', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _field(String label, String hint, TextEditingController ctrl, TextInputType type, {bool obscure = false}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: BronetColors.forest, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) => Padding(
    padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
    child: Text(label, style: const TextStyle(
      fontSize: 13, fontWeight: FontWeight.w800,
      color: BronetColors.textMuted, letterSpacing: 0.5)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      appBar: AppBar(
        backgroundColor: BronetColors.forest,
        foregroundColor: Colors.white,
        title: const Text('Ödəniş Üsulları', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Saved cards
          _buildSectionLabel('SAXLANAN KARTLAR'),
          ..._cards.asMap().entries.map((e) {
            final i = e.key;
            final card = e.value;
            final isDefault = _defaultIdx == i;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: BronetColors.bgCard,
                borderRadius: BorderRadius.circular(18),
                boxShadow: BronetColors.shadow,
                border: isDefault ? Border.all(color: BronetColors.forest, width: 2) : null,
              ),
              child: Row(children: [
                Container(
                  width: 46, height: 46,
                  decoration: BoxDecoration(
                    color: BronetColors.forest.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(child: Text(card['emoji'] as String, style: const TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('${card['type']} •• ${card['last4']}', style: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w800, color: BronetColors.textPrimary)),
                  const SizedBox(height: 3),
                  Text('Bitmə tarixi: ${card['expiry']}', style: TextStyle(
                    fontSize: 12, color: BronetColors.textMuted)),
                ])),
                if (isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: BronetColors.forest.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Əsas', style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700, color: BronetColors.forest)),
                  )
                else
                  GestureDetector(
                    onTap: () => setState(() => _defaultIdx = i),
                    child: Text('Əsas seç', style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600, color: BronetColors.sageDark)),
                  ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => setState(() {
                    _cards.removeAt(i);
                    if (_defaultIdx >= _cards.length) _defaultIdx = 0;
                  }),
                  child: Icon(Icons.delete_outline_rounded, color: BronetColors.red, size: 20),
                ),
              ]),
            );
          }).toList(),

          // Add payment options
          _buildSectionLabel('ÖDƏNIŞ ÜSULU ƏLAVƏ ET'),
          _buildOptionTile('💳', 'Kredit/Debet Kartı', 'Visa, Mastercard, yerli kartlar', () => _showAddCardSheet()),
          _buildOptionTile('🍎', 'Apple Pay', 'Apple Pay cüzdanını qoşun', () => _showToggleSheet('Apple Pay', '🍎')),
          _buildOptionTile('🤖', 'Google Pay', 'Google Pay qoşun', () => _showToggleSheet('Google Pay', '🤖')),
          _buildOptionTile('🏦', 'Bank Köçürməsi', 'IBAN köçürməsi ilə ödəyin', () => _showIbanSheet()),

          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: BronetColors.forest.withOpacity(0.06),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: BronetColors.forest.withOpacity(0.15)),
            ),
            child: Row(children: [
              Icon(Icons.lock_rounded, size: 16, color: BronetColors.sageDark),
              const SizedBox(width: 10),
              Expanded(child: Text('Ödəniş məlumatlarınız şifrələnmiş və təhlükəsizdir.',
                style: TextStyle(fontSize: 12, color: BronetColors.textMuted))),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildOptionTile(String emoji, String title, String subtitle, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BronetColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          boxShadow: BronetColors.shadow,
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: BronetColors.bgSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: BronetColors.textPrimary)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(fontSize: 12, color: BronetColors.textMuted)),
          ])),
          Icon(Icons.chevron_right_rounded, color: BronetColors.textLight, size: 20),
        ]),
      ),
    );
  }

  void _showToggleSheet(String name, String emoji) {
    bool connected = false;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Center(child: Container(width: 40, height: 4,
            decoration: BoxDecoration(color: BronetColors.bgMuted, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Text('$emoji $name', style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w900, color: BronetColors.textPrimary)),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('$name qoşulub', style: const TextStyle(fontSize: 14, color: BronetColors.textPrimary)),
            Switch(
              value: connected,
              onChanged: (v) => setS(() => connected = v),
              activeColor: BronetColors.forest,
            ),
          ]),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$name ${connected ? "qoşuldu" : "ayrıldı"}'),
                  backgroundColor: BronetColors.forest,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: BronetColors.forest,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Saxla', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      )),
    );
  }

  void _showIbanSheet() {
    final ibanCtrl = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 36),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: BronetColors.bgMuted, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            const Center(child: Text('Bank Köçürməsi', style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900, color: BronetColors.textPrimary))),
            const SizedBox(height: 20),
            _field('IBAN', 'AZ00 BANK 0000 0000 0000 0000', ibanCtrl, TextInputType.text),
            const SizedBox(height: 24),
            SizedBox(width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Bank IBAN yadda saxlandı'),
                    backgroundColor: BronetColors.forest,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: BronetColors.forest,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('IBAN Saxla', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
