import 'package:deardiaryv2/features/diary/presentation/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    return Switch(
      value: themeProvider.isDark,
      onChanged: (_) {
        themeProvider.toggleTheme();
      },
    );
  }
}
