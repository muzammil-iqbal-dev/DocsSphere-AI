import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Admin screen for managing system user accounts and operational statuses.
class AccountsScreen extends StatefulWidget {
  final WorkspaceController controller;

  const AccountsScreen({super.key, required this.controller});

  @override
  State<AccountsScreen> createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  Widget _detailField(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 140,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.muted,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      );

  Future<void> _accountDetails(DemoAccount a) async {
    final action = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Administration'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _detailField('Full Name', a.name),
              _detailField('Email', a.email),
              _detailField('Status', a.status),
              _detailField(
                'Created Date',
                WorkspaceController.formatDate(a.created),
              ),
              _detailField('Last Activity', a.last),
              const SizedBox(height: 12),
              const NoticeBanner(
                message:
                    'Document privacy boundary: Personal document records, extracted OCR texts, and filenames are hidden from Admin tools.',
                isSuccess: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (a.status == 'Active')
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
              onPressed: () => Navigator.pop(context, 'Suspend'),
              child: const Text('Suspend Account'),
            )
          else
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: AppColors.success),
              onPressed: () => Navigator.pop(context, 'Reactivate'),
              child: const Text('Reactivate Account'),
            ),
        ],
      ),
    );

    if (action == 'Suspend') {
      setState(() => a.status = 'Suspended');
      widget.controller.notify();
      widget.controller.toast('${a.name}\'s account has been suspended.');
    } else if (action == 'Reactivate') {
      setState(() => a.status = 'Active');
      widget.controller.notify();
      widget.controller.toast('${a.name}\'s account has been reactivated.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final list = c.accounts
        .where(
          (a) =>
              (c.accountFilter == 'All' || a.status == c.accountFilter) &&
              '${a.name} ${a.email}'.toLowerCase().contains(
                    c.accountSearch.toLowerCase(),
                  ),
        )
        .toList();

    return PageShell(
      title: 'Manage Accounts',
      description:
          'Review account identities, verify operational status, and manage suspension policies.',
      content: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: AppColors.line),
          ),
          child: Wrap(
            spacing: 12,
            runSpacing: 10,
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search, size: 18),
                    hintText: 'Search user name or email…',
                    isDense: true,
                  ),
                  onChanged: (v) {
                    setState(() {
                      c.accountSearch = v;
                      c.notify();
                    });
                  },
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: c.accountFilter,
                    items: ['All', 'Active', 'Suspended']
                        .map(
                          (s) => DropdownMenuItem(value: s, child: Text(s)),
                        )
                        .toList(),
                    onChanged: (v) {
                      setState(() {
                        c.accountFilter = v ?? 'All';
                        c.notify();
                      });
                    },
                  ),
                ),
              ),
            ],
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
                    'No accounts match the criteria.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                )
              else
                ...list.map(
                  (a) => ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.primaryPale,
                      child: Text(
                        WorkspaceController.initials(a.name),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    title: Text(
                      a.name,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      '${a.email} · Registered ${WorkspaceController.formatDate(a.created)} · Last: ${a.last}',
                    ),
                    trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      children: [
                        StatusBadge(label: a.status),
                        OutlinedButton(
                          onPressed: () => _accountDetails(a),
                          child: const Text('Manage'),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
