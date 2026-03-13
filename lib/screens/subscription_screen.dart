import 'package:flutter/material.dart';
import '../theme/colors.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int _currentPlan = 0; // 0=Basic, 1=Silver, 2=Gold

  final List<Map<String, dynamic>> _plans = [
    {
      'name': 'Basic',
      'price': 'Pulsuz',
      'priceNum': 0.0,
      'color': 0xFF6B7280,
      'accentColor': 0xFFE5E7EB,
      'emoji': '🌱',
      'features': [
        'Ayda 3 rezervasiya',
        'Standart dəstək',
        'Əsas sadiqlik xalları qazanın',
        'Bütün xidmətlərə giriş',
      ],
    },
    {
      'name': 'Silver',
      'price': '9.99 AZN',
      'priceNum': 9.99,
      'color': 0xFF6B7280,
      'accentColor': 0xFFD1D5DB,
      'emoji': '🥈',
      'features': [
        'Limitsiz rezervasiya',
        'Prioritet dəstək',
        'İkiqat sadiqlik xalları (2x)',
        'Sürətli Endirimləre giriş',
        '2 saat əvvələdək pulsuz ləğv',
      ],
    },
    {
      'name': 'Gold',
      'price': '19.99 AZN',
      'priceNum': 19.99,
      'color': 0xFFD48A00,
      'accentColor': 0xFFFFB830,
      'emoji': '🥇',
      'features': [
        'Üçqat sadiqlik xalları (3x)',
        'Eksklüziv Qızıl endirimlər',
        'Tövsiyə siyahısında birinci',
        'Şəxsi konsyerj dəstəyi',
        'İstənilən vaxt pulsuz ləğv',
        'Aylıq bonus: 500 xal hədiyyə',
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      appBar: AppBar(
        backgroundColor: BronetColors.forest,
        foregroundColor: Colors.white,
        title: const Text('Abunəlik Planları', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [BronetColors.forest, BronetColors.forestDeep]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: BronetColors.shadow,
            ),
            child: Column(children: [
              const Text('Planınızı Seçin', style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(height: 6),
              Text('Daha çox xüsusiyyət açın, daha sürətli qazanın',
                style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.7))),
            ]),
          ),
          const SizedBox(height: 20),

          // Plan cards
          ..._plans.asMap().entries.map((entry) {
            final i = entry.key;
            final plan = entry.value;
            final isCurrent = _currentPlan == i;
            final color = Color(plan['color'] as int);
            final accentColor = Color(plan['accentColor'] as int);
            final features = plan['features'] as List<String>;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: BronetColors.bgCard,
                borderRadius: BorderRadius.circular(20),
                boxShadow: BronetColors.shadow,
                border: isCurrent
                    ? Border.all(color: color, width: 2.5)
                    : Border.all(color: BronetColors.bgMuted, width: 1),
              ),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Plan header
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.15),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: Row(children: [
                    Text(plan['emoji'] as String, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text(plan['name'] as String, style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w900, color: color)),
                        if (isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: BronetColors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(mainAxisSize: MainAxisSize.min, children: [
                              Icon(Icons.check_circle_rounded, size: 10, color: BronetColors.green),
                              const SizedBox(width: 3),
                              Text('Cari Plan', style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.w700, color: BronetColors.green)),
                            ]),
                          ),
                        ],
                      ]),
                      const SizedBox(height: 2),
                      RichText(text: TextSpan(children: [
                        TextSpan(text: plan['price'] as String, style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w900, color: color)),
                        if ((plan['priceNum'] as double) > 0)
                          TextSpan(text: '/ay', style: TextStyle(
                            fontSize: 11, color: BronetColors.textMuted)),
                      ])),
                    ])),
                  ]),
                ),

                // Features list
                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(children: [
                          Icon(Icons.check_rounded, size: 16, color: color),
                          const SizedBox(width: 10),
                          Expanded(child: Text(f, style: const TextStyle(
                            fontSize: 13, color: BronetColors.textPrimary))),
                        ]),
                      )).toList(),
                      const SizedBox(height: 10),
                      if (!isCurrent)
                        SizedBox(width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => _currentPlan = i);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('${plan['name']} planına abunə oldunuz!'),
                                backgroundColor: BronetColors.forest,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            child: Text(
                              _currentPlan > i ? '${plan['name']} planına keç' : '${plan['name']} planına yüksəlt',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 14)),
                          ),
                        )
                      else
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: BronetColors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: BronetColors.green.withOpacity(0.3)),
                          ),
                          child: Center(child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Icon(Icons.check_circle_rounded, size: 16, color: BronetColors.green),
                            const SizedBox(width: 6),
                            Text('Aktiv Plan', style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w800, color: BronetColors.green)),
                          ])),
                        ),
                    ],
                  ),
                ),
              ]),
            );
          }).toList(),

          const SizedBox(height: 10),
          Text('Aylıq ödəniş · İstənilən vaxt ləğv edin',
            style: TextStyle(fontSize: 12, color: BronetColors.textLight)),
          const SizedBox(height: 24),
        ]),
      ),
    );
  }
}
