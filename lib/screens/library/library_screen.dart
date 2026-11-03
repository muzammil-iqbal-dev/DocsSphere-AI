import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/doc_card.dart';
import '../../widgets/doc_row.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Document Library screen supporting filtered modes: Library, Favourites, Pinned, Hidden, and Deleted.
class LibraryScreen extends StatefulWidget {
  final WorkspaceController controller;
  final String? mode;
  final VoidCallback? onUpload;
  final void Function(Doc doc)? onReviewText;
  final void Function(Doc doc)? onEditDoc;
  final void Function(Doc doc)? onPermanentlyDelete;

  const LibraryScreen({
    super.key,
    required this.controller,
    this.mode,
    this.onUpload,
    this.onReviewText,
    this.onEditDoc,
    this.onPermanentlyDelete,
  });

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final title = widget.mode ?? 'Document Library';
    final ds = c.filteredDocs(title);

    // Toolbar
    final controls = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: 280,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search within $title…',
                      prefixIcon: const Icon(Icons.search, size: 19),
                      suffixIcon: c.query.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 16),
                              onPressed: () {
                                setState(() {
                                  c.query = '';
                                  c.notify();
                                });
                              },
                            )
                          : null,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    onChanged: (v) {
                      setState(() {
                        c.query = v;
                        c.notify();
                      });
                    },
                  ),
                ),
                if (title != 'Hidden Documents' &&
                    title != 'Deleted Documents') ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      color: AppColors.surface,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: c.categoryFilter,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.ink,
                          fontWeight: FontWeight.w500,
                        ),
                        items: [
                          'All categories',
                          ...WorkspaceController.categories,
                        ]
                            .map(
                              (x) => DropdownMenuItem(value: x, child: Text(x)),
                            )
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            c.categoryFilter = v ?? 'All categories';
                            c.notify();
                          });
                        },
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      color: AppColors.surface,
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: c.sortBy,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.ink,
                          fontWeight: FontWeight.w500,
                        ),
                        items: ['Recent', 'Name A–Z', 'Oldest', 'Expiry']
                            .map(
                              (x) => DropdownMenuItem(
                                value: x,
                                child: Text('Sort: $x'),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            c.sortBy = v ?? 'Recent';
                            c.notify();
                          });
                        },
                      ),
                    ),
                  ),
                  FilterChip(
                    label: const Text('Favourites only'),
                    selected: c.favoriteFilter,
                    avatar: Icon(
                      c.favoriteFilter ? Icons.star : Icons.star_border,
                      size: 16,
                      color: c.favoriteFilter
                          ? const Color(0xFFE5A100)
                          : AppColors.muted,
                    ),
                    onSelected: (v) {
                      setState(() {
                        c.favoriteFilter = v;
                        c.notify();
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
          if (title == 'Document Library') ...[
            const SizedBox(width: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.line),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'List view',
                    icon: Icon(
                      Icons.view_list,
                      color: !c.gridView ? AppColors.primary : AppColors.muted,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        c.gridView = false;
                        c.notify();
                      });
                    },
                  ),
                  Container(width: 1, height: 24, color: AppColors.line),
                  IconButton(
                    tooltip: 'Grid cards',
                    icon: Icon(
                      Icons.grid_view,
                      color: c.gridView ? AppColors.primary : AppColors.muted,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        c.gridView = true;
                        c.notify();
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );

    final content = <Widget>[
      controls,
      const SizedBox(height: 16),
      if (ds.isEmpty)
        EmptyStateView(
          title: title == 'Hidden Documents'
              ? 'No hidden documents'
              : title == 'Deleted Documents'
                  ? 'No deleted documents'
                  : 'No documents match your filter',
          description: title == 'Document Library'
              ? 'Try selecting another category or add new documents to your workspace.'
              : 'Items will appear here when you move documents into this folder.',
          actionLabel:
              title == 'Document Library' && widget.onUpload != null
                  ? 'Add Documents'
                  : null,
          onAction: title == 'Document Library' ? widget.onUpload : null,
        )
      else
        AppCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (c.gridView && title == 'Document Library')
                LayoutBuilder(
                  builder: (context, box) {
                    final crossCount = box.maxWidth > 950
                        ? 3
                        : box.maxWidth > 600
                            ? 2
                            : 1;
                    return Wrap(
                      spacing: 14,
                      runSpacing: 14,
                      children: ds
                          .map(
                            (d) => SizedBox(
                              width: (box.maxWidth - (crossCount - 1) * 14) /
                                  crossCount,
                              child: DocCard(doc: d, controller: c),
                            ),
                          )
                          .toList(),
                    );
                  },
                )
              else
                ...ds.map(
                  (d) => DocRow(
                    doc: d,
                    controller: c,
                    restore: title == 'Deleted Documents',
                    hidden: title == 'Hidden Documents',
                    onReviewText: widget.onReviewText,
                    onEditDoc: widget.onEditDoc,
                    onPermanentlyDelete: widget.onPermanentlyDelete,
                  ),
                ),
            ],
          ),
        ),
      if (title == 'Deleted Documents')
        const Padding(
          padding: EdgeInsets.only(top: 12),
          child: NoticeBanner(
            message:
                'Two-step permanent deletion: Permanently removing a document erases original files, OCR extraction, vector search embeddings, and Life Canvas linkages. You will be prompted twice for confirmation.',
            isDanger: true,
          ),
        ),
    ];

    return PageShell(
      title: title,
      description: title == 'Hidden Documents'
          ? 'Hidden items remain securely indexed and active for goal checklists and expiry tracking.'
          : title == 'Deleted Documents'
              ? 'Restore documents to your library or permanently purge them with two-step confirmation.'
              : 'Search, filter, and organize your personal document archive.',
      content: content,
      actions: title == 'Document Library' && widget.onUpload != null
          ? [
              FilledButton.icon(
                onPressed: widget.onUpload,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Document'),
              ),
            ]
          : [],
    );
  }
}
