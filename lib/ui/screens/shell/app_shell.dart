import 'package:flutter/material.dart';

import '../../widgets/smart_canteen_navigation_bar.dart';
import '../digital_wallet/history_screen.dart';
import '../digital_wallet/qr_screen.dart';
import '../home/home_screen.dart';
import '../menu_browsing/menu_screen.dart';
import '../settings/settings_screen.dart';

/// Exposes [setTab] to any descendant inside the shell.
class AppShellScope extends InheritedWidget {
  const AppShellScope({
    super.key,
    required this.setTab,
    required super.child,
  });

  final void Function(int) setTab;

  static AppShellScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppShellScope>();

  @override
  bool updateShouldNotify(AppShellScope old) => old.setTab != setTab;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  static const routeName = '/home';

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setTab(int index) {
    if (index == _index) return;
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    return AppShellScope(
      setTab: _setTab,
      child: Scaffold(
        body: PageView(
          controller: _controller,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            HomeScreen(),
            MenuScreen(),
            QrScreen(),
            HistoryScreen(),
            SettingsScreen(),
          ],
        ),
        bottomNavigationBar: SmartCanteenNavigationBarButton(
          currentIndex: _index,
          onTap: _setTab,
        ),
      ),
    );
  }
}
