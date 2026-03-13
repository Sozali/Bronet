class AuthService {
  static bool isLoggedIn = false;
  static Map<String, String> currentUser = {};

  static const List<Map<String, String>> _users = [
    {
      'name': 'Ismayil Məmmədov',
      'phone': '+994 50 123 45 67',
      'email': 'ismayil@bronet.az',
      'password': 'Bronet123',
    },
  ];

  static bool login(String phoneOrEmail, String password) {
    final input = phoneOrEmail.trim();
    for (final u in _users) {
      if ((u['phone'] == input || u['email'] == input) &&
          u['password'] == password) {
        isLoggedIn = true;
        currentUser = Map<String, String>.from(u);
        return true;
      }
    }
    return false;
  }

  static void register({
    required String name,
    required String phone,
    required String email,
    required String password,
  }) {
    isLoggedIn = true;
    currentUser = {
      'name': name,
      'phone': phone,
      'email': email,
      'password': password,
    };
  }

  static void logout() {
    isLoggedIn = false;
    currentUser = {};
  }

  static String get clientName => currentUser['name'] ?? 'Guest';
  static String get displayName => currentUser['name'] ?? 'Guest';
  static String get firstName =>
      (currentUser['name'] ?? 'Guest').split(' ').first;
  static String get phone => currentUser['phone'] ?? '';
  static String get email => currentUser['email'] ?? '';
}
