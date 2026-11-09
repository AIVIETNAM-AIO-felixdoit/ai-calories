import 'package:flutter/material.dart';

import '../state/app_state.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/common.dart';
import 'activity_screen.dart';
import 'articles_screen.dart';
import 'home_screen.dart';
import 'progress_screen.dart';
import 'scan_screen.dart';

const tabHome = 0;
const tabActivity = 1;
const tabProgress = 2;
const tabExplore = 3;

/// Mở 4 tab chính và xoá các màn thiết lập khỏi stack.
void openMainShell(BuildContext context, {int tab = tabHome}) {
  AppScope.read(context).selectTab(tab);
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const MainShell()),
    (route) => false,
  );
}

/// Từ một màn con, quay về MainShell và mở đúng tab.
void backToTab(BuildContext context, int tab) {
  AppScope.read(context).selectTab(tab);
  popToRoot(context);
}

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: state.currentTab,
        children: const [
          HomeScreen(),
          ActivityScreen(),
          ProgressScreen(),
          ArticlesScreen(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomNav(
          currentIndex: state.currentTab,
          onTap: state.selectTab,
          onCamera: () => pushScreen(context, const ScanScreen()),
        ),
      ),
    );
  }
}
