import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/doc_row.dart';
import '../../widgets/goal_summary.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Workspace home dashboard for document owners.
class HomeScreen extends StatelessWidget {
  final WorkspaceController controller;
  final VoidCallback? onUpload;
  final void Function(Doc doc)? onReviewText;
  final void Function(Doc doc)? onEditDoc;
  final VoidCallback? onNewGoal;

  const HomeScreen({
    super.key,
    required this.controller,
    this.onUpload,
    this.onReviewText,
    this.onEditDoc,
    this.onNewGoal,
  });

  Widget _title(String text, {Widget? trailing, IconData? icon}) => Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          if (trailing != null) trailing,
        ],
      );

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final review =
        c.visibleDocs.where((d) => d.status == 'Needs Review').toList();
    final process = c.visibleDocs
        .where(
          (d) => [
            'Processing',
            'Pending Sorting',
            'Pending Index',
          ].contains(d.status),
        )
        .toList();
    final alerts =
        c.expiryDocs.where((d) => c.expiryState(d) != 'Valid').toList();
    final recent = [...c.visibleDocs]
      ..sort((a, b) => b.added.compareTo(a.added));

    final stats = LayoutBuilder(
      builder: (context, box) {
        final w = box.maxWidth;
        final count = w > 960
            ? 4
            : w > 580
                ? 2
                : 1;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: count,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: count == 4 ? 2.3 : 2.5,
          children: [
            StatCard(
              label: 'Active documents',
              value: '${c.visibleDocs.length}',
              icon: Icons.folder_open_outlined,
              detail:
                  '${c.visibleDocs.where((d) => d.status == 'Ready').length} indexed & searchable',
              onTap: () => c.go('Document Library'),
            ),
            StatCard(
              label: 'Needs your review',
              value: '${review.length}',
              icon: Icons.rate_review_outlined,
              detail: 'Review and verify extracted OCR text',
              accentColor: AppColors.warning,
              onTap: () {
                if (review.isNotEmpty) onReviewText?.call(review.first);
              },
            ),
            StatCard(
              label: 'Being prepared',
              value: '${process.length}',
              icon: Icons.sync_outlined,
              detail: 'Background OCR, sorting & indexing',
              accentColor: AppColors.info,
            ),
            StatCard(
              label: 'Expiry alerts',
              value: '${alerts.length}',
              icon: Icons.event_busy_outlined,
              detail: 'Action required for upcoming dates',
              accentColor: AppColors.secondary,
              onTap: () => c.go('Expiry Tracking'),
            ),
          ],
        );
      },
    );

    final left = AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _title(
            'Recently added documents',
            icon: Icons.history,
            trailing: TextButton(
              onPressed: () => c.go('Document Library'),
              child: const Text('View full library →'),
            ),
          ),
          const SizedBox(height: 12),
          if (recent.isEmpty)
            EmptyStateView(
              title: 'No documents yet',
              description:
                  'Add your first document to begin building your second brain.',
              actionLabel: onUpload != null ? 'Add Documents' : null,
              onAction: onUpload,
            )
          else
            ...recent.take(5).map(
                  (d) => DocRow(
                    doc: d,
                    controller: c,
                    onReviewText: onReviewText,
                    onEditDoc: onEditDoc,
                  ),
                ),
        ],
      ),
    );

    final right = Column(
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _title(
                'Actions required',
                icon: Icons.checklist_outlined,
              ),
              const SizedBox(height: 12),
              if (review.isEmpty && alerts.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: const Center(
                    child: Text(
                      'You are all caught up! No urgent reviews.',
                      style: TextStyle(color: AppColors.muted, fontSize: 13),
                    ),
                  ),
                )
              else ...[
                if (review.isNotEmpty) ...[
                  const Text(
                    'OCR TEXT TO VERIFY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.warning,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...review.take(2).map(
                        (d) => DocRow(
                          doc: d,
                          controller: c,
                          showReview: true,
                          onReviewText: onReviewText,
                          onEditDoc: onEditDoc,
                        ),
                      ),
                ],
                if (alerts.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  const Text(
                    'UPCOMING EXPIRATIONS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.danger,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...alerts.take(2).map(
                        (d) => DocRow(
                          doc: d,
                          controller: c,
                          onReviewText: onReviewText,
                          onEditDoc: onEditDoc,
                        ),
                      ),
                ],
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _title(
                'Goals in progress',
                icon: Icons.flag_outlined,
                trailing: TextButton(
                  onPressed: () => c.go('Goal Dashboard'),
                  child: const Text('All goals →'),
                ),
              ),
              const SizedBox(height: 8),
              ...c.goals.take(2).map((g) => GoalSummary(goal: g, controller: c)),
              const SizedBox(height: 12),
              FilledButton.tonalIcon(
                onPressed: onNewGoal,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Create New Goal'),
              ),
            ],
          ),
        ),
      ],
    );

    final overview = LayoutBuilder(
      builder: (context, box) => box.maxWidth > 920
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: left),
                const SizedBox(width: 16),
                Expanded(flex: 2, child: right),
              ],
            )
          : Column(children: [left, const SizedBox(height: 16), right]),
    );

    return PageShell(
      title:
          'Good ${DateTime.now().hour < 12 ? 'morning' : 'afternoon'}, ${c.userName.split(' ').first}',
      description:
          'Your connected documents, action items, and intelligence workspace.',
      content: [
        if (alerts.isNotEmpty && !c.reminderDismissed)
          NoticeBanner(
            message:
                'Expiry reminder: ${alerts.map((d) => d.name).join(', ')} require attention. Review upcoming deadlines to prevent lapses.',
            isWarning: true,
            actionLabel: 'View Expiries',
            onAction: () => c.go('Expiry Tracking'),
          ),
        stats,
        overview,
      ],
      actions: [
        OutlinedButton.icon(
          onPressed: () => c.go('Smart Search'),
          icon: const Icon(Icons.search, size: 18),
          label: const Text('Smart Search'),
        ),
        FilledButton.icon(
          onPressed: onUpload,
          icon: const Icon(Icons.upload_file, size: 18),
          label: const Text('Add Document'),
        ),
      ],
    );
  }
}
