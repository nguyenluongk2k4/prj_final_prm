import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import '../../../../core/presentation/widgets/bottom_nav_bar.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../stores/reels_store.dart';
import 'account_page.dart';
import 'home_page.dart';
import 'matches_page.dart';
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

  void _onTabChanged(int index) {
    if (_selectedIndex == index) return;
    // If leaving Reels tab, stop audio immediately — don't wait for dispose()
    if (_selectedIndex == 2) {
      GetIt.I<ReelsStore>().stopAudio();
      GetIt.I<ReelsStore>().setPageVisibility(false);
      GetIt.I<ReelsStore>().currentActiveReelId = null;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onTabChanged,
      ),
    );
  }

  Widget _buildBody() {
    // Rebuild the active tab's widget on every switch — no keepAlive, no IndexedStack.
    // ReelsPage disposes itself (stops audio) when leaving and re-inits when returning.
    switch (_selectedIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const MatchesPage();
      case 2:
        return ReelsPage(initialType: reelsType);
      case 3:
        return const ChatPage();
      case 4:
        return const AccountPage();
      default:
        return const HomePage();
    }
  }

  String? get reelsType => widget.reelsType;
}
