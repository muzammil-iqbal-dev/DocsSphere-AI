import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Settings screen for managing notifications, accessibility guidance, and workspace data reset.
class SettingsScreen extends StatelessWidget {
  final WorkspaceController controller;
  final VoidCallback? onShowNotifications;
  final VoidCallback? onResetDemo;

  const SettingsScreen({
    super.key,
    required this.controller,
    this.onShowNotifications,
    this.onResetDemo,
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

    return PageShell(
      title: 'Settings',
      description:
          'Manage preferences, notification reminders, and local workspace data.',
      content: [
        LayoutBuilder(
          builder: (context, box) {
            final notify = AppCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(
                    'Reminders & Alerts',
                    icon: Icons.notifications_active_outlined,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Configure in-app expiry reminders for upcoming renewal deadlines.',
                    style: TextStyle(color: AppColors.muted, height: 1.5),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: onShowNotifications,
                    icon: const Icon(Icons.notifications_none),
                    label: const Text('Notification center'),
                  ),
                  TextButton(
                    onPressed: () {
                      c.reminderDismissed = false;
                      c.notify();
                      c.toast('Reminder banners restored.');
                    },
                    child: const Text('Restore dismissed home reminders'),
                  ),
                ],
              ),
            );

            final access = AppCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title(
                    'Accessibility & Theme',
                    icon: Icons.accessibility_new_outlined,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'DocSphereAI implements WCAG 2.2 AA compliant contrast, visible keyboard focus indicators, and semantic labels.',
                    style: TextStyle(color: AppColors.muted, height: 1.5),
                  ),
                  const SizedBox(height: 12),
                  const NoticeBanner(
                    message:
                        'Shortcut tip: Press Tab to navigate controls, Enter to activate, and Ctrl+K to search.',
                  ),
                ],
              ),
            );

            final reset = AppCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('Data & Privacy', icon: Icons.restart_alt_outlined),
                  const SizedBox(height: 10),
                  const Text(
                    'Reset the workspace to the initial sample document set at any time.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: onResetDemo,
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset demonstration data'),
                  ),
                ],
              ),
            );

            final session = AppCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('Session', icon: Icons.logout_outlined),
                  const SizedBox(height: 10),
                  const Text(
                    'Return to the role access screen.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton.icon(
                    onPressed: () => c.confirmLogout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                  ),
                ],
              ),
            );

            final widgets = [notify, access, reset, session];

            return box.maxWidth > 850
                ? GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.7,
                    children: widgets,
                  )
                : Column(
                    children: widgets
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
    );
  }
}
