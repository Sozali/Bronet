import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  static final _client = Supabase.instance.client;

  static User? get currentUser => _client.currentUser;
  static bool get isLoggedIn => currentUser != null;

  static String get clientName =>
      currentUser?.userMetadata?['full_name'] as String? ?? 'Qonaq';
  static String get displayName => clientName;
  static String get firstName => clientName.split(' ').first;
  static String get phone =>
      currentUser?.userMetadata?['phone'] as String? ?? '';
  static String get email => currentUser?.email ?? '';

  /// Returns null on success, or an error message string on failure.
  static Future<String?> login(String emailOrPhone, String password) async {
    try {
      await _client.auth.signInWithPassword(
        email: emailOrPhone.trim(),
        password: password,
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Giriş zamanı xəta baş verdi';
    }
  }

  /// Returns null on success, or an error message string on failure.
  static Future<String?> register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signUp(
        email: email.trim(),
        password: password,
        data: {'full_name': name, 'phone': phone},
      );
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Qeydiyyat zamanı xəta baş verdi';
    }
  }

  static Future<void> logout() async {
    await _client.auth.signOut();
  }

  static Future<Map<String, dynamic>?> getProfile() async {
    try {
      final uid = currentUser?.id;
      if (uid == null) return null;
      return await _client
          .from('profiles')
          .select()
          .eq('id', uid)
          .single();
    } catch (_) {
      return null;
    }
  }

  static Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      final uid = currentUser?.id;
      if (uid == null) return false;
      await _client.from('profiles').update(data).eq('id', uid);
      return true;
    } catch (_) {
      return false;
    }
  }
}
