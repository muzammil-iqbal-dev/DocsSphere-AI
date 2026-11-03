import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';
import '../library/library_screen.dart';

/// Document detail screen with original simulated preview, OCR text view, metadata, and lifecycle actions.
class DocumentDetailScreen extends StatelessWidget {
  final WorkspaceController controller;
  final void Function(Doc doc)? onReviewText;
  final void Function(Doc doc)? onEditDoc;
  final void Function(Doc doc)? onPermanentlyDelete;

  const DocumentDetailScreen({
    super.key,
    required this.controller,
    this.onReviewText,
    this.onEditDoc,
    this.onPermanentlyDelete,
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
    final d = c.selectedDoc;
    if (d == null) return LibraryScreen(controller: c);

    if (d.deleted) {
      return PageShell(
        title: d.name,
        description: 'This document is in Deleted Documents.',
        content: const [
          NoticeBanner(
            message:
                'Restore it to return it to the library, search, expiry tracking and matching goal checklists.',
          ),
        ],
        actions: [
          OutlinedButton.icon(
            onPressed: () => c.restore(d),
            icon: const Icon(Icons.restore, size: 16),
            label: const Text('Restore'),
          ),
          OutlinedButton.icon(
            onPressed: () => onPermanentlyDelete?.call(d),
            icon: const Icon(Icons.delete_forever_outlined, size: 16),
            label: const Text('Delete permanently'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.dangerBorder),
            ),
          ),
        ],
      );
    }

    final related = d == c.docs[0]
        ? [c.docs[1], c.docs[2]]
        : d == c.docs[1]
            ? [c.docs[0]]
            : d == c.docs[3]
                ? [c.docs[5]]
                : <Doc>[];

    final expiry = d.expiry == null ? null : c.expiryState(d);

    // Left Column: Original simulated document preview & OCR Text
    final left = Column(
      children: [
        AppCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _title(
                'Original document preview',
                icon: Icons.visibility_outlined,
                trailing: StatusBadge(label: c.effectiveStatus(d)),
              ),
              const SizedBox(height: 16),
              // Document Canvas Simulator
              Container(
                height: 380,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.line),
                ),
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(color: AppColors.line),
                    boxShadow: AppShadows.card,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primaryPale,
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: const Icon(
                              Icons.verified_outlined,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              d.author.isEmpty
                                  ? 'DOCSPHEREAI ARCHIVE'
                                  : d.author,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 20),
                      Text(
                        d.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Mock text lines
                      ...List.generate(
                        6,
                        (i) => Container(
                          height: 7,
                          width: i % 3 == 0 ? 210 : 250,
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE8EEF5),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceSubtle,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: const Text(
                          'Verified Local Replica · Original Bytes Protected',
                          style: TextStyle(
                            color: AppColors.muted,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _title(
                'Extracted OCR text',
                icon: Icons.text_snippet_outlined,
                trailing: TextButton.icon(
                  onPressed: () => onReviewText?.call(d),
                  icon: const Icon(Icons.edit_note, size: 18),
                  label: Text(
                    d.status == 'Needs Review'
                        ? 'Review & correct text'
                        : 'Edit text',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (d.text.isEmpty)
                const NoticeBanner(
                  message:
                      'No extracted text is available. The file is preserved while background OCR processing waits for a connected service.',
                )
              else
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: SelectableText(
                    d.text,
                    style: const TextStyle(
                      height: 1.65,
                      color: AppColors.inkSubtle,
                      fontSize: 13.5,
                      fontFamily: 'Consolas, monospace',
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );

    // Right Column: Key Details, Warnings, Lifecycle actions
    final right = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _title(
                'Document metadata',
                icon: Icons.info_outline,
                trailing: IconButton(
                  tooltip: 'Edit metadata',
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  onPressed: () => onEditDoc?.call(d),
                ),
              ),
              const SizedBox(height: 14),
              _detailField('Document type', d.type),
              _detailField('Category', d.category),
              _detailField(
                'Issuing authority',
                d.author.isEmpty ? 'Not identified' : d.author,
              ),
              _detailField(
                'Date added',
                WorkspaceController.formatDate(d.added),
              ),
              _detailField(
                'Expiry date',
                WorkspaceController.formatDate(d.expiry),
              ),
              if (expiry != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text(
                      'Expiry Status:',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(width: 8),
                    StatusBadge(label: expiry),
                  ],
                ),
              ],
              const SizedBox(height: 14),
              const Text(
                'SUMMARY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mutedLight,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                d.summary,
                style: const TextStyle(
                  color: AppColors.inkSubtle,
                  height: 1.5,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _title('Document actions', icon: Icons.tune_outlined),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => c.toggleFavorite(d),
                icon: Icon(
                  d.favorite ? Icons.star : Icons.star_border,
                  color: d.favorite ? const Color(0xFFE5A100) : null,
                ),
                label: Text(
                  d.favorite ? 'Remove from Favourites' : 'Add to Favourites',
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => c.togglePin(d),
                icon: Icon(
                  d.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                  color: d.pinned ? AppColors.primary : null,
                ),
                label: Text(d.pinned ? 'Unpin Document' : 'Pin to Top'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => c.hide(d),
                icon: const Icon(Icons.visibility_off_outlined),
                label: const Text('Hide from Library'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => c.delete(d),
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.danger,
                ),
                label: const Text(
                  'Move to Deleted',
                  style: TextStyle(color: AppColors.danger),
                ),
              ),
            ],
          ),
        ),
        if (related.isNotEmpty) ...[
          const SizedBox(height: 16),
          AppCard(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _title(
                  'Connected documents',
                  icon: Icons.hub_outlined,
                  trailing: TextButton(
                    onPressed: () => c.go('Life Canvas'),
                    child: const Text('View map →'),
                  ),
                ),
                const SizedBox(height: 10),
                ...related.map(
                  (rel) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      WorkspaceController.docIcon(rel.category),
                      color: AppColors.primary,
                    ),
                    title: Text(
                      rel.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      rel.category,
                      style: const TextStyle(fontSize: 11),
                    ),
                    trailing: const Icon(Icons.chevron_right, size: 18),
                    onTap: () => c.openDoc(rel),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );

    return PageShell(
      title: d.name,
      description:
          'Document inspection workspace with verified original and extracted text.',
      content: [
        LayoutBuilder(
          builder: (context, box) => box.maxWidth > 950
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: left),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: right),
                  ],
                )
              : Column(children: [left, const SizedBox(height: 16), right]),
        ),
      ],
      actions: [
        OutlinedButton.icon(
          onPressed: () => c.go('Document Library'),
          icon: const Icon(Icons.arrow_back, size: 16),
          label: const Text('Back to Library'),
        ),
        FilledButton.icon(
          onPressed: () => onEditDoc?.call(d),
          icon: const Icon(Icons.edit, size: 16),
          label: const Text('Edit Details'),
        ),
      ],
      categoryBadge: d.category,
    );
  }
}
