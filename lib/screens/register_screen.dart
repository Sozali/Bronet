import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text;
    final confirm = _confirmCtrl.text;

    if (name.isEmpty || phone.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Bütün tələb olunan sahələri doldurun.');
      return;
    }
    if (pass != confirm) {
      setState(() => _error = 'Şifrələr uyğun gəlmir.');
      return;
    }
    if (pass.length < 6) {
      setState(() => _error = 'Şifrə ən az 6 simvol olmalıdır.');
      return;
    }

    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 400));

    AuthService.register(
      name: name,
      phone: phone,
      email: email,
      password: pass,
    );

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/root');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Hesab Yarat', style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w900,
                    color: BronetColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  Text('BRON\'ET-ə qoşulun və xidmətlər rezerv edin', style: TextStyle(
                    fontSize: 14, color: BronetColors.textMuted,
                  )),
                  const SizedBox(height: 24),

                  _buildLabel('Ad Soyad *'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameCtrl,
                    style: TextStyle(color: BronetColors.textPrimary, fontSize: 15),
                    decoration: _inputDecoration(hint: 'Adınız və soyadınız', icon: Icons.person_outline_rounded),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Telefon Nömrəsi *'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.phone,
                    style: TextStyle(color: BronetColors.textPrimary, fontSize: 15),
                    decoration: _inputDecoration(hint: '+994 50 000 00 00', icon: Icons.phone_outlined),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('E-poçt (isteğe bağlı)'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: BronetColors.textPrimary, fontSize: 15),
                    decoration: _inputDecoration(hint: 'your@email.com', icon: Icons.email_outlined),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Şifrə *'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscurePass,
                    style: TextStyle(color: BronetColors.textPrimary, fontSize: 15),
                    decoration: _inputDecoration(
                      hint: 'Min. 6 simvol',
                      icon: Icons.lock_outline_rounded,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: BronetColors.textLight, size: 20,
                        ),
                        onPressed: () => setState(() => _obscurePass = !_obscurePass),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Şifrəni Təsdiqlə *'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _confirmCtrl,
                    obscureText: _obscureConfirm,
                    style: TextStyle(color: BronetColors.textPrimary, fontSize: 15),
                    decoration: _inputDecoration(
                      hint: 'Şifrəni yenidən daxil edin',
                      icon: Icons.lock_outline_rounded,
                      suffix: IconButton(
                        icon: Icon(
                          _obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: BronetColors.textLight, size: 20,
                        ),
                        onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                      ),
                    ),
                  ),

                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: BronetColors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: BronetColors.red.withOpacity(0.2)),
                      ),
                      child: Row(children: [
                        Icon(Icons.error_outline_rounded, color: BronetColors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(_error!, style: TextStyle(
                          color: BronetColors.red, fontSize: 12,
                        ))),
                      ]),
                    ),
                  ],

                  const SizedBox(height: 28),

                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: _loading ? null : _register,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [BronetColors.forest, BronetColors.forestDeep],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: BronetColors.shadowStrong,
                        ),
                        child: Center(
                          child: _loading
                              ? const SizedBox(
                                  width: 22, height: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2.5))
                              : const Text('Hesab Yarat', style: TextStyle(
                                  color: Colors.white, fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                )),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Artıq hesabınız var? ', style: TextStyle(
                        color: BronetColors.textMuted, fontSize: 14,
                      )),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text('Daxil Ol', style: TextStyle(
                          color: BronetColors.forest, fontSize: 14,
                          fontWeight: FontWeight.w800,
                        )),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [BronetColors.forest, BronetColors.forestDeep],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 20),
            ),
          ),
          const SizedBox(height: 16),
          const Text('BRON\'ET-ə Qoşulun', style: TextStyle(
            color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900,
          )),
          const SizedBox(height: 6),
          Text('Saniyələr içində hesabınızı yaradın', style: TextStyle(
            color: Colors.white.withOpacity(0.65), fontSize: 14,
          )),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: BronetColors.textLight, fontSize: 14),
      prefixIcon: Icon(icon, color: BronetColors.textLight, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: BronetColors.bgCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: BronetColors.sage.withOpacity(0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: BronetColors.sage.withOpacity(0.25)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: BronetColors.forest, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: TextStyle(
      fontSize: 12, fontWeight: FontWeight.w700,
      color: BronetColors.textMuted, letterSpacing: 0.3,
    ));
  }
}
