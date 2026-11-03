import 'package:flutter/material.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_components.dart';
import '../../widgets/doc_row.dart';
import '../../widgets/page_shell.dart';
import '../../workspace/workspace_controller.dart';

/// Monthly calendar view of document expiration milestones and renewal dates.
class CalendarScreen extends StatefulWidget {
  final WorkspaceController controller;
  final void Function(Doc doc)? onReviewText;
  final void Function(Doc doc)? onEditDoc;

  const CalendarScreen({
    super.key,
    required this.controller,
    this.onReviewText,
    this.onEditDoc,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

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

  Widget _calendarCell(
    DateTime day,
    Map<String, List<Doc>> events,
    WorkspaceController c,
  ) {
    final key = '${day.year}-${day.month}-${day.day}';
    final inMonth = day.month == c.calendarMonth.month;
    final isSelected = c.selectedDate != null &&
        c.selectedDate!.year == day.year &&
        c.selectedDate!.month == day.month &&
        c.selectedDate!.day == day.day;
    final count = events[key]?.length ?? 0;

    return InkWell(
      onTap: () {
        setState(() {
          c.selectedDate = day;
          c.notify();
        });
      },
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        margin: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryPale
              : count > 0
                  ? AppColors.surfaceSubtle
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: isSelected ? Border.all(color: AppColors.primary) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${day.day}',
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                color: inMonth
                    ? (isSelected ? AppColors.primary : AppColors.ink)
                    : AppColors.mutedLight,
                fontSize: 13,
              ),
            ),
            if (count > 0)
              Container(
                margin: const EdgeInsets.only(top: 2),
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final first = DateTime(c.calendarMonth.year, c.calendarMonth.month, 1);
    final start = DateTime(
      c.calendarMonth.year,
      c.calendarMonth.month,
      1 - first.weekday % 7,
    );

    final events = <String, List<Doc>>{};
    for (final d in c.calendarDocs) {
      final date = d.expiry!;
      final key = '${date.year}-${date.month}-${date.day}';
      events.putIfAbsent(key, () => []).add(d);
    }

    final selected = c.selectedDate;
    final selectedKey = selected == null
        ? ''
        : '${selected.year}-${selected.month}-${selected.day}';
    final selectedEvents = events[selectedKey] ?? <Doc>[];

    final calendar = AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Previous month',
                onPressed: () {
                  setState(() {
                    c.calendarMonth = DateTime(
                      c.calendarMonth.year,
                      c.calendarMonth.month - 1,
                    );
                    c.notify();
                  });
                },
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  '${_months[c.calendarMonth.month - 1]} ${c.calendarMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 17,
                    color: AppColors.ink,
                  ),
                ),
              ),
              IconButton(
                tooltip: 'Next month',
                onPressed: () {
                  setState(() {
                    c.calendarMonth = DateTime(
                      c.calendarMonth.year,
                      c.calendarMonth.month + 1,
                    );
                    c.notify();
                  });
                },
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          const SizedBox(height: 14),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 7,
            childAspectRatio: 1.25,
            children: [
              for (final day in [
                'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat',
              ])
                Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              for (var i = 0; i < 35; i++)
                _calendarCell(
                  start.add(Duration(days: i)),
                  events,
                  c,
                ),
            ],
          ),
        ],
      ),
    );

    final details = AppCard(
      padding: const EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _title(
            selected == null
                ? 'Select a date'
                : '${_months[selected.month - 1]} ${selected.day}, ${selected.year}',
            icon: Icons.event_note_outlined,
          ),
          const SizedBox(height: 12),
          if (selectedEvents.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No document deadlines on this day.',
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              ),
            )
          else
            ...selectedEvents.map(
              (d) => DocRow(
                doc: d,
                controller: c,
                onReviewText: widget.onReviewText,
                onEditDoc: widget.onEditDoc,
              ),
            ),
        ],
      ),
    );

    return PageShell(
      title: 'Calendar',
      description:
          'Monthly overview of document expiration milestones and renewal dates.',
      content: [
        LayoutBuilder(
          builder: (context, box) => box.maxWidth > 900
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: calendar),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: details),
                  ],
                )
              : Column(
                  children: [calendar, const SizedBox(height: 16), details],
                ),
        ),
      ],
    );
  }
}
