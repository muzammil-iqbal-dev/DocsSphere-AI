import 'package:flutter/material.dart';

import '../data/demo_data.dart';
import '../models/models.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';

/// Central workspace controller holding all application state and business logic.
/// Screens receive a reference to this controller and call its methods.
class WorkspaceController extends ChangeNotifier {
  // ─── Document categories ────────────────────────────────────────────────────
  static const List<String> categories = [
    'Academic',
    'Research',
    'Identity',
    'Finance',
    'Legal',
    'Licence',
    'Other',
  ];

  // ─── Auth & session state ───────────────────────────────────────────────────
  bool signedIn = false;
  bool admin = false;
  String userName = 'Avery Rahman';
  String userEmail = 'demo.owner@example.test';

  // ─── Navigation ─────────────────────────────────────────────────────────────
  String page = 'Home';
  Doc? selectedDoc;

  // ─── Library state ──────────────────────────────────────────────────────────
  String categoryFilter = 'All categories';
  String sortBy = 'Recent';
  String query = '';
  bool gridView = false;
  bool favoriteFilter = false;

  // ─── UI state ───────────────────────────────────────────────────────────────
  bool reminderDismissed = false;
  String accountSearch = '';
  String accountFilter = 'All';
  String issueFilter = 'All';
  String assistantQuestion = '';
  String expiryFilter = 'All';

  // ─── Data ───────────────────────────────────────────────────────────────────
  late List<Doc> docs;
  late List<Goal> goals;
  late List<DemoAccount> accounts;
  late List<DemoIssue> issues;

  // ─── Chat ───────────────────────────────────────────────────────────────────
  List<ChatTurn> chat = [
    ChatTurn(
      false,
      'Welcome to DocSphereAI! Ask any question about your documents, deadlines, or extracted records. Answers include verifiable source citations.',
    ),
  ];

  // ─── Calendar state ─────────────────────────────────────────────────────────
  DateTime calendarMonth = DateTime(2026, 10);
  DateTime? selectedDate;
  Doc? selectedMapDoc;

  final TransformationController mapTransform = TransformationController();
  final TextEditingController searchTopBarController = TextEditingController();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  WorkspaceController() {
    resetData();
  }

  // ─── Navigation ─────────────────────────────────────────────────────────────

  List<(String, IconData, String)> get ownerNav => const [
        ('Workspace', Icons.dashboard_outlined, 'Home'),
        ('Workspace', Icons.folder_open_outlined, 'Document Library'),
        ('Workspace', Icons.star_border_outlined, 'Favourites'),
        ('Workspace', Icons.push_pin_outlined, 'Pinned Documents'),
        ('Intelligence', Icons.search, 'Smart Search'),
        ('Intelligence', Icons.smart_toy_outlined, 'AI Assistant'),
        ('Intelligence', Icons.hub_outlined, 'Life Canvas'),
        ('Intelligence', Icons.track_changes_outlined, 'Goal Dashboard'),
        ('Lifecycle', Icons.event_outlined, 'Calendar'),
        ('Lifecycle', Icons.timer_outlined, 'Expiry Tracking'),
        ('Lifecycle', Icons.visibility_off_outlined, 'Hidden Documents'),
        ('Lifecycle', Icons.delete_outline, 'Deleted Documents'),
        ('Account', Icons.settings_outlined, 'Settings'),
        ('Account', Icons.person_outline, 'Profile'),
      ];

  List<(String, IconData, String)> get adminNav => const [
        ('Management', Icons.admin_panel_settings_outlined, 'Admin Overview'),
        ('Management', Icons.manage_accounts_outlined, 'Manage Accounts'),
        ('Management', Icons.bug_report_outlined, 'Reported Issues'),
        ('Management', Icons.monitor_heart_outlined, 'Usage & Service Health'),
        ('Account', Icons.settings_outlined, 'Settings'),
        ('Account', Icons.person_outline, 'Profile'),
      ];

  // ─── Auth ────────────────────────────────────────────────────────────────────

  // UC01, UC02: Apply authenticated session
  void applySession(dynamic session) {
    signedIn = true;
    admin = session.isAdmin == true;
    userName = session.fullName.toString();
    userEmail = session.email.toString();
    page = admin ? 'Admin Overview' : 'Home';
    notifyListeners();
  }

