import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Semantic smart search screen across documents and extracted OCR text.
class SearchScreen extends StatefulWidget {
  final WorkspaceController controller;

  const SearchScreen({super.key, required this.controller});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.controller.query);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

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
    final c = widget.controller;
    if (_textController.text != c.query) {
      _textController.text = c.query;
      _textController.selection =
          TextSelection.collapsed(offset: c.query.length);
    }

    final q = c.query.trim().toLowerCase();
    final results = c.visibleDocs
        .where(
          (d) =>
              d.status == 'Ready' &&
              ('${d.name} ${d.category} ${d.text} ${d.summary}'
                  .toLowerCase()
                  .contains(q)),
        )
        .toList();

    return PageShell(
      title: 'Smart Search',
      description:
          'Query your personal knowledge base in natural, everyday language.',
      content: [
        AppCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _textController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, size: 22),
                  hintText:
                      'Try: "When does my passport expire?" or "Data science degree"',
                  suffixIcon: c.query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              c.query = '';
                              _textController.clear();
                              c.notify();
                            });
                          },
                        )
                      : null,
                ),
                onChanged: (v) {
                  setState(() {
                    c.query = v;
                    c.notify();
                  });
                },
                onSubmitted: (v) {
                  setState(() {
                    c.query = v;
                    c.notify();
                  });
                },
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  'Show documents about my studies',
                  'Find documents expiring soon',
                  'Search for lab invoice details',
                  'Passport renewal documents',
                ]
                    .map(
                      (s) => ActionChip(
                        label: Text(s),
                        avatar: const Icon(Icons.north_west, size: 14),
                        onPressed: () {
                          setState(() {
                            c.query = s;
                            _textController.text = s;
                            c.notify();
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
              const Divider(height: 32),
              _title(
                q.isEmpty
                    ? 'Search ready documents'
                    : '${results.length} matching result${results.length == 1 ? '' : 's'}',
                icon: Icons.manage_search_outlined,
              ),
              const SizedBox(height: 12),
              if (q.isEmpty)
                const Text(
                  'Enter keywords, names, authorities, or dates to find relevant documents across your library.',
                  style: TextStyle(color: AppColors.muted, fontSize: 13.5),
                )
              else if (results.isEmpty)
                const EmptyStateView(
                  title: 'No matching documents found',
                  description:
                      'Try searching with broader terms or check if the document is in Processing.',
                )
              else
                ...results.map(
                  (d) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.surfaceSubtle,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(color: AppColors.line),
                      ),
                      child: ListTile(
                        leading: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: AppColors.primaryPale,
                            borderRadius: BorderRadius.circular(AppRadius.md),
                          ),
                          child: Icon(
                            WorkspaceController.docIcon(d.category),
                            color: AppColors.primary,
                            size: 19,
                          ),
                        ),
                        title: Text(
                          d.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '${d.category} · ${WorkspaceController.snippet(d, q)}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppColors.inkSubtle,
                              fontSize: 12.5,
                            ),
                          ),
                        ),
                        trailing: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            StatusBadge(label: 'Ready'),
                            SizedBox(width: 8),
                            Icon(Icons.chevron_right, size: 18),
                          ],
                        ),
                        onTap: () => c.openDoc(d),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 14),
              const NoticeBanner(
                message:
                    'Natural language demonstration: Connected semantic vector search maps embeddings to Qdrant for semantic similarity.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
