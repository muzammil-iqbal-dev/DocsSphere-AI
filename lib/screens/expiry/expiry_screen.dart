import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/doc_row.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Expiry tracking dashboard displaying documents grouped by urgency status.
class ExpiryScreen extends StatefulWidget {
  final WorkspaceController controller;
  final void Function(Doc doc)? onReviewText;
  final void Function(Doc doc)? onEditDoc;

  const ExpiryScreen({
    super.key,
    required this.controller,
    this.onReviewText,
    this.onEditDoc,
  });

  @override
  State<ExpiryScreen> createState() => _ExpiryScreenState();
}

class _ExpiryScreenState extends State<ExpiryScreen> {
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
    final c = widget.controller;
    final ds = c.expiryDocs;

    return PageShell(
      title: 'Expiry Tracking',
      description:
          'Monitor document expiration deadlines to ensure credentials and IDs stay current.',
      content: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line),
          ),
          child: Wrap(
            spacing: 8,
            children: ['All', 'Valid', 'Expiring Soon', 'Expired']
                .map(
                  (label) => FilterChip(
                    label: Text(label),
                    selected: c.expiryFilter == label,
                    onSelected: (_) {
                      setState(() {
                        c.expiryFilter = label;
                        c.notify();
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _title(
                'Tracked document deadlines',
                icon: Icons.timer_outlined,
                trailing: const Text(
                  'Sorted by urgency',
                  style: TextStyle(fontSize: 12, color: AppColors.muted),
                ),
              ),
              const SizedBox(height: 12),
              if (ds.isEmpty)
                const EmptyStateView(
                  title: 'No expiry dates set',
                  description:
                      'When you add expiry dates to document details, reminders appear here.',
                )
              else
                ...ds
                    .where(
                      (d) =>
                          c.expiryFilter == 'All' ||
                          c.expiryState(d) == c.expiryFilter,
                    )
                    .map(
                      (d) => DocRow(
                        doc: d,
                        controller: c,
                        onReviewText: widget.onReviewText,
                        onEditDoc: widget.onEditDoc,
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
