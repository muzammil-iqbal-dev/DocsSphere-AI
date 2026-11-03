import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../workspace/workspace_controller.dart';

/// Reusable brand logo widget used in auth screen and sidebar.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.large = false});
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: large ? 44 : 36,
          height: large ? 44 : 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(large ? 12 : 9),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(Icons.auto_stories, color: Colors.white, size: large ? 24 : 19),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'DocSphereAI',
                style: TextStyle(
                  fontSize: large ? 20 : 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                  color: AppColors.ink,
                ),
              ),
              Text(
                'YOUR SECOND BRAIN',
                style: TextStyle(
                  fontSize: large ? 10 : 8.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                  color: AppColors.muted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Left sidebar navigation for the workspace.
class NavSidebar extends StatelessWidget {
  const NavSidebar({super.key, required this.controller});
  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    final nav = controller.admin ? controller.adminNav : controller.ownerNav;
    final sections = nav.map((e) => e.$1).toSet().toList();

    return Container(
      width: 256,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.line)),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 16, 18),
              child: const BrandLogo(),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  for (final section in sections) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 12, 6),
                      child: Text(
                        section.toUpperCase(),
                        style: const TextStyle(
                          color: AppColors.mutedLight,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    for (final item in nav.where((x) => x.$1 == section))
                      _NavItem(item: item, controller: controller),
                  ],
                ],
              ),
            ),
            const Divider(height: 1),
            _UserFooter(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({required this.item, required this.controller});
  final (String, IconData, String) item;
  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    final label = item.$3;
    final icon = item.$2;
    final active = controller.page == label ||
        (controller.page == 'Document Details' && label == 'Document Library');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Material(
        color: active ? AppColors.primaryPale : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.md),
          onTap: () => controller.go(
            label,
            onError: () => controller.toast(
              'Admin accounts cannot open private document workspaces.',
              error: true,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(icon, size: 19, color: active ? AppColors.primary : AppColors.muted),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: active ? AppColors.primary : AppColors.inkSubtle,
                      fontSize: 13.5,
                      fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (active)
                  Container(
                    width: 4,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UserFooter extends StatelessWidget {
  const _UserFooter({required this.controller});
  final WorkspaceController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: controller.admin ? AppColors.adminPurpleBg : AppColors.primaryPale,
            child: Text(
              WorkspaceController.initials(controller.userName),
              style: TextStyle(
                color: controller.admin ? AppColors.adminPurple : AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  controller.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.ink),
                ),
                Text(
                  controller.admin ? 'Administrator' : 'Document Owner',
                  style: const TextStyle(fontSize: 11, color: AppColors.muted),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Log out',
            icon: const Icon(Icons.logout, size: 18),
            onPressed: () => controller.confirmLogout(context),
          ),
        ],
      ),
    );
  }
}
