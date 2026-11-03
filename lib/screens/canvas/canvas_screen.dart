import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Interactive document knowledge graph visualization screen.
class CanvasScreen extends StatefulWidget {
  final WorkspaceController controller;
  final VoidCallback? onUpload;

  const CanvasScreen({
    super.key,
    required this.controller,
    this.onUpload,
  });

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
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
    final c = widget.controller;
    final nodes =
        c.visibleDocs.where((d) => d.status == 'Ready').take(6).toList();

    if (nodes.length < 2) {
      return PageShell(
        title: 'Life Canvas',
        description:
            'Explore how your personal documents connect across shared topics, authors, and dates.',
        content: [
          EmptyStateView(
            title: 'Add more ready documents to generate your document graph',
            description:
                'Documents connect automatically once OCR text and semantic search indexing complete.',
            actionLabel: widget.onUpload != null ? 'Add Documents' : null,
            onAction: widget.onUpload,
          ),
        ],
      );
    }

    return PageShell(
      title: 'Life Canvas',
      description:
          'Interactive document knowledge graph. Click on any node to view connections and details.',
      content: [
        LayoutBuilder(
          builder: (context, box) {
            final compact = box.maxWidth < 880;

            final graph = AppCard(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Container(
                    height: 480,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF9FAFC),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg),
                      ),
                    ),
                    child: InteractiveViewer(
                      transformationController: c.mapTransform,
                      minScale: 0.5,
                      maxScale: 2.5,
                      constrained: false,
                      child: SizedBox(
                        width: 780,
                        height: 480,
                        child: Stack(
                          children: [
                            CustomPaint(
                              size: const Size(780, 480),
                              painter: GraphPainter(nodes.length),
                            ),
                            ...List.generate(nodes.length, (i) {
                              final positions = [
                                const Offset(80, 70),
                                const Offset(330, 50),
                                const Offset(580, 90),
                                const Offset(140, 280),
                                const Offset(390, 260),
                                const Offset(630, 300),
                              ];
                              final p = positions[i];
                              final d = nodes[i];
                              final isSelected = c.selectedMapDoc == d;

                              return Positioned(
                                left: p.dx,
                                top: p.dy,
                                child: SizedBox(
                                  width: 140,
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          c.selectedMapDoc = d;
                                          c.notify();
                                        });
                                      },
                                      borderRadius:
                                          BorderRadius.circular(AppRadius.md),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: isSelected
                                              ? AppColors.primaryPale
                                              : Colors.white,
                                          border: Border.all(
                                            color: isSelected
                                                ? AppColors.primary
                                                : AppColors.line,
                                            width: isSelected ? 2 : 1,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.md,
                                          ),
                                          boxShadow: isSelected
                                              ? AppShadows.hover
                                              : AppShadows.subtle,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 32,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : AppColors.primaryPale,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  AppRadius.sm,
                                                ),
                                              ),
                                              child: Icon(
                                                WorkspaceController.docIcon(
                                                    d.category),
                                                size: 16,
                                                color: isSelected
                                                    ? Colors.white
                                                    : AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              d.name,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 12,
                                                color: isSelected
                                                    ? AppColors.primary
                                                    : AppColors.ink,
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              d.category,
                                              style: const TextStyle(
                                                color: AppColors.muted,
                                                fontSize: 10.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.mouse_outlined,
                          size: 16,
                          color: AppColors.muted,
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text(
                            'Click and drag to pan · Scroll to zoom',
                            style: TextStyle(
                              color: AppColors.muted,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Zoom Out',
                          onPressed: () => c.mapTransform.value =
                              Matrix4.diagonal3Values(0.8, 0.8, 1),
                          icon: const Icon(Icons.remove, size: 20),
                        ),
                        IconButton(
                          tooltip: 'Reset Map View',
                          onPressed: () =>
                              c.mapTransform.value = Matrix4.identity(),
                          icon: const Icon(Icons.center_focus_strong, size: 20),
                        ),
                        IconButton(
                          tooltip: 'Zoom In',
                          onPressed: () => c.mapTransform.value =
                              Matrix4.diagonal3Values(1.2, 1.2, 1),
                          icon: const Icon(Icons.add, size: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );

            final detail = AppCard(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _title(
                    c.selectedMapDoc?.name ?? 'Node details',
                    icon: Icons.info_outline,
                  ),
                  const SizedBox(height: 12),
                  if (c.selectedMapDoc != null) ...[
                    _detailField('Category', c.selectedMapDoc!.category),
                    _detailField(
                      'Authority',
                      c.selectedMapDoc!.author.isEmpty
                          ? 'Not specified'
                          : c.selectedMapDoc!.author,
                    ),
                    const SizedBox(height: 8),
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
                      c.selectedMapDoc!.summary,
                      style: const TextStyle(
                        color: AppColors.inkSubtle,
                        height: 1.5,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => c.openDoc(c.selectedMapDoc!),
                      icon: const Icon(Icons.open_in_new, size: 16),
                      label: const Text('Open Document'),
                    ),
                  ] else ...[
                    const Text(
                      'Select any node in the graph map to inspect connected metadata and relationships.',
                      style: TextStyle(color: AppColors.muted, fontSize: 13),
                    ),
                  ],
                  const SizedBox(height: 16),
                  const NoticeBanner(
                    message:
                        'Graph connections represent shared themes, co-author linkages, and credential prerequisites.',
                  ),
                ],
              ),
            );

            return compact
                ? Column(children: [graph, const SizedBox(height: 16), detail])
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: graph),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: detail),
                    ],
                  );
          },
        ),
      ],
    );
  }
}

/// Custom painter for curved relationship links between document nodes.
class GraphPainter extends CustomPainter {
  final int count;
  GraphPainter(this.count);

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFFC7D7FA)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final points = [
      const Offset(150, 110),
      const Offset(400, 90),
      const Offset(650, 130),
      const Offset(210, 320),
      const Offset(460, 300),
      const Offset(700, 340),
    ];

    final n = math.min(count, points.length);
    for (var i = 0; i < n; i++) {
      for (var j = i + 1; j < n; j++) {
        if ((i + j) % 2 == 0) {
          final p1 = points[i];
          final p2 = points[j];
          final path = Path();
          path.moveTo(p1.dx, p1.dy);
          final midX = (p1.dx + p2.dx) / 2;
          final midY = (p1.dy + p2.dy) / 2 - 20;
          path.quadraticBezierTo(midX, midY, p2.dx, p2.dy);
          canvas.drawPath(path, linePaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant GraphPainter oldDelegate) =>
      oldDelegate.count != count;
}
