import 'package:flutter/material.dart';
import '../models/doc.dart';
import '../theme/app_theme.dart';
import '../workspace/workspace_controller.dart';
import 'app_components.dart';
import 'expiry_badge.dart';

/// Card representation of a document for grid view layouts.
class DocCard extends StatelessWidget {
  final Doc doc;
  final WorkspaceController controller;

  const DocCard({
    super.key,
    required this.doc,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final d = doc;
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line),
        boxShadow: AppShadows.subtle,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: InkWell(
          onTap: () => controller.openDoc(d),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPale,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        WorkspaceController.docIcon(d.category),
                        color: AppColors.primary,
                        size: 19,
                      ),
                    ),
                    const Spacer(),
                    StatusBadge(label: controller.effectiveStatus(d)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  d.name,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  d.summary,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.muted,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      d.category,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkSubtle,
                      ),
                    ),
                    const Spacer(),
                    if (d.expiry != null)
                      ExpiryBadge(doc: d, controller: controller),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
