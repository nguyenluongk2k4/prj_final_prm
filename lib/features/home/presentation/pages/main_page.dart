import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/bottom_nav_bar.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import 'account_page.dart';
import 'home_page.dart';
import 'matches_page.dart';

/// Single scaffold that owns the persistent [BottomNavBar].
/// Tab content is swapped with [IndexedStack] so each page keeps its state.
import 'reels_page.dart';

class MainPage extends StatefulWidget {
  final int initialTab;
  final String? reelsType;

  const MainPage({
    super.key,
    this.initialTab = 0,
    this.reelsType,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late int _selectedIndex;

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
        children: [
          const HomePage(),
          const MatchesPage(),
          ReelsPage(initialType: widget.reelsType),
          const ChatPage(),
          const AccountPage(),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
