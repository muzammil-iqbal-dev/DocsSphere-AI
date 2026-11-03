import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../widgets/app_components.dart';
import '../../widgets/goal_card.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Goal Dashboard screen for tracking document readiness against complex life milestones.
class GoalsScreen extends StatelessWidget {
  final WorkspaceController controller;
  final VoidCallback? onNewGoal;
  final void Function(Goal goal)? onEditGoal;
  final void Function(Goal goal)? onDeleteGoal;
  final VoidCallback? onAddDocument;

  const GoalsScreen({
    super.key,
    required this.controller,
    this.onNewGoal,
    this.onEditGoal,
    this.onDeleteGoal,
    this.onAddDocument,
  });

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return PageShell(
      title: 'Goal Dashboard',
      description:
          'Map complex life objectives into automated document checklists with readiness tracking.',
      content: [
        if (c.goals.isEmpty)
          EmptyStateView(
            title: 'No active goals created',
            description:
                'Create a new goal to track document readiness for applications, renewals, or taxes.',
            actionLabel: onNewGoal != null ? 'Create Goal' : null,
            onAction: onNewGoal,
          )
        else
          LayoutBuilder(
            builder: (context, box) {
              final wide = box.maxWidth > 880;
              final cards = c.goals
                  .map(
                    (g) => GoalCard(
                      goal: g,
                      controller: c,
                      onEditGoal: onEditGoal,
                      onDeleteGoal: onDeleteGoal,
                      onAddDocument: onAddDocument,
                    ),
                  )
                  .toList();

              return wide
                  ? Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: cards
                          .map(
                            (w) => SizedBox(
                              width: (box.maxWidth - 16) / 2,
                              child: w,
                            ),
                          )
                          .toList(),
                    )
                  : Column(
                      children: cards
                          .map(
                            (w) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: w,
                            ),
                          )
                          .toList(),
                    );
            },
          ),
      ],
      actions: onNewGoal != null
          ? [
              FilledButton.icon(
                onPressed: onNewGoal,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('New Goal'),
              ),
            ]
          : [],
    );
  }
}