  void signIn({required bool asAdmin, String? name, String? email}) {
    signedIn = true;
    admin = asAdmin;
    userName = name ?? (asAdmin ? 'Morgan Chen' : 'Avery Rahman');
    userEmail = email ??
        (asAdmin ? 'demo.admin@example.test' : 'demo.owner@example.test');
    page = asAdmin ? 'Admin Overview' : 'Home';
    notifyListeners();
  }

  // UC03: Log Out
  void logout() {
    signedIn = false;
    admin = false;
    selectedDoc = null;
    page = 'Home';
    notifyListeners();
  }

  // UC03: Log Out with confirmation dialog
  Future<void> confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Log Out'),
        content: const Text(
          'Are you sure you want to log out of your DocSphereAI account? Saved session data will be cleared from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'), // 3.a: Cancels and remains on current screen
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await AuthService.logout();
      logout();
      toast('You have been logged out.');
    }
  }

  // ─── Page Navigation ─────────────────────────────────────────────────────────

  void go(String destination, {VoidCallback? onError}) {
    if (!signedIn) return;
    if (admin &&
        !{
          'Admin Overview',
          'Manage Accounts',
          'Reported Issues',
          'Usage & Service Health',
          'Settings',
          'Profile',
        }.contains(destination)) {
      onError?.call();
      return;
    }
    page = destination;
    query = '';
    categoryFilter = 'All categories';
    favoriteFilter = false;
    notifyListeners();
  }

  // ─── Toast ───────────────────────────────────────────────────────────────────

  void toast(String message, {bool error = false}) {
    messengerKey.currentState?.hideCurrentSnackBar();
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              error ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        backgroundColor: error ? AppColors.danger : const Color(0xFF1E293B),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ─── Data reset ──────────────────────────────────────────────────────────────

  void resetData() {
    docs = DemoData.buildDocs();
    goals = DemoData.buildGoals(docs);
    accounts = DemoData.buildAccounts();
    issues = DemoData.buildIssues();
    chat = [
      ChatTurn(
        false,
        'Welcome to DocSphereAI! Ask any question about your documents, deadlines, or extracted records. Answers include verifiable source citations.',
      ),
    ];
  }

  // ─── Document Actions ────────────────────────────────────────────────────────

  void openDoc(Doc d) {
    selectedDoc = d;
    page = 'Document Details';
    notifyListeners();
  }

  void toggleFavorite(Doc d) {
    d.favorite = !d.favorite;
    toast(d.favorite ? 'Added to Favourites' : 'Removed from Favourites');
    notifyListeners();
  }

  void togglePin(Doc d) {
    d.pinned = !d.pinned;
    toast(d.pinned ? 'Pinned to top' : 'Unpinned');
    notifyListeners();
  }

  void hide(Doc d) {
    d.hidden = true;
    if (selectedDoc == d) page = 'Document Library';
    toast('Document hidden from primary library view.');
    notifyListeners();
  }

  void unhide(Doc d) {
    d.hidden = false;
    page = 'Document Library';
    toast('Document restored to main library view.');
    notifyListeners();
  }

  void delete(Doc d) {
    d.deleted = true;
    if (selectedDoc == d) page = 'Document Library';
    toast('Moved to Deleted Documents. Can be restored anytime.');
    notifyListeners();
  }

  void restore(Doc d) {
    d.deleted = false;
    toast('Document restored to active library.');
    notifyListeners();
  }

  void permanentlyRemove(Doc d) {
    docs.remove(d);
    if (selectedDoc == d) page = 'Document Library';
    toast('Document permanently erased.');
    notifyListeners();
  }

  void addUploadedDoc(String name, String extension) {
    docs.insert(
      0,
      Doc(
        name.split('.').first,
        'Other',
        'Uploaded file',
        'Processing',
        DateTime.now(),
        summary: 'Added from local upload. Text extraction queued.',
      ),
    );
    notifyListeners();
  }

  void saveDocText(Doc d, String text) {
    d.text = text;
    d.status = 'Ready';
    toast('Text corrections saved. Status updated to Ready.');
    notifyListeners();
  }

  void notify() => notifyListeners();

  void saveDocDetails(
    Doc d, {
    required String name,
    required String category,
    required String type,
    required String author,
    DateTime? expiry,
    String? expiryString,
  }) {
    d.name = name;
    d.category = category;
    d.type = type;
    d.author = author;
    if (expiryString != null) {
      if (expiryString.trim().isNotEmpty) {
        try {
          d.expiry = DateTime.parse(expiryString.trim());
        } catch (_) {}
      } else {
        d.expiry = null;
      }
    } else {
      d.expiry = expiry;
    }
    toast('Document details updated.');
    notifyListeners();
  }

  void handleDocAction(String action, Doc d) {
    switch (action) {
      case 'Open':
        openDoc(d);
        break;
      case 'Favorite':
        toggleFavorite(d);
        break;
      case 'Pin':
        togglePin(d);
        break;
      case 'Hide':
        d.hidden ? unhide(d) : hide(d);
        break;
      case 'Delete':
        delete(d);
        break;
    }
  }

  // ─── Goal Actions ─────────────────────────────────────────────────────────────

  void addGoal(String title, String description, List<GoalItem> items) {
    goals.add(Goal(title, items, description: description));
    toast('Goal "$title" created.');
    notifyListeners();
  }

  void updateGoal(Goal g, String title, String description) {
    g.title = title;
    g.description = description;
    toast('Goal updated.');
    notifyListeners();
  }

  void removeGoal(Goal g) {
    goals.remove(g);
    toast('Goal deleted.');
    notifyListeners();
  }

  // ─── Admin Actions ────────────────────────────────────────────────────────────

  void updateAccountStatus(DemoAccount a, String status) {
    a.status = status;
    toast(status == 'Suspended'
        ? "${a.name}'s account has been suspended."
        : "${a.name}'s account has been reactivated.");
    notifyListeners();
  }

  void updateIssue(DemoIssue issue, String status, String note) {
    issue.status = status;
    issue.note = note;
    toast('Issue status updated to "$status".');
    notifyListeners();
  }

  // ─── AI Assistant ─────────────────────────────────────────────────────────────

  void askAssistant(String question) {
    chat.add(ChatTurn(true, question));
    final q = question.toLowerCase();

    final cvDoc = docs.firstWhere((d) => d.id == 'd12', orElse: () => docs[0]);
    final slideDoc = docs.firstWhere((d) => d.id == 'd13', orElse: () => docs[1]);

    if (q.contains('passport') || q.contains('expire')) {
      chat.add(ChatTurn(
        false,
        'According to your Passport record, it was issued by Example Republic and is valid until April 18, 2027. (179 days remaining).',
        source: docs[3],
      ));
    } else if (q.contains('cv') ||
        q.contains('resume') ||
        q.contains('experience') ||
        q.contains('job')) {
      chat.add(ChatTurn(
        false,
        'Mera DocSphere AI aapki Drive se synced file dhoond laya hai! Aapka "Senior Software Engineer CV & Resume" mil gaya hai, jisme 5+ years experience (TechSphere Solutions), Flutter, Python, Qdrant Vector Search aur MSc Data Science credentials shamil hain.',
        source: cvDoc,
      ));
    } else if (q.contains('slide') ||
        q.contains('presentation') ||
        q.contains('topic') ||
        q.contains('cloud') ||
        q.contains('pitch')) {
      chat.add(ChatTurn(
        false,
        'Aapki Drive se 4 din pehle di gayi presentation slide mil gayi hai: "AI & Cloud Architecture Slides". Is slide deck ka main topic: Cloud AI Architecture, Embedding Personal Documents, Qdrant RAG pipeline, aur Life Canvas Knowledge Graph hai.',
        source: slideDoc,
      ));
    } else if (q.contains('drive') ||
        q.contains('folder') ||
        q.contains('sync') ||
        q.contains('link')) {
      chat.add(ChatTurn(
        false,
        'DocSphere AI aapki connected Drive / Local Folder ke sath active sync mein hai. Is folder ke tamam PDFs, presentation slides, photos, aur docs automatically scan, OCR extract, aur semantic index ho chuke hain.',
        source: slideDoc,
      ));
    } else if (q.contains('degree') ||
        q.contains('transcript') ||
        q.contains('study') ||
        q.contains('academic')) {
      chat.add(ChatTurn(
        false,
        'You have an official Academic Transcript from Northbridge University for the MSc Data Science programme completed on 2025-06-12 with Distinction.',
        source: docs[0],
      ));
    } else if (q.contains('review')) {
      chat.add(ChatTurn(
        false,
        'Your University Certificate currently has low-confidence extracted fields and requires manual verification in the OCR Review workspace.',
        source: docs[2],
      ));
    } else {
      chat.add(ChatTurn(
        false,
        'Maine aapke synced Drive aur documents knowledge base ko semantic search kiya. Related matching documents mil gaye hain with high similarity score.',
        source: docs[0],
      ));
    }
    notifyListeners();
  }

  // ─── Query/Filter Helpers ─────────────────────────────────────────────────────

  List<Doc> get visibleDocs => docs.where((d) => !d.hidden && !d.deleted).toList();

  List<Doc> filteredDocs(String mode) {
    var list = docs
        .where(
          (d) => switch (mode) {
            'Hidden Documents' => d.hidden && !d.deleted,
            'Deleted Documents' => d.deleted,
            'Favourites' => d.favorite && !d.hidden && !d.deleted,
            'Pinned Documents' => d.pinned && !d.hidden && !d.deleted,
            _ => !d.hidden && !d.deleted,
          },
        )
        .toList();

    if (categoryFilter != 'All categories') {
      list = list.where((d) => d.category == categoryFilter).toList();
    }
    if (favoriteFilter) list = list.where((d) => d.favorite).toList();
    if (query.isNotEmpty) {
      list = list
          .where(
            (d) => '${d.name} ${d.category} ${d.type} ${d.text}'
                .toLowerCase()
                .contains(query.toLowerCase()),
          )
          .toList();
    }

    list.sort((a, b) {
      if (a.pinned != b.pinned) return a.pinned ? -1 : 1;
      return switch (sortBy) {
        'Name A–Z' => a.name.compareTo(b.name),
        'Oldest' => a.added.compareTo(b.added),
        'Expiry' =>
          (a.expiry ?? DateTime(9999)).compareTo(b.expiry ?? DateTime(9999)),
        _ => b.added.compareTo(a.added),
      };
    });

    return list;
  }

  List<Doc> get expiryDocs {
    final list = docs.where((d) => !d.deleted && d.expiry != null).toList();
    list.sort((a, b) => a.expiry!.compareTo(b.expiry!));
    return list;
  }

  List<Doc> get calendarDocs =>
      docs.where((d) => !d.deleted && d.expiry != null).toList();

  String expiryState(Doc d) {
    if (d.expiry == null) return 'Valid';
    final now = DateTime.now();
    if (d.expiry!.isBefore(now)) return 'Expired';
    if (d.expiry!.difference(now).inDays <= 30) return 'Expiring Soon';
    return 'Valid';
  }

  String effectiveStatus(Doc d) =>
      d.deleted ? 'Deleted' : d.hidden ? 'Hidden' : d.status;

  // ─── Goal Helpers ─────────────────────────────────────────────────────────────

  (int, int, int) goalProgress(Goal g) {
    if (g.items.isEmpty) return (0, 0, 0);
    var ready = 0;
    for (final it in g.items) {
      final d = it.doc;
      if (d != null &&
          !d.deleted &&
          d.status == 'Ready' &&
          (d.expiry == null || d.expiry!.isAfter(DateTime.now()))) {
        ready++;
      }
    }
    final pct = ((ready / g.items.length) * 100).round();
    return (pct, ready, g.items.length);
  }

  // ─── Formatting Utilities ────────────────────────────────────────────────────

  static String formatDate(DateTime? d) =>
      d == null ? 'Not set' : '${_month(d.month)} ${d.day}, ${d.year}';

  static String _month(int m) => const [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ][m - 1];

  static String initials(String name) => name
      .trim()
      .split(RegExp(r'\s+'))
      .take(2)
      .map((w) => w.isEmpty ? '' : w[0])
      .join()
      .toUpperCase();

  static IconData docIcon(String category) => switch (category) {
        'Academic' => Icons.school_outlined,
        'Research' => Icons.article_outlined,
        'Identity' => Icons.badge_outlined,
        'Finance' => Icons.receipt_long_outlined,
        'Legal' => Icons.gavel_outlined,
        'Licence' => Icons.credit_card_outlined,
        _ => Icons.description_outlined,
      };

  static String snippet(Doc d, String q) {
    final i = d.text.toLowerCase().indexOf(q);
    return i < 0
        ? d.summary
        : d.text
            .substring(
              i - 25 < 0 ? 0 : i - 25,
              i + 100 > d.text.length ? d.text.length : i + 100,
            )
            .replaceAll('\n', ' ');
  }

  @override
  void dispose() {
    searchTopBarController.dispose();
    mapTransform.dispose();
    super.dispose();
  }
}
