import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../workspace/workspace_shell.dart';

/// Top-level application widget configuring theme, title, and home workspace shell.
class DocSphereApp extends StatelessWidget {
  const DocSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DocSphereAI — Your Second Brain',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WorkspaceShell(),
    );
  }
}
