import 'package:flutter/material.dart';
import '../../../../features/applications/presentation/screens/applications_screen.dart';
import '../../../../features/career_twin/presentation/screens/career_twin_screen.dart';
import '../../../../features/discover/presentation/screens/discover_screen.dart';
import '../../../../features/growth/presentation/screens/growth_screen.dart';
import '../widgets/bottom_nav_bar.dart';

class MainScaffoldScreen extends StatefulWidget {
  final int initialIndex;

  const MainScaffoldScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScaffoldScreen> createState() => _MainScaffoldScreenState();
}

class _MainScaffoldScreenState extends State<MainScaffoldScreen> {
  late int _currentIndex;

  final List<Widget> _screens = const [
    DiscoverScreen(),
    CareerTwinScreen(),
    GrowthScreen(),
    ApplicationsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: VedicBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
