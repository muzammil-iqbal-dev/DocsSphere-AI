import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/issue_row.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Admin screen for reviewing service issues, processing errors, and incident notes.
class IssuesScreen extends StatefulWidget {
  final WorkspaceController controller;

  const IssuesScreen({super.key, required this.controller});

  @override
  State<IssuesScreen> createState() => _IssuesScreenState();
}

class _IssuesScreenState extends State<IssuesScreen> {
  Future<void> _issueDetails(DemoIssue issue) async {
    var status = issue.status;
    final note = TextEditingController(text: issue.note);

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, refresh) => AlertDialog(
          title: Text(issue.title),
          content: SizedBox(
            width: 560,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  '${issue.type} · ${issue.time} · ${issue.service}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
                const SizedBox(height: 14),
                Text(
                  issue.detail,
                  style: const TextStyle(height: 1.5, fontSize: 13.5),
                ),
                const SizedBox(height: 14),
                const NoticeBanner(
                  message:
                      'Service diagnostic telemetry only. Contains no private document contents.',
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: status,
                  decoration: const InputDecoration(labelText: 'Status'),
                  items: ['New', 'In Progress', 'Resolved']
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (v) => refresh(() => status = v ?? status),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: note,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Administrative incident note',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save incident update'),
            ),
          ],
        ),
      ),
    );

    if (saved == true) {
      setState(() {
        issue.status = status;
        issue.note = note.text.trim();
      });
      widget.controller.notify();
      widget.controller.toast('Issue status updated to "$status".');
    }
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final list = c.issues
        .where((i) => c.issueFilter == 'All' || i.status == c.issueFilter)
        .toList();

    return PageShell(
      title: 'Reported Issues',
      description:
          'Investigate system telemetry, processing errors, and service availability logs.',
      content: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: c.issueFilter,
              items: ['All', 'New', 'In Progress', 'Resolved']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) {
                setState(() {
                  c.issueFilter = v ?? 'All';
                  c.notify();
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              if (list.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(32),
                  child: Text(
                    'No technical issues reported.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                )
              else
                ...list.map(
                  (i) => IssueRow(
                    issue: i,
                    onTap: _issueDetails,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
