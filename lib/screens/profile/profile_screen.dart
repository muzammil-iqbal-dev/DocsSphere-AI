import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// User profile and active session credentials screen.
class ProfileScreen extends StatelessWidget {
  final WorkspaceController controller;

  const ProfileScreen({super.key, required this.controller});

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

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return PageShell(
      title: 'Profile',
      description: 'Your active identity session and workspace credentials.',
      content: [
        LayoutBuilder(
          builder: (context, box) {
            final profile = AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: c.admin
                            ? AppColors.adminPurpleBg
                            : AppColors.primaryPale,
                        child: Text(
                          WorkspaceController.initials(c.userName),
                          style: TextStyle(
                            color: c.admin
                                ? AppColors.adminPurple
                                : AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.userName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          Text(
                            c.userEmail,
                            style: const TextStyle(color: AppColors.muted),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  _detailField(
                    'Account role',
                    c.admin ? 'System Administrator' : 'Document Owner',
                  ),
                  _detailField('Workspace mode', 'Demonstration prototype'),
                  const SizedBox(height: 12),
                  const NoticeBanner(
                    message:
                        'Changes in this session are held in memory. Restarting the application resets to sample configuration.',
                  ),
                ],
              ),
            );

            final actions = AppCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _title('Session & Access', icon: Icons.security_outlined),
                  const SizedBox(height: 12),
                  const Text(
                    'Log out to return to the access screen or switch between Owner and Admin workspaces.',
                    style: TextStyle(color: AppColors.muted, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => c.confirmLogout(context),
                    icon: const Icon(Icons.logout),
                    label: const Text('Log out of DocSphereAI'),
                  ),
                ],
              ),
            );

            return box.maxWidth > 800
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: profile),
                      const SizedBox(width: 16),
                      Expanded(child: actions),
                    ],
                  )
                : Column(
                    children: [profile, const SizedBox(height: 16), actions],
                  );
          },
        ),
      ],
    );
  }
}
