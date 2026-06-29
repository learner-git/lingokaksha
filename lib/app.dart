import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_extensions.dart';
import 'widgets/common/responsive_wrapper.dart';

class LingoKakshaApp extends ConsumerWidget {
  const LingoKakshaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'LingoKaksha',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      builder: (context, child) => AppResponsiveWrapper(
        child: AppTextScaler(child: child ?? const SizedBox.shrink()),
      ),
      routerConfig: router,
    );
  }
}
