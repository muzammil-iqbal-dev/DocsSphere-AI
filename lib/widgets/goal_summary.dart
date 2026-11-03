import 'package:flutter/material.dart';
import '../models/goal.dart';
import '../theme/app_theme.dart';
import '../workspace/workspace_controller.dart';

/// Compact progress indicator row for a goal (used in Home Overview and sidebars).
class GoalSummary extends StatelessWidget {
  final Goal goal;
  final WorkspaceController controller;

  const GoalSummary({
    super.key,
    required this.goal,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final result = controller.goalProgress(goal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
              Text(
                '${result.$1}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: result.$1 / 100,
              minHeight: 6,
              backgroundColor: AppColors.surfaceSubtle,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
