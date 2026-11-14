import 'package:flutter/material.dart';

import 'screens/welcome_screen.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const AiCaloriesApp());
}

class AiCaloriesApp extends StatefulWidget {
  const AiCaloriesApp({super.key, this.state});

  /// Test truyền state có API giả; mặc định tạo mới.
  final AppState? state;

  @override
  State<AiCaloriesApp> createState() => _AiCaloriesAppState();
}

class _AiCaloriesAppState extends State<AiCaloriesApp> {
  late final AppState _state = widget.state ?? AppState();

  @override
  void dispose() {
    if (widget.state == null) _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: _state,
      child: MaterialApp(
        title: 'AI Calories',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        // Khung điện thoại khi mở trên trình duyệt rộng.
        builder: (context, child) => ColoredBox(
          color: const Color(0xFFE4E8DF),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: child,
            ),
          ),
        ),
        home: const WelcomeScreen(),
      ),
    );
  }
}
