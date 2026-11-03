import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Admin screen displaying service telemetry, latency, and microservice uptimes.
class HealthScreen extends StatelessWidget {
  final WorkspaceController controller;

  const HealthScreen({super.key, required this.controller});

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
      title: 'Usage & Service Health',
      description:
          'Telemetry signals, latency, and uptime across microservices.',
      content: [
        LayoutBuilder(
          builder: (context, box) {
            final count = box.maxWidth > 950 ? 4 : 2;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: count,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 2.3,
              children: [
                StatCard(
                  label: 'Active accounts',
                  value: '${c.accounts.length}',
                  icon: Icons.people_outline,
                  detail: 'All registered accounts',
                ),
                StatCard(
                  label: 'Stored documents',
                  value: '${c.docs.length}',
                  icon: Icons.upload_file_outlined,
                  detail: 'Total system storage count',
                ),
                StatCard(
                  label: 'OCR accuracy index',
                  value: '98.4%',
                  icon: Icons.auto_awesome_outlined,
                  detail: 'Confidence across extractions',
                  accentColor: AppColors.secondary,
                ),
                StatCard(
                  label: 'Gateway latency',
                  value: '18 ms',
                  icon: Icons.speed_outlined,
                  detail: 'FastAPI gateway response',
                  accentColor: AppColors.primary,
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _title(
                'Operational backend telemetry',
                icon: Icons.health_and_safety_outlined,
              ),
              const SizedBox(height: 12),
              ...[
                [
                  'Text Reading & OCR Pipeline',
                  'Ready',
                  'Tesseract / EasyOCR (Urdu & English) · 12 ms avg',
                ],
                [
                  'AI Classification & Extraction',
                  'Ready',
                  'LangChain Entity Extractor · 84 ms avg',
                ],
                [
                  'Qdrant Vector Database',
                  'Ready',
                  'qdrant-server:6333 · 99.98% uptime',
                ],
                [
                  'MongoDB Storage Engine',
                  'Ready',
                  'mongodb:27017 · 42ms read latency',
                ],
              ].map(
                (s) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    s[0],
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: Text(s[2]),
                  trailing: StatusBadge(label: s[1]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
