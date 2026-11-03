import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../workspace/workspace_controller.dart';

/// Top bar with persistent quick search, role badges, notifications, and profile avatar.
class TopBar extends StatefulWidget {
  final WorkspaceController controller;
  final VoidCallback onShowNotifications;

  const TopBar({
    super.key,
    required this.controller,
    required this.onShowNotifications,
  });

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: TextField(
                controller: c.searchTopBarController,
                decoration: InputDecoration(
                  hintText: 'Search your documents (Ctrl+K)…',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: c.searchTopBarController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            c.searchTopBarController.clear();
                            c.query = '';
                            c.notify();
                            setState(() {});
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  filled: true,
                  fillColor: AppColors.background,
                ),
                onChanged: (v) {
                  c.query = v;
                  c.notify();
                  setState(() {});
                },
                onSubmitted: (v) {
                  c.query = v;
                  c.go('Smart Search');
                },
              ),
            ),
          ),
          const Spacer(),
          if (c.admin)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.adminPurpleBg,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.adminPurpleBorder),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 14,
                    color: AppColors.adminPurple,
                  ),
                  SizedBox(width: 6),
                  Text(
                    'ADMINISTRATOR',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: AppColors.adminPurple,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(color: AppColors.line),
              ),
              child: const Text(
                'DOCUMENT OWNER',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.muted,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          const SizedBox(width: 12),
          IconButton(
            tooltip: 'Notifications',
            onPressed: widget.onShowNotifications,
            icon: Badge(
              isLabelVisible: !c.admin &&
                  !c.reminderDismissed &&
                  c.expiryDocs.any((d) => c.expiryState(d) != 'Valid'),
              smallSize: 8,
              backgroundColor: AppColors.warning,
              child: const Icon(Icons.notifications_none_outlined, size: 22),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            onTap: () => c.go('Profile'),
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: c.admin
                    ? AppColors.adminPurpleBg
                    : AppColors.primaryPale,
                child: Text(
                  WorkspaceController.initials(c.userName),
                  style: TextStyle(
                    fontSize: 11.5,
                    color: c.admin ? AppColors.adminPurple : AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
