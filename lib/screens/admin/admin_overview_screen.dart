import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/issue_row.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Admin overview dashboard showing system metrics, microservices status, and recent issues.
class AdminOverviewScreen extends StatelessWidget {
  final WorkspaceController controller;
  final void Function(DemoIssue issue) onIssueTap;

  const AdminOverviewScreen({
    super.key,
    required this.controller,
    required this.onIssueTap,
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

  List<Widget> _serviceRows() => [
        ['Text reading & OCR (Tesseract / EasyOCR)', 'Ready'],
        ['AI Document Classifier & Metadata Extractor', 'Ready'],
        ['Vector Search & Qdrant Indexer', 'Ready'],
      ]
          .map(
            (s) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.primaryPale,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(
                  Icons.hub_outlined,
                  color: AppColors.primary,
                  size: 17,
                ),
              ),
              title: Text(
                s[0],
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              subtitle: const Text(
                'Demonstration gateway active',
                style: TextStyle(fontSize: 11.5),
              ),
              trailing: StatusBadge(label: s[1]),
            ),
          )
          .toList();

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final active = c.accounts.where((a) => a.status == 'Active').length;
    final failed = c.docs.where((d) => d.status == 'Failed').length;

    return PageShell(
      title: 'Admin Overview',
      description:
          'System-level health, account status, and operational metrics. Document privacy enforced.',
      content: [
        const NoticeBanner(
          message:
              'Security boundary: Administrators have access to service health and account status only. Personal document files, OCR text, and private metadata are never exposed.',
          isSuccess: true,
        ),
        LayoutBuilder(
          builder: (context, box) {
            final count = box.maxWidth > 950
                ? 4
                : box.maxWidth > 580
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
                  label: 'Total registered accounts',
                  value: '${c.accounts.length}',
                  icon: Icons.people_outline,
                  detail: 'Active system user directory',
                  onTap: () => c.go('Manage Accounts'),
                ),
                StatCard(
                  label: 'Uploaded documents',
                  value: '${c.docs.length}',
                  icon: Icons.upload_file_outlined,
                  detail: 'Aggregate demonstration metrics',
                ),
                StatCard(
                  label: 'Active accounts',
                  value: '$active',
                  icon: Icons.verified_user_outlined,
                  detail: 'Privacy protected identities',
                  accentColor: AppColors.secondary,
                  onTap: () => c.go('Manage Accounts'),
                ),
                StatCard(
                  label: 'System error events',
                  value: '$failed',
                  icon: Icons.error_outline,
                  detail: 'Operational failure logs',
                  accentColor: AppColors.danger,
                  onTap: () => c.go('Reported Issues'),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, box) {
            final left = AppCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _title(
                    'Microservice status',
                    icon: Icons.dns_outlined,
                    trailing: TextButton(
                      onPressed: () => c.go('Usage & Service Health'),
                      child: const Text('Full telemetry →'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ..._serviceRows(),
                ],
              ),
            );

            final right = AppCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _title(
                    'Recent technical reports',
                    icon: Icons.bug_report_outlined,
                    trailing: TextButton(
                      onPressed: () => c.go('Reported Issues'),
                      child: const Text('View all →'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...c.issues.take(3).map(
                        (i) => IssueRow(
                          issue: i,
                          onTap: onIssueTap,
                        ),
                      ),
                ],
              ),
            );

            return box.maxWidth > 880
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: left),
                      const SizedBox(width: 16),
                      Expanded(child: right),
                    ],
                  )
                : Column(
                    children: [left, const SizedBox(height: 16), right],
                  );
          },
        ),
      ],
    );
  }
}
