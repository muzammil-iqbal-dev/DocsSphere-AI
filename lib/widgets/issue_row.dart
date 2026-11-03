import 'package:flutter/material.dart';
import '../models/demo_issue.dart';
import '../theme/app_theme.dart';
import 'app_components.dart';

/// Row tile for administrative issue reports.
class IssueRow extends StatelessWidget {
  final DemoIssue issue;
  final void Function(DemoIssue issue) onTap;

  const IssueRow({
    super.key,
    required this.issue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.warningBg,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: const Icon(
          Icons.flag_outlined,
          color: AppColors.warning,
          size: 18,
        ),
      ),
      title: Text(
        issue.title,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text('${issue.type} · ${issue.service} · ${issue.time}'),
      trailing: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          StatusBadge(label: issue.status),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: () => onTap(issue),
    );
  }
}
