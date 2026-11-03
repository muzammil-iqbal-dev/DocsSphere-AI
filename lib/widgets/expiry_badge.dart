import 'package:flutter/material.dart';
import '../models/doc.dart';
import '../theme/app_theme.dart';
import '../workspace/workspace_controller.dart';

/// Pill badge indicating document expiration deadline and severity.
class ExpiryBadge extends StatelessWidget {
  final Doc doc;
  final WorkspaceController controller;

  const ExpiryBadge({
    super.key,
    required this.doc,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final state = controller.expiryState(doc);
    Color bg = AppColors.successBg;
    Color fg = AppColors.success;
    if (state == 'Expired') {
      bg = AppColors.dangerBg;
      fg = AppColors.danger;
    } else if (state == 'Expiring Soon') {
      bg = AppColors.warningBg;
      fg = AppColors.warning;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        'Exp: ${WorkspaceController.formatDate(doc.expiry)}',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
