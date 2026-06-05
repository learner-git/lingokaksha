import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/app_haptics.dart';
import '../../core/theme/theme_extensions.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _locationToIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/lesson')) return 1;
    if (location.startsWith('/chat') || location.startsWith('/voice-tutor')) return 2;
    if (location.startsWith('/vocabulary')) return 3;
    if (location.startsWith('/dashboard')) return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/lessons');
        break;
      case 2:
        context.go('/chat');
        break;
      case 3:
        context.go('/vocabulary');
        break;
      case 4:
        context.go('/dashboard');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _locationToIndex(location);
    final useCupertino = Theme.of(context).platform == TargetPlatform.iOS;

    return Scaffold(
      body: child,
      bottomNavigationBar: useCupertino
          ? _IosTabBar(
              currentIndex: currentIndex,
              onTap: (i) {
                if (i != currentIndex) AppHaptics.selection();
                _onTap(context, i);
              },
            )
          : _MaterialTabBar(
              currentIndex: currentIndex,
              onTap: (i) => _onTap(context, i),
            ),
    );
  }
}

class _IosTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _IosTabBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.dividerColor.withOpacity(0.6),
            width: 0.5,
          ),
        ),
      ),
      child: CupertinoTabBar(
        currentIndex: currentIndex,
        onTap: onTap,
        activeColor: AppColors.primaryLight,
        inactiveColor: CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.inactiveGray,
          darkColor: Colors.white.withOpacity(0.45),
        ).resolveFrom(context),
        backgroundColor: CupertinoDynamicColor.withBrightness(
          color: CupertinoColors.systemBackground,
          darkColor: AppColors.surfaceDark,
        ).resolveFrom(context),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.square_list),
            activeIcon: Icon(CupertinoIcons.square_list_fill),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.bubble_left_bubble_right),
            activeIcon: Icon(CupertinoIcons.bubble_left_bubble_right_fill),
            label: 'Tutor',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.rectangle_stack),
            activeIcon: Icon(CupertinoIcons.rectangle_stack_fill),
            label: 'Vocab',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.graph_square),
            activeIcon: Icon(CupertinoIcons.graph_square_fill),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}

class _MaterialTabBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _MaterialTabBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.dividerColor,
            width: 0.5,
          ),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: context.textSecondary.withOpacity(0.6),
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_outlined),
            activeIcon: Icon(Icons.school_rounded),
            label: 'Lessons',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            activeIcon: Icon(Icons.forum_rounded),
            label: 'Tutor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.style_outlined),
            activeIcon: Icon(Icons.style_rounded),
            label: 'Vocab',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_outlined),
            activeIcon: Icon(Icons.analytics_rounded),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}
