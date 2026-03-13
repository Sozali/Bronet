import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/deals_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const BronetApp());
}

class BronetApp extends StatelessWidget {
  const BronetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "BRON'ET",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEF5FB),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A6CC5),
        ),
      ),
      home: AuthService.isLoggedIn ? const RootScreen() : const LoginScreen(),
      routes: {
        '/root': (_) => const RootScreen(),
        '/login': (_) => const LoginScreen(),
      },
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _currentTab = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(onExploreRequest: () => setState(() => _currentTab = 1)),
      const ExploreScreen(),
      const DealsScreen(),
      BookingsScreen(onBrowseServices: () => setState(() => _currentTab = 1)),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentTab,
        children: _screens,
      ),
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    final tabs = [
      {'icon': Icons.home_rounded,           'label': 'Ana Səhifə'},
      {'icon': Icons.search_rounded,         'label': 'Kəşfet'},
      {'icon': Icons.bolt_rounded,           'label': 'Endirimlər'},
      {'icon': Icons.calendar_month_rounded, 'label': 'Rezerv'},
      {'icon': Icons.person_rounded,         'label': 'Profil'},
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(
          color: const Color(0xFF68A8D4).withOpacity(0.2))),
        boxShadow: const [BoxShadow(
          color: Color(0x0F1A6CC5),
          blurRadius: 20, offset: Offset(0, -4),
        )],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final active = _currentTab == i;
              return GestureDetector(
                onTap: () => setState(() => _currentTab = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: active
                        ? const Color(0xFF1A6CC5).withOpacity(0.10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tabs[i]['icon'] as IconData,
                        color: active
                            ? const Color(0xFF1A6CC5)
                            : const Color(0xFF78A0C0),
                        size: 22),
                      const SizedBox(height: 3),
                      Text(tabs[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: active
                              ? const Color(0xFF1A6CC5)
                              : const Color(0xFF78A0C0),
                        )),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
