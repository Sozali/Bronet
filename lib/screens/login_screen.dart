import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme/colors.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _savePassword = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() { _loading = true; _error = null; });
    final err = await AuthService.login(_phoneCtrl.text, _passCtrl.text);
    if (!mounted) return;
    if (err == null) {
      // AuthGate in main.dart will automatically navigate to RootScreen
    } else {
      setState(() {
        _loading = false;
        _error = err;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BronetColors.bgApp,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Xoş gəlmisiniz!', style: TextStyle(
                    fontSize: 22, fontWeight: FontWeight.w900,
                    color: BronetColors.textPrimary,
                  )),
                  const SizedBox(height: 4),
                  Text('Xidmətləri rezerv etmək üçün daxil olun', style: TextStyle(
                    fontSize: 14, color: BronetColors.textMuted,
                  )),
                  const SizedBox(height: 28),

                  // Phone / Email field
                  _buildLabel('Telefon və ya E-poçt'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _phoneCtrl,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: BronetColors.textPrimary, fontSize: 15),
                    decoration: _inputDecoration(
                      hint: '+994 50 123 45 67',
                      icon: Icons.phone_outlined,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Password field
                  _buildLabel('Şifrə'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passCtrl,
                    obscureText: _obscure,
                    style: TextStyle(color: BronetColors.textPrimary, fontSize: 15),
                    decoration: _inputDecoration(
                      hint: 'Şifrənizi daxil edin',
                      icon: Icons.lock_outline_rounded,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: BronetColors.textLight, size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Save password row
                  Row(
                    children: [
                      SizedBox(
                        width: 20, height: 20,
                        child: Checkbox(
                          value: _savePassword,
                          activeColor: BronetColors.forest,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                          onChanged: (v) => setState(() => _savePassword = v ?? false),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('Şifrəni yadda saxla', style: TextStyle(
                        fontSize: 13, color: BronetColors.textMuted,
                      )),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: Text('Şifrəni unutdunuz?', style: TextStyle(
                          fontSize: 13, color: BronetColors.forest,
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                    ],
                  ),

                  // Error message
                  if (_error != null) ...[
                    const SizedBox(height: 12),
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

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: _loading ? null : _login,
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
                              : const Text('Daxil Ol', style: TextStyle(
                                  color: Colors.white, fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                )),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Hesabınız yoxdur? ", style: TextStyle(
                        color: BronetColors.textMuted, fontSize: 14,
                      )),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const RegisterScreen())),
                        child: Text('Qeydiyyat', style: TextStyle(
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 60, 24, 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [BronetColors.forest, BronetColors.forestDeep],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              width: 42, height: 42,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('B', style: TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900,
                )),
              ),
            ),
            const SizedBox(width: 10),
            RichText(text: const TextSpan(
              children: [
                TextSpan(text: "BRON", style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900,
                )),
                TextSpan(text: "'ET", style: TextStyle(
                  color: Colors.white70, fontSize: 20, fontWeight: FontWeight.w400,
                )),
              ],
            )),
          ]),
          const SizedBox(height: 20),
          const Text('Hesabınıza\ndaxil olun', style: TextStyle(
            color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900,
            height: 1.2,
          )),
          const SizedBox(height: 8),
          Text('Xidmətlər rezerv edin, sadiqlik xalları qazanın', style: TextStyle(
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
