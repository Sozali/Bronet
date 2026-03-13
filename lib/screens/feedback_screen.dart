import 'package:flutter/material.dart';
import '../theme/colors.dart';

class FeedbackScreen extends StatefulWidget {
  final String serviceName;
  final String providerName;
  final String emoji;

  const FeedbackScreen({
    super.key,
    required this.serviceName,
    required this.providerName,
    this.emoji = '⭐',
  });

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int _stars = 0;
  final TextEditingController _reviewCtrl = TextEditingController();
  final List<String> _allTags = [
    'Təmiz', 'Peşəkar', 'Vaxtında', 'Mehriban', 'Əla Qiymət'
  ];
  final Set<String> _selectedTags = {};

  @override
  void dispose() {
    _reviewCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_stars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Ulduz reytinqi seçin'),
        backgroundColor: BronetColors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: const Text('Rəyiniz üçün təşəkkür edirik! ⭐'),
      backgroundColor: BronetColors.forest,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
    Navigator.pop(context, {'stars': _stars, 'tags': _selectedTags.toList(), 'review': _reviewCtrl.text});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      appBar: AppBar(
        backgroundColor: BronetColors.forest,
        foregroundColor: Colors.white,
        title: const Text('Xidməti Qiymətləndir', style: TextStyle(
          fontWeight: FontWeight.w800, fontSize: 16)),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 12),
            // Service header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [BronetColors.forest, BronetColors.forestDeep],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: BronetColors.shadow,
              ),
              child: Column(children: [
                Text(widget.emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 10),
                Text(widget.serviceName, style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
                const SizedBox(height: 4),
                Text(widget.providerName, style: TextStyle(
                  fontSize: 13, color: Colors.white.withOpacity(0.7))),
              ]),
            ),
            const SizedBox(height: 28),

            // Star rating
            const Text('Xidmət necə idi?', style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800, color: BronetColors.textPrimary)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final filled = i < _stars;
                return GestureDetector(
                  onTap: () => setState(() => _stars = i + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      filled ? Icons.star_rounded : Icons.star_outline_rounded,
                      size: 44,
                      color: filled ? const Color(0xFFFFB830) : BronetColors.bgMuted,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 6),
            if (_stars > 0)
              Text(
                _stars == 1 ? 'Zəif' : _stars == 2 ? 'Orta' : _stars == 3 ? 'Yaxşı' : _stars == 4 ? 'Çox Yaxşı' : 'Əla!',
                style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700,
                  color: _stars >= 4 ? BronetColors.green : _stars == 3 ? BronetColors.sageDark : BronetColors.red,
                ),
              ),
            const SizedBox(height: 24),

            // Tags
            Align(alignment: Alignment.centerLeft,
              child: const Text('Nə xoşunuza gəldi?', style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: BronetColors.textPrimary))),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8,
              children: _allTags.map((tag) {
                final sel = _selectedTags.contains(tag);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (sel) _selectedTags.remove(tag); else _selectedTags.add(tag);
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel ? BronetColors.forest : BronetColors.bgCard,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? BronetColors.forest : BronetColors.sage.withOpacity(0.3)),
                      boxShadow: sel ? BronetColors.shadow : [],
                    ),
                    child: Text(tag, style: TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600,
                      color: sel ? Colors.white : BronetColors.textMuted,
                    )),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Written review
            Align(alignment: Alignment.centerLeft,
              child: const Text('Rəy yazın (isteğe bağlı)', style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w700, color: BronetColors.textPrimary))),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: BronetColors.bgCard,
                borderRadius: BorderRadius.circular(16),
                boxShadow: BronetColors.shadow,
              ),
              child: TextField(
                controller: _reviewCtrl,
                maxLines: 4,
                style: const TextStyle(fontSize: 14, color: BronetColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Təcrübənizi başqaları ilə bölüşün...',
                  hintStyle: TextStyle(fontSize: 13, color: BronetColors.textLight),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: BronetColors.forest,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                ),
                child: const Text('Rəy Göndər', style: TextStyle(
                  color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
