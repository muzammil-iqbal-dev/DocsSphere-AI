import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Interactive AI Assistant screen with grounded source citations and suggestion chips.
class AssistantScreen extends StatefulWidget {
  final WorkspaceController controller;

  const AssistantScreen({super.key, required this.controller});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendQuestion(String q) {
    if (q.trim().isEmpty) return;
    widget.controller.askAssistant(q.trim());
    _textController.clear();
    setState(() {});
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;

    final turns = c.chat.map((m) {
      final bubble = Container(
        constraints: const BoxConstraints(maxWidth: 720),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: m.user ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: m.user ? null : Border.all(color: AppColors.line),
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!m.user)
              Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.primaryPale,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: const Icon(
                      Icons.smart_toy_outlined,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'DocSphere AI Assistant',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            if (!m.user) const SizedBox(height: 8),
            Text(
              m.text,
              style: TextStyle(
                color: m.user ? Colors.white : AppColors.ink,
                height: 1.5,
                fontSize: 13.5,
              ),
            ),
            if (m.source != null) ...[
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: TextButton.icon(
                  onPressed: () => c.openDoc(m.source!),
                  icon: const Icon(Icons.source_outlined, size: 16),
                  label: Text('Source: ${m.source!.name}'),
                ),
              ),
            ],
          ],
        ),
      );

      return Align(
        alignment: m.user ? Alignment.centerRight : Alignment.centerLeft,
        child: bubble,
      );
    }).toList();

    const suggestions = [
      'When does my passport expire?',
      'What degree certificates do I have?',
      'Which documents need manual review?',
      'Check fellowship application checklist',
    ];

    return PageShell(
      title: 'AI Assistant',
      description:
          'Ask questions grounded directly in your uploaded and verified documents.',
      content: [
        AppCard(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Chat turns
              Container(
                height: 380,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView(
                  controller: _scrollController,
                  children: turns,
                ),
              ),
              const Divider(height: 24),
              // Suggestions
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: suggestions
                    .map(
                      (s) => ActionChip(
                        label: Text(s),
                        onPressed: () => _sendQuestion(s),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 14),
              // Prompt Input Area
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: const InputDecoration(
                        hintText: 'Ask a question about your documents…',
                        prefixIcon: Icon(Icons.chat_bubble_outline),
                      ),
                      onSubmitted: _sendQuestion,
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: () => _sendQuestion(_textController.text),
                    icon: const Icon(Icons.send, size: 16),
                    label: const Text('Ask'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const NoticeBanner(
                message:
                    'Demonstration RAG interface: All answers are synthesized with strict citation boundaries ensuring document grounding.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
