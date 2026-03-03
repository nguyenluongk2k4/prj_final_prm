import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/bottom_nav_bar.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import 'account_page.dart';
import 'home_page.dart';
import 'matches_page.dart';

/// Single scaffold that owns the persistent [BottomNavBar].
/// Tab content is swapped with [IndexedStack] so each page keeps its state.
class MainPage extends StatefulWidget {
  /// Pass a starting tab index (0 = Home, 1 = Matches, …).
  const MainPage({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;

  static const _pages = <Widget>[
    HomePage(),
    MatchesPage(),
    ChatPage(),
    AccountPage(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
