import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/models.dart';
import '../screens/admin/accounts_screen.dart';
import '../screens/admin/admin_overview_screen.dart';
import '../screens/admin/health_screen.dart';
import '../screens/admin/issues_screen.dart';
import '../screens/assistant/assistant_screen.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/calendar/calendar_screen.dart';
import '../screens/canvas/canvas_screen.dart';
import '../screens/details/document_detail_screen.dart';
import '../screens/expiry/expiry_screen.dart';
import '../screens/goals/goals_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/library/library_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../theme/app_theme.dart';
import '../widgets/app_components.dart';
import '../widgets/nav_sidebar.dart';
import '../widgets/top_bar.dart';
import 'workspace_controller.dart';

/// Top-level shell managing application layout, page routing, and modal dialogs.
class WorkspaceShell extends StatefulWidget {
  const WorkspaceShell({super.key});

  @override
  State<WorkspaceShell> createState() => _WorkspaceShellState();
}

class _WorkspaceShellState extends State<WorkspaceShell> {
  late final WorkspaceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WorkspaceController();
    _controller.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  // ─── Modal Dialogs ────────────────────────────────────────────────────────────

  Future<void> _upload() async {
    final selected = <LocalPick>[];
    String? error;
    bool dragging = false;

    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, refresh) => AlertDialog(
          title: const Text('Add Documents to DocSphereAI'),
          content: SizedBox(
            width: 680,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const NoticeBanner(
                  message:
                      'Local Processing Mode: Drag and drop files to simulate multi-stage OCR reading, classification, and vector indexing.',
                ),
                const SizedBox(height: 14),
                // Drop Target
                DropTarget(
                  onDragEntered: (_) => refresh(() => dragging = true),
                  onDragExited: (_) => refresh(() => dragging = false),
                  onDragDone: (details) async {
                    final good = <LocalPick>[];
                    final issues = <String>[];
                    for (final file in details.files) {
                      final ext = file.name.contains('.')
                          ? file.name.split('.').last.toLowerCase()
                          : 'folder';
                      final length = await file.length();
                      good.add(LocalPick(file.name, length, ext));
                    }
                    refresh(() {
                      selected.addAll(good);
                      error = issues.isEmpty ? null : issues.join('\n');
                      dragging = false;
                    });
                  },
                  child: Container(
                    height: 140,
                    decoration: BoxDecoration(
                      color: dragging
                          ? AppColors.primaryPale
                          : AppColors.background,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(
                        color: dragging ? AppColors.primary : AppColors.line,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_upload_outlined,
                            size: 36,
                            color: dragging
                                ? AppColors.primary
                                : AppColors.muted,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            dragging
                                ? 'Release to add entire folder & documents'
                                : 'Drag & drop entire folders, slides, photos, or documents (No size limit)',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: dragging
                                  ? AppColors.primary
                                  : AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            alignment: WrapAlignment.center,
                            children: [
                              OutlinedButton.icon(
                                onPressed: () async {
                                  final result = await FilePicker.pickFiles(
                                    allowMultiple: true,
                                  );
                                  if (result != null) {
                                    refresh(() {
                                      for (final f in result.files) {
                                        selected.add(
                                          LocalPick(
                                            f.name,
                                            f.size,
                                            f.extension ?? 'doc',
                                          ),
                                        );
                                      }
                                    });
                                  }
                                },
                                icon: const Icon(Icons.file_open_outlined, size: 16),
                                label: const Text('Browse Files'),
                              ),
                              FilledButton.tonalIcon(
                                onPressed: () async {
                                  final dirPath = await FilePicker.getDirectoryPath();
                                  if (dirPath != null) {
                                    refresh(() {
                                      final folderName = dirPath.split(RegExp(r'[\\/]')).last;
                                      selected.addAll([
                                        LocalPick('$folderName/Slides_Presentation.pptx', 1845000, 'pptx'),
                                        LocalPick('$folderName/CV_Resume_Final.pdf', 320000, 'pdf'),
                                        LocalPick('$folderName/Project_Documentation.docx', 510000, 'docx'),
                                        LocalPick('$folderName/ID_Passport_Photo.png', 890000, 'png'),
                                      ]);
                                      _controller.toast('Synced Drive/Folder: $folderName with all documents, slides & photos');
                                    });
                                  }
                                },
                                icon: const Icon(Icons.add_to_drive, size: 16),
                                label: const Text('Sync Drive / Folder'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (error != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    error!,
                    style: const TextStyle(
                      color: AppColors.danger,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 14),
                if (selected.isNotEmpty) ...[
                  const Text(
                    'SELECTED FILES TO PROCESS',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.mutedLight,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    constraints: const BoxConstraints(maxHeight: 160),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: selected.length,
                      itemBuilder: (context, idx) {
                        final pick = selected[idx];
                        return ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(
                            Icons.description_outlined,
                            color: AppColors.primary,
                          ),
                          title: Text(
                            pick.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            '${(pick.size / 1024).toStringAsFixed(1)} KB · .${pick.extension}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              StatusBadge(label: pick.status),
                              IconButton(
                                icon: const Icon(Icons.close, size: 16),
                                onPressed: () => refresh(
                                  () => selected.removeAt(idx),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: selected.isEmpty
                  ? null
                  : () {
                      for (final p in selected) {
                        _controller.docs.insert(
                          0,
                          Doc(
                            p.name.split('.').first,
                            'Other',
                            'Uploaded file',
                            'Processing',
                            DateTime.now(),
                            summary:
                                'Added from local upload. Text extraction queued.',
                          ),
                        );
                      }
                      _controller.notify();
                      Navigator.pop(context);
                      _controller
                          .toast('${selected.length} document(s) added.');
                    },
              child: Text('Process ${selected.length} File(s)'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _reviewText(Doc d) async {
    final text = TextEditingController(text: d.text);

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Review Extracted OCR Text: ${d.name}'),
        content: SizedBox(
          width: 880,
          height: 520,
          child: Row(
            children: [
              // Simulated Document View
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSubtle,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.line),
                  ),
                  child: Center(
                    child: Container(
                      width: 270,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(color: AppColors.line),
                        boxShadow: AppShadows.card,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            d.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const Divider(height: 20),
                          ...List.generate(
                            8,
                            (i) => Container(
                              height: 6,
                              width: i % 2 == 0 ? 210 : 250,
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: i == 2
                                    ? AppColors.warningBg
                                    : const Color(0xFFE8EEF5),
                                borderRadius: BorderRadius.circular(3),
                                border: i == 2
                                    ? Border.all(color: AppColors.warning)
                                    : null,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'Low confidence areas highlighted in amber',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Text Correction Editor
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'EDITABLE EXTRACTED TEXT',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.mutedLight,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: TextField(
                        controller: text,
                        maxLines: null,
                        expands: true,
                        style: const TextStyle(
                          fontFamily: 'Consolas, monospace',
                          fontSize: 13,
                          height: 1.6,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Extracted text...',
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const NoticeBanner(
                      message:
                          'Saving corrected text updates the search index and recalculates entity links.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save Verified Text'),
          ),
        ],
      ),
    );

    if (saved == true) {
      _controller.saveDocText(d, text.text);
    }
    text.dispose();
  }

  Future<void> _editDoc(Doc d) async {
    final name = TextEditingController(text: d.name);
    final type = TextEditingController(text: d.type);
    final authority = TextEditingController(text: d.author);
    final expiry = TextEditingController(
      text: d.expiry == null
          ? ''
          : '${d.expiry!.year}-${d.expiry!.month.toString().padLeft(2, '0')}-${d.expiry!.day.toString().padLeft(2, '0')}',
    );
    var category = d.category;

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, refresh) => AlertDialog(
          title: const Text('Edit Document Details'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Document Name'),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: WorkspaceController.categories
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => refresh(() => category = v ?? category),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: type,
                  decoration: const InputDecoration(labelText: 'Document Type'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: authority,
                  decoration:
                      const InputDecoration(labelText: 'Issuing Authority'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: expiry,
                  decoration: const InputDecoration(
                    labelText: 'Expiry Date (YYYY-MM-DD)',
                    hintText: '2027-04-18',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Save Details'),
            ),
          ],
        ),
      ),
    );

    if (saved == true) {
      _controller.saveDocDetails(
        d,
        name: name.text.trim(),
        category: category,
        type: type.text.trim(),
        author: authority.text.trim(),
        expiryString: expiry.text.trim(),
      );
    }

    name.dispose();
    type.dispose();
    authority.dispose();
    expiry.dispose();
  }

  Future<void> _newGoal() async {
    final title = TextEditingController();
    final desc = TextEditingController();
    final itemControllers = <TextEditingController>[
      TextEditingController(text: 'Identity document'),
    ];

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, refresh) => AlertDialog(
          title: const Text('Create New Goal'),
          content: SizedBox(
            width: 520,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: title,
                  decoration: const InputDecoration(
                    labelText: 'Goal Title',
                    hintText: 'e.g. Renew Passport or Apply for Visa',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: desc,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'REQUIRED DOCUMENTS CHECKLIST',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.mutedLight,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                ...List.generate(itemControllers.length, (i) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: itemControllers[i],
                            decoration: InputDecoration(
                              labelText: 'Document Requirement ${i + 1}',
                              isDense: true,
                            ),
                          ),
                        ),
                        if (itemControllers.length > 1)
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18),
                            onPressed: () => refresh(
                              () => itemControllers.removeAt(i),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(
                  onPressed: () => refresh(
                    () => itemControllers.add(TextEditingController()),
                  ),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Document Requirement'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Create Goal'),
            ),
          ],
        ),
      ),
    );

    if (saved == true && title.text.trim().isNotEmpty) {
      final items = itemControllers
          .where((c) => c.text.trim().isNotEmpty)
          .map((c) => GoalItem(c.text.trim()))
          .toList();

      _controller.goals.add(
        Goal(title.text.trim(), items, description: desc.text.trim()),
      );
      _controller.notify();
      _controller.toast('Goal "${title.text.trim()}" created.');
    }

    title.dispose();
    desc.dispose();
    for (final c in itemControllers) {
      c.dispose();
    }
  }

  Future<void> _editGoal(Goal g) async {
    final title = TextEditingController(text: g.title);
    final desc = TextEditingController(text: g.description);

    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Goal'),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Goal Title'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: desc,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save Changes'),
          ),
        ],
      ),
    );

    if (saved == true) {
      g.title = title.text.trim();
      g.description = desc.text.trim();
      _controller.notify();
      _controller.toast('Goal updated.');
    }
    title.dispose();
    desc.dispose();
  }

  Future<void> _deleteGoal(Goal g) async {
    final confirm = await _confirm(
      'Delete Goal',
      'Are you sure you want to delete "${g.title}"? Your documents will remain safe in the library.',
      'Delete',
      danger: true,
    );
    if (confirm) {
      _controller.goals.remove(g);
      _controller.notify();
      _controller.toast('Goal deleted.');
    }
  }

  Future<bool> _confirm(
    String title,
    String message,
    String confirm, {
    bool danger = false,
  }) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              style: danger
                  ? FilledButton.styleFrom(
                      backgroundColor: AppColors.danger,
                    )
                  : null,
              child: Text(confirm),
            ),
          ],
        ),
      ) ??
      false;

  Future<void> _permanentlyDelete(Doc d) async {
    final first = await _confirm(
      'Confirmation 1 of 2: Permanent Deletion',
      'This action will permanently delete "${d.name}". Are you sure you wish to proceed?',
      'Continue',
      danger: true,
    );
    if (!first) return;

    if (!mounted) return;
    final second = await _confirm(
      'Confirm permanent deletion',
      'Final confirmation: All file data, OCR text, and search vectors will be irrecoverably destroyed.',
      'Delete permanently',
      danger: true,
    );
    if (second) {
      _controller.docs.remove(d);
      if (_controller.selectedDoc == d) {
        _controller.page = 'Document Library';
      }
      _controller.notify();
      _controller.toast('Document permanently erased.');
    }
  }

  Future<void> _showNotifications() async {
    final alerts = _controller.expiryDocs
        .where((d) => _controller.expiryState(d) != 'Valid')
        .toList();

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications & Reminders'),
        content: SizedBox(
          width: 520,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const NoticeBanner(
                message:
                    'In-App Notification Center: Reminders notify you of upcoming and expired document deadlines.',
              ),
              const SizedBox(height: 12),
              if (alerts.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'No active expiry notifications. All documents are valid.',
                      style: TextStyle(color: AppColors.muted),
                    ),
                  ),
                )
              else
                ...alerts.map(
                  (d) => ListTile(
                    leading: Icon(
                      WorkspaceController.docIcon(d.category),
                      color: AppColors.primary,
                    ),
                    title: Text(
                      d.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Expires ${WorkspaceController.formatDate(d.expiry)}',
                    ),
                    trailing: StatusBadge(label: _controller.expiryState(d)),
                    onTap: () {
                      Navigator.pop(context);
                      _controller.openDoc(d);
                    },
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _resetDemo() async {
    final confirmed = await _confirm(
      'Reset Sample Workspace',
      'This will reset documents, goals, and accounts to the initial sample state.',
      'Reset Workspace',
      danger: true,
    );
    if (confirmed) {
      _controller.resetData();
      _controller.selectedDoc = null;
      _controller.page = _controller.admin ? 'Admin Overview' : 'Home';
      _controller.notify();
      _controller.toast('Sample workspace reset successfully.');
    }
  }

  // ─── Page Router ──────────────────────────────────────────────────────────────

  Widget _pageBody() {
    final page = _controller.page;
    switch (page) {
      case 'Home':
        return HomeScreen(
          controller: _controller,
          onUpload: _upload,
          onReviewText: _reviewText,
          onEditDoc: _editDoc,
          onNewGoal: _newGoal,
        );
      case 'Document Library':
      case 'Favourites':
      case 'Pinned Documents':
      case 'Hidden Documents':
      case 'Deleted Documents':
        return LibraryScreen(
          controller: _controller,
          mode: page,
          onUpload: _upload,
          onReviewText: _reviewText,
          onEditDoc: _editDoc,
          onPermanentlyDelete: _permanentlyDelete,
        );
      case 'Document Details':
        return DocumentDetailScreen(
          controller: _controller,
          onReviewText: _reviewText,
          onEditDoc: _editDoc,
          onPermanentlyDelete: _permanentlyDelete,
        );
      case 'Smart Search':
        return SearchScreen(controller: _controller);
      case 'AI Assistant':
        return AssistantScreen(controller: _controller);
      case 'Life Canvas':
        return CanvasScreen(
          controller: _controller,
          onUpload: _upload,
        );
      case 'Goal Dashboard':
        return GoalsScreen(
          controller: _controller,
          onNewGoal: _newGoal,
          onEditGoal: _editGoal,
          onDeleteGoal: _deleteGoal,
          onAddDocument: _upload,
        );
      case 'Calendar':
        return CalendarScreen(
          controller: _controller,
          onReviewText: _reviewText,
          onEditDoc: _editDoc,
        );
      case 'Expiry Tracking':
        return ExpiryScreen(
          controller: _controller,
          onReviewText: _reviewText,
          onEditDoc: _editDoc,
        );
      case 'Admin Overview':
        return AdminOverviewScreen(
          controller: _controller,
          onIssueTap: (_) => _controller.go('Reported Issues'),
        );
      case 'Manage Accounts':
        return AccountsScreen(controller: _controller);
      case 'Reported Issues':
        return IssuesScreen(controller: _controller);
      case 'Usage & Service Health':
        return HealthScreen(controller: _controller);
      case 'Profile':
        return ProfileScreen(controller: _controller);
      case 'Settings':
        return SettingsScreen(
          controller: _controller,
          onShowNotifications: _showNotifications,
          onResetDemo: _resetDemo,
        );
      default:
        return HomeScreen(
          controller: _controller,
          onUpload: _upload,
          onReviewText: _reviewText,
          onEditDoc: _editDoc,
          onNewGoal: _newGoal,
        );
    }
  }

  Widget _workspaceLayout() {
    return Row(
      children: [
        NavSidebar(controller: _controller),
        Expanded(
          child: Column(
            children: [
              TopBar(
                controller: _controller,
                onShowNotifications: _showNotifications,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: KeyedSubtree(
                    key: ValueKey(
                      '${_controller.page}-${_controller.selectedDoc?.id}',
                    ),
                    child: _pageBody(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _controller.messengerKey,
      child: Scaffold(
        body: _controller.signedIn
            ? _workspaceLayout()
            : AuthScreen(controller: _controller),
      ),
    );
  }
}
