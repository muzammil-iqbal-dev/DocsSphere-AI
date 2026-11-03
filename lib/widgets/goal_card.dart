import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../theme/app_theme.dart';
import '../workspace/workspace_controller.dart';
import 'app_components.dart';

/// Full interactive goal card with progress bar, requirement checklist, and options.
class GoalCard extends StatelessWidget {
  final Goal goal;
  final WorkspaceController controller;
  final void Function(Goal goal)? onEditGoal;
  final void Function(Goal goal)? onDeleteGoal;
  final VoidCallback? onAddDocument;

  const GoalCard({
    super.key,
    required this.goal,
    required this.controller,
    this.onEditGoal,
    this.onDeleteGoal,
    this.onAddDocument,
  });

  @override
  Widget build(BuildContext context) {
    final g = goal;
    final result = controller.goalProgress(g);
    final percent = result.$1;
    final readyCount = result.$2;
    final totalCount = result.$3;

    return AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                child:
                    const Icon(Icons.flag_outlined, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      g.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.5,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      g.description,
                      style: const TextStyle(
                        color: AppColors.muted,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Goal options',
                onSelected: (v) =>
                    v == 'Edit' ? onEditGoal?.call(g) : onDeleteGoal?.call(g),
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'Edit', child: Text('Edit goal')),
                  PopupMenuItem(
                    value: 'Delete',
                    child: Text(
                      'Delete goal',
                      style: TextStyle(color: AppColors.danger),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Progress bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  child: LinearProgressIndicator(
                    value: percent / 100,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceSubtle,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      percent == 100 ? AppColors.success : AppColors.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$percent%',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$readyCount of $totalCount required documents verified & ready',
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
          const Divider(height: 24),
          // Checklist items
          if (g.items.isEmpty)
            const Text(
              'Add checklist items to track requirement status.',
              style: TextStyle(color: AppColors.muted),
            )
          else
            ...g.items.map((item) {
              final d = item.doc;
              final valid = d != null &&
                  !d.deleted &&
                  d.status == 'Ready' &&
                  (d.expiry == null || d.expiry!.isAfter(DateTime.now()));

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Icon(
                      valid
                          ? Icons.check_circle
                          : d == null
                              ? Icons.radio_button_unchecked
                              : Icons.warning_amber_rounded,
                      size: 18,
                      color: valid
                          ? AppColors.success
                          : d == null
                              ? AppColors.muted
                              : AppColors.warning,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  valid ? FontWeight.w600 : FontWeight.w500,
                              color: AppColors.ink,
                            ),
                          ),
                          if (d != null)
                            Text(
                              'Matched: ${d.name} (${controller.effectiveStatus(d)})',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.muted,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (d == null)
                      TextButton.icon(
                        onPressed: onAddDocument,
                        icon: const Icon(Icons.upload, size: 14),
                        label: const Text('Add Document'),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                        ),
                      )
                    else
                      IconButton(
                        tooltip: 'View matched document',
                        icon: const Icon(Icons.arrow_forward, size: 16),
                        onPressed: () => controller.openDoc(d),
                      ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }
}
