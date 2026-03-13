import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/explore_screen.dart';
import 'screens/deals_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/profile_screen.dart';
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
        scaffoldBackgroundColor: const Color(0xFFF0F5EC),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA8B6A1),
        ),
      ),
      home: const RootScreen(),
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

  final List<Widget> _screens = const [
    HomeScreen(),
    ExploreScreen(),
   DealsScreen(),
    BookingsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentTab],
      bottomNavigationBar: _buildNav(),
    );
  }

  Widget _buildNav() {
    final tabs = [
      {'icon': Icons.home_rounded,           'label': 'Home'},
      {'icon': Icons.search_rounded,         'label': 'Explore'},
      {'icon': Icons.bolt_rounded,           'label': 'Deals'},
      {'icon': Icons.calendar_month_rounded, 'label': 'Bookings'},
      {'icon': Icons.person_rounded,         'label': 'Profile'},
    ];
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(
          color: const Color(0xFFA8B6A1).withOpacity(0.2))),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 20, offset: const Offset(0, -4),
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
                        ? const Color(0xFFA8B6A1).withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(tabs[i]['icon'] as IconData,
                        color: active
                            ? const Color(0xFF2C3528)
                            : const Color(0xFF9AAA94),
                        size: 22),
                      const SizedBox(height: 3),
                      Text(tabs[i]['label'] as String,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: active
                              ? const Color(0xFF2C3528)
                              : const Color(0xFF9AAA94),
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