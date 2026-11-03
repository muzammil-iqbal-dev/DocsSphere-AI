import 'package:flutter/material.dart';
import '../models/doc.dart';
import '../theme/app_theme.dart';
import '../workspace/workspace_controller.dart';
import 'app_components.dart';
import 'expiry_badge.dart';

/// Row representation of a document with actions, icon, category, and status badge.
class DocRow extends StatelessWidget {
  final Doc doc;
  final WorkspaceController controller;
  final bool showReview;
  final bool restore;
  final bool hidden;
  final void Function(Doc doc)? onReviewText;
  final void Function(Doc doc)? onEditDoc;

  const DocRow({
    super.key,
    required this.doc,
    required this.controller,
    this.showReview = false,
    this.restore = false,
    this.hidden = false,
    this.onReviewText,
    this.onEditDoc,
    this.onPermanentlyDelete,
  });

  final void Function(Doc doc)? onPermanentlyDelete;

  void _handleDocAction(String action) {
    switch (action) {
      case 'Open':
        controller.openDoc(doc);
        break;
      case 'Edit':
        onEditDoc?.call(doc);
        break;
      case 'Favorite':
        controller.toggleFavorite(doc);
        break;
      case 'Pin':
        controller.togglePin(doc);
        break;
      case 'Hide':
        if (doc.hidden) {
          controller.unhide(doc);
        } else {
          controller.hide(doc);
        }
        break;
      case 'Delete':
        controller.delete(doc);
        break;
      case 'Restore':
        controller.restore(doc);
        break;
      case 'Delete permanently':
      case 'DeletePermanently':
        onPermanentlyDelete?.call(doc);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final d = doc;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wideLayout = constraints.maxWidth > 450;
        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: InkWell(
          onTap: () => controller.openDoc(d),
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: Colors.transparent),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primaryPale,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.primaryBorder),
                  ),
                  child: Icon(
                    WorkspaceController.docIcon(d.category),
                    size: 20,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              d.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 13.5,
                                color: AppColors.ink,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (d.pinned) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.push_pin,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ],
                          if (d.favorite) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.star,
                              size: 14,
                              color: Color(0xFFE5A100),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${d.category} · ${d.author.isEmpty ? d.type : d.author} · Added ${WorkspaceController.formatDate(d.added)}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.muted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (d.expiry != null && !showReview && wideLayout) ...[
                  ExpiryBadge(doc: d, controller: controller),
                  const SizedBox(width: 10),
                ],
                StatusBadge(label: controller.effectiveStatus(d)),
                if (showReview) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Review OCR text',
                    icon: const Icon(Icons.rate_review_outlined, size: 18),
                    onPressed: () => onReviewText?.call(d),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(32, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
                if (restore) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Restore',
                    icon: const Icon(Icons.restore, size: 18),
                    onPressed: () => controller.restore(d),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(32, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
                if (hidden) ...[
                  const SizedBox(width: 4),
                  IconButton(
                    tooltip: 'Unhide',
                    icon: const Icon(Icons.visibility, size: 18),
                    onPressed: () => controller.unhide(d),
                    style: IconButton.styleFrom(
                      minimumSize: const Size(32, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ],
                const SizedBox(width: 6),
                PopupMenuButton<String>(
                  tooltip: (d.deleted || restore)
                      ? 'Deleted document actions'
                      : 'Document actions',
                  onSelected: _handleDocAction,
                  itemBuilder: (_) => (d.deleted || restore)
                      ? [
                          const PopupMenuItem(
                            value: 'Restore',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.restore, size: 16),
                                SizedBox(width: 8),
                                Flexible(child: Text('Restore to Library')),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'Delete permanently',
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete_forever,
                                  size: 16,
                                  color: AppColors.danger,
                                ),
                                SizedBox(width: 8),
                                Flexible(
                                  child: Text(
                                    'Delete permanently',
                                    style: TextStyle(color: AppColors.danger),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      : [
                          const PopupMenuItem(
                            value: 'Open',
                            child: Row(
                              children: [
                                Icon(Icons.open_in_new, size: 16),
                                SizedBox(width: 8),
                                Text('View Details'),
                              ],
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'Edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 16),
                                SizedBox(width: 8),
                                Text('Edit Metadata'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Favorite',
                            child: Row(
                              children: [
                                Icon(
                                  d.favorite ? Icons.star : Icons.star_border,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  d.favorite
                                      ? 'Remove from Favorites'
                                      : 'Add to Favorites',
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Pin',
                            child: Row(
                              children: [
                                Icon(
                                  d.pinned
                                      ? Icons.push_pin
                                      : Icons.push_pin_outlined,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(d.pinned ? 'Unpin' : 'Pin to Top'),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'Hide',
                            child: Row(
                              children: [
                                Icon(
                                  d.hidden
                                      ? Icons.visibility
                                      : Icons.visibility_off_outlined,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(d.hidden ? 'Unhide' : 'Hide Document'),
                              ],
                            ),
                          ),
                          const PopupMenuDivider(),
                          PopupMenuItem(
                            value: 'Delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  size: 16,
                                  color: AppColors.danger,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Delete Document',
                                  style: TextStyle(color: AppColors.danger),
                                ),
                              ],
                            ),
                          ),
                        ],
                ),
              ],
            ),
          ),
        ),
      ),
        );
      },
    );
  }
}
